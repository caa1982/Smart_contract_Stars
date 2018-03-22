pragma solidity ^0.4.18;

import "./StorageGetter.sol";

contract StorageModifier is StorageGetter {
    
    modifier hasAccess() {
        require(accessAllowed[msg.sender] == true);
        _;
    }

    function allowAccess(address _address) hasAccess external {
        accessAllowed[_address] = true;
    }

    function denyAccess(address _address) hasAccess external {
        accessAllowed[_address] = false;
    }
    
    function changeTokenOwner(uint _tokenId, address _to) hasAccess external {
        tokens[_tokenId].tokenOwner = _to;
    }

    function changeTokenPrice(uint _tokenId, uint _tokenPrice) hasAccess external {
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

    function changeTokenName(uint _tokenId, bytes32 _tokenName) hasAccess external {
        tokens[_tokenId].tokenName = _tokenName;
    }

}