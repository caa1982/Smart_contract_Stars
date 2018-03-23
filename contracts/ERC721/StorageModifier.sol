pragma solidity ^0.4.18;

import "./StorageGetter.sol";

contract StorageModifier is StorageGetter {
    
    modifier onlyAllowedAddresses() {
        require(accessAllowed[msg.sender] == true);
        _;
    }

    function allowAccess(address _address) onlyAllowedAddresses external {
        accessAllowed[_address] = true;
    }

    function denyAccess(address _address) onlyAllowedAddresses external {
        accessAllowed[_address] = false;
    }
    
    function changeTokenOwner(uint _tokenId, address _to) onlyAllowedAddresses external {
        tokens[_tokenId].tokenOwner = _to;
    }

    function changeTokenPrice(uint _tokenId, uint _tokenPrice) onlyAllowedAddresses external {
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

    function changeTokenName(uint _tokenId, bytes32 _tokenName) onlyAllowedAddresses external {
        tokens[_tokenId].tokenName = _tokenName;
    }

}