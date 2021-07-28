
var SolnSquareVerifier = artifacts.require('SolnSquareVerifier');
var SquareVerifier = artifacts.require('verifier');
const json = require('../../zokrates/code/square/proof.json');

contract('SolnSquareVerifier', accounts => {

    const account_one = accounts[0];
    const account_two = accounts[1];
    let proof = require('../../zokrates/code/square/proof.json');

    beforeEach(async function () {
        const tokenName = "rafiulToken"
        const tokenSymbol = "RTN"
        this.verifier = await SquareVerifier.new({ from: account_one });
        this.contract = await SolnSquareVerifier.new(this.verifier.address, tokenName, tokenSymbol);
    })

    // Test if a new solution can be added for contract - SolnSquareVerifier
    // it('Test if a new solution can be added for contract - SolnSquareVerifier', async function () {
    //     const { proof: { a, b, c }, inputs: input } = proof;

    //     let key = await this.verifier.generateKey.call(a, b, c, input);
    //     console.log("key", key);
    //     let result = await this.contract.addSolution(1, account_two, key);

    //     assert.equal(result.logs[0].event, 'SolutionAdded', "Error: no event emitted.");
    // })

    // Test if an ERC721 token can be minted for contract - SolnSquareVerifier
    it('Test if an ERC721 token can be minted for contract - SolnSquareVerifier', async function () {
        const { proof: { a, b, c }, inputs: input } = proof;

        let supplyBefore = (await this.contract.totalSupply.call()).toNumber();

        await this.contract.safeMint(account_two, 2, json.proof.a,json.proof.b,json.proof.c,json.inputs, {from: account_one});

        let supplyAfter = (await this.contract.totalSupply.call()).toNumber();
        let difference = supplyAfter - supplyBefore;

        assert.equal(difference, 1, "Error: an ERC721 token cannot be minted for contract - SolnSquareVerifier");
    })
})
