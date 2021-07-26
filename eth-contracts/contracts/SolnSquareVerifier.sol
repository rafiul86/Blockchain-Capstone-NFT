pragma solidity >=0.5.0;
import "../../zokrates/code/square/verifier.sol";
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
    bytes32 index;
    address account;
    bool isExist;
}

// TODO define an array of the above struct


// TODO define a mapping to store unique solutions submitted
mapping (bytes32 => Solution) uniqueSolutions;


// TODO Create an event to emit when a solution is added
event SolutionAdded(bytes32 index, address account);

 
// TODO Create a function to add the solutions to the array and emit the event
function addSolutionsToArray(bytes32 key) public returns(bool){
    require(uniqueSolutions[key].account != msg.sender, "Solution is not unique.");
    uniqueSolutions[key] = Solution({index: key, account: msg.sender, isExist: true});
    emit SolutionAdded(key, msg.sender);
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

    bytes32 key = keccak256(abi.encodePacked(a, b, c, input));

    if(!uniqueSolutions[key].isExist){
      bool verification = squareVerifier.verifyTx(a, b, c,input);

        if(verification){
            addSolutionsToArray(key);
            require(index < totalSupply(), "Invalid Token index");
            mint(msg.sender,tokenId);
            //  - make sure you handle metadata as well as tokenSuplly
            setTokenURI(tokenId);
            return true;
        }
     }
    }
}
// //  TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
// contract  Verifier{
//         function verifyTx(
//         uint[2] memory a,
//         uint[2][2] memory b,
//         uint[2] memory c,
//         uint[2] memory input
//         ) public returns (bool r);
// }
