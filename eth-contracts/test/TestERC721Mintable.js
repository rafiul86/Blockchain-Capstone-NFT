const SolnSquareVerifier = artifacts.require('SolnSquareVerifier');
// const ERC721Enumerable = artifacts.require('ERC721Enumerable');
contract('TestERC721Mintable', accounts => {

    const account_one = accounts[0];
    const account_two = accounts[1];

    describe('match erc721 spec', function () {
        beforeEach(async function () { 
            // this.owner = account_one;
            // this.verifier = await this.verifier.new({from: this.owner})
            // this.contract = await SolnSquareVerifier.new(this.verifier.address ,{from: account_one});

            // TODO: mint multiple tokens
            // for (i = 1; i <= 10; i++) {
            //     if (i == 3 || i == 5) {
            //         await SolnSquareVerifier.mint(account_one, i, {from: account_one});
            //     }
                
            //     else {
            //         await SolnSquareVerifier.mint(account_two, i, {from: account_one});
            //     }
            // }
        })

        it('should return total supply', async function () { 
           let initialSupply = 1;
           let supplyCount = await SolnSquareVerifier.totalSupply()
           console.log(supplyCount, "madari")
           assert.equal(initialSupply, supplyCount, "Initial totalSupply should be 0")
        })

        // it('should get token balance', async function () { 
            
        // })

        // // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
        // it('should return token uri', async function () { 
            
        // })

        // it('should transfer token from one owner to another', async function () { 
            
        // })
    });

    // describe('have ownership properties', function () {
    //     beforeEach(async function () { 
    //         this.contract = await ERC721MintableComplete.new({from: account_one});
    //     })

    //     it('should fail when minting when address is not contract owner', async function () { 
            
    //     })

    //     it('should return contract owner', async function () { 
            
    //     })

    // });
})