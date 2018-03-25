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
    
    function changeTokenOwner(uint256 _tokenId, address _to) onlyAllowedAddresses external {
        tokens[_tokenId].tokenOwner = _to;
    }

    function changeTokenPrice(uint256 _tokenId, uint256 _tokenPrice) onlyAllowedAddresses external {
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

    function changeTokenName(uint256 _tokenId, bytes32 _tokenName) onlyAllowedAddresses external {
        require(tokens[_tokenId].tokenType == 0x73746172);
        tokens[_tokenId].tokenName = _tokenName;
    }
    
    function createToken(uint256 _tokenId, bytes32 _tokenType, bytes32 _tokenName, uint256 _tokenPrice) onlyAllowedAddresses external {
        require(tokens[_tokenId].tokenType == 0);
        tokens[_tokenId].tokenType = _tokenType;
        tokens[_tokenId].tokenName = _tokenName;
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

}