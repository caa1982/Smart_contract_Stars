pragma solidity ^0.4.19;

import "./StorageGetter.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

contract StorageModifier is StorageGetter {
    using SafeMath for uint;
    
    modifier platform() {
        require(accessAllowed[msg.sender] == true);
        _;
    }

    function allowAccess(address _address) platform external {
        accessAllowed[_address] = true;
    }

    function denyAccess(address _address) platform external {
        accessAllowed[_address] = false;
    }

    function changeTokenOwner(uint _tokenId, address _to) platform external {
        tokens[_tokenId].tokenOwner = _to;
    }

    function changeTokenPrice(uint _tokenId, uint _tokenPrice) platform external {
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

    function changeTokenName(uint _tokenId, bytes32 _tokenName) platform external {
        tokens[_tokenId].tokenName = _tokenName;
    }

}