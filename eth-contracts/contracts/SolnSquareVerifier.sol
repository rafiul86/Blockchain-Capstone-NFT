pragma solidity >=0.5.0;

import "../../zokrates/code/square/verifier.sol";
import "./ERC721Mintable.sol";
 // TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
// contract NewVerifier is Verifier{

// }


// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721MintableComplete{

Verifier public squareVerifier;
    constructor(address verifierAddress) public
    {
            squareVerifier = Verifier(verifierAddress);
    }
// TODO define a solutions struct that can hold an index & an address
struct Solution{
    uint256 index;
    address account;
    bool isExist;
}

// TODO define an array of the above struct


// TODO define a mapping to store unique solutions submitted
mapping (uint => Solution) uniqueSolutions;


// TODO Create an event to emit when a solution is added
event SolutionAdded(uint256 index, address account, bool isExist);


// TODO Create a function to add the solutions to the array and emit the event
function addSolutionsToArray(uint256 index, address sender) public returns(bool){
    require(!uniqueSolutions[index].isExist, "Solution is not unique.");
    uniqueSolutions[index] = Solution({index: index, account: sender, isExist: true});
    emit SolutionAdded(index, sender, true);
}


// TODO Create a function to mint new NFT only after the solution has been verified
function mintToken(uint256 tokenId, uint256 index) public {
//  - make sure the solution is unique (has not been used before)
    require(!uniqueSolutions[index].isExist, "Solution is not unique.");
//  - make sure you handle metadata as well as tokenSuplly
    require(index < totalSupply(), "Invalid Token index");
    mint(msg.sender,tokenId);
    setTokenURI(tokenId);
    uniqueSolutions[index].isExist = false;
    }

}


  


























