pragma solidity >=0.5.0;

// import "../../zokrates/code/square/verifier.sol";
import "./ERC721Mintable.sol";




// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721MintableComplete{
    string private _name;
    string private _symbol;
    string private _tokenURI;
    
    // Zokrates generated solidity contract
    Verifier public squareVerifier;

    constructor(address verifierAddress) public
    
    {       
            _name = "Rafiul Token";
            _symbol = "RHT";
            _tokenURI = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/";
            squareVerifier = Verifier(verifierAddress);
    }
// TODO define a solutions struct that can hold an index & an address
struct Solution{
    uint256 index;
    address account;
}

// TODO define an array of the above struct


// TODO define a mapping to store unique solutions submitted
mapping (uint => Solution) uniqueSolutions;


// TODO Create an event to emit when a solution is added
event SolutionAdded(uint256 index, address account);

// bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp));
// TODO Create a function to add the solutions to the array and emit the event
function addSolutionsToArray(uint256 index, address sender) public returns(bool){
    require(uniqueSolutions[index].account != sender, "Solution is not unique.");
    uniqueSolutions[index] = Solution({index: index, account: sender});
    emit SolutionAdded(index, sender);
    return true;
}


// TODO Create a function to mint new NFT only after the solution has been verified
function mintToken(
            uint256 tokenId,
            uint256 index, 
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[2] memory input)

             public
             returns (bool)
              {
//  - make sure the solution is unique (has not been used before)
    require(squareVerifier.verifyTx(a, b, c, input), "Can't mint a new token, Verification is failed");
    require(addSolutionsToArray(index, msg.sender), "solution used is not unique");
//  - make sure you handle metadata as well as tokenSuplly
    require(index < totalSupply(), "Invalid Token index");
    mint(msg.sender,tokenId);
    setTokenURI(tokenId);
    return true;
    }
}
//  TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract  Verifier{
        function verifyTx(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[2] memory input
        ) public returns (bool r);
}


  


























