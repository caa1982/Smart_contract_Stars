pragma solidity ^0.4.19;

import "./StorageGetter.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

contract StorageModifier is StorageGetter {
    using SafeMath for uint256;

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

    function changeTokenPrice(uint256 _tokenId, uint256 _tokenPrice) external platform {
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

    function changeTokenName(uint256 _tokenId, bytes32 _tokenName) external platform {
        tokens[_tokenId].tokenName = _tokenName;
    }

    function changeTokenApproval(uint256 _tokenId, address _to) external platform {
        tokens[_tokenId].tokenApproval = _to;
    }

    function changeOwnedTokens(uint256 _tokenId, address _to) external platform {
        ownedTokens[_to].push(_tokenId);
    }

    function ChangeOwnedTokensIndex(uint256 _tokenId, uint256 _length) external platform {
        ownedTokensIndex[_tokenId] = _length;
    }

    function ChangeTotalTokens() external platform {
        totalTokens = totalTokens.add(1);
    }

}