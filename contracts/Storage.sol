pragma solidity ^0.4.19;

contract Storage {
    // Total amount of tokens
    uint256 public totalTokens;

    // Mapping from token ID to owner
    mapping (uint256 => address) public tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) public tokenApprovals;

    // Mapping from owner to list of owned token IDs
    mapping (address => uint256[]) public ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) public ownedTokensIndex;

    // Mapping from tokenId to TokenPrice
    mapping (uint256 => uint256) public tokenPrice;

    // Mapping from tokenId to ObjectName / objectHD eg. star HD888 or planet mars
    mapping (uint256 => bytes32) public tokenName;
    
    uint public initStarsPrice;
    uint public initPlanetsPrice;
    uint public initDwarfPlanetsPrice;
    uint public initSatellitesPrice;
    uint public initExoplanetsPrice;

    uint public amount;
}