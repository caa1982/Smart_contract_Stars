pragma solidity ^0.4.18;

contract Storage {

    // Total amount of tokens
    uint public totalTokens;
    
    struct Token {
        address tokenOwner;
        uint tokenPrice;
        bytes32 tokenName;
        bytes32 tokenType;
        address tokenApproval;
    }
    //mapping from tokenID to token details
    mapping (uint => Token) tokens;

    // Mapping from owner to list of owned token IDs
    mapping (address => uint[]) public ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint => uint) public ownedTokensIndex;

    // Mapping to allow access to change Storage
    mapping(address => bool) public accessAllowed;
    
    function Storage() public {
        accessAllowed[msg.sender] = true;
        accessAllowed[this] = true;
    }

}