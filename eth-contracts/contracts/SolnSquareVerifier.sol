pragma solidity >=0.5.0;
import "../../zokrates/code/square/verifier.sol";
import "./ERC721Mintable.sol";




// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721Full{
    
    // Zokrates generated solidity contract
    Verifier public squareVerifier;

    string  _name;
    string _symbol;
    constructor(address verifierAddress, string memory name, string memory symbol) 
      ERC721Full(name, symbol)    
        public
    {   
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
            address to,
            uint256 tokenId
            // uint[2] memory a,
            // uint[2][2] memory b,
            // uint[2] memory c,
            // uint[2] memory input)
)               
             public
             returns (bool)
              {
        mint(to,tokenId);
        return true;
    // bytes32 key = keccak256(abi.encodePacked(a, b, c, input));

    // if(!uniqueSolutions[key].isExist){
    //   bool verification = squareVerifier.verifyTx(a, b, c,input);

    //     if(verification){
    //         addSolutionsToArray(key);
    //         // require(index < totalSupply(), "Invalid Token index"); 
    //         //  - make sure you handle metadata as well as tokenSuplly
    //     }
    //   }
    }
}