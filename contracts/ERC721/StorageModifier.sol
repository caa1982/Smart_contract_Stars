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

    function changeTokenOwner(uint _tokenId, uint _to) platform external {
        tokens[_tokenId].TokenOwner = _to;
    }

    function changeTokenPrice(uint _tokenId, uint _tokenPrice) platform external {
        tokens[_tokenId].tokenPrice = _tokenPrice;
    }

    function changeTokenName(uint _tokenId, bytes32 _tokenName) platform external {
        tokens[_tokenId].tokenName = _tokenName;
    }

    function changeTokenApproval(uint _tokenId, address _to) platform external {
        tokens[_tokenId].tokenApproval = _to;
    }

    function pushOwnedTokens(uint _tokenId, address _to) platform external {
        ownedTokens[_to].push(_tokenId);
    }

    function changeLastTokenOwned(uint _tokenId, address _from)  platform external {
        require(tokens[_tokenId].tokenOwner == _from);

        uint tokenIndex = ownedTokensIndex[_tokenId];
        uint lastTokenIndex = lastTokenIndex = balanceOf(_from).sub(1);
        uint lastToken = ownedTokens[_from][lastTokenIndex];
        
        ownedTokens[_from][tokenIndex] = lastToken;
        ownedTokens[_from][lastTokenIndex] = 0;
        ownedTokens[_from].length--;
    }

    function changeLastOwnedTokensIndex(uint _tokenId, address _from)  platform external {
        require(tokens[_tokenId].tokenOwner == _from);

        uint tokenIndex = ownedTokensIndex[_tokenId];
        uint lastToken = ownedTokens[_from][lastTokenIndex];

        ownedTokensIndex[_tokenId] = 0;
        ownedTokensIndex[lastToken] = tokenIndex;
    }
    
    function changeOwnedTokensIndex(uint _tokenId, uint _length) platform external {
        ownedTokensIndex[_tokenId] = _length;
    }

    function addTotalTokens(uint _amount) platform external {
        totalTokens = totalTokens.add(_amount);
    }

    function subTotalTokens(uint _amount)  platform external {
        totalTokens = totalTokens.sub(_amount);
    }

}