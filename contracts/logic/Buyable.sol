pragma solidity ^0.4.19;

import "../ERC721/ERC721Token.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../node_modules/zeppelin-solidity/contracts/lifecycle/Destructible.sol";


contract Buyable is Destructible {
    using SafeMath for uint256;

    ERC721Token tokenERC721;

    uint public amount;
    
    event BuyTokens(address exOwner, address newOwner, uint id);

    function buyTokens(uint[] _tokensId, uint[] _newTokensPrice) payable external {
        require(msg.value > 0);
        require(msg.sender != address(0));
        require(_tokensId.length <= 5);
        require(_tokensId.length == _newTokensPrice.length);

        amount = msg.value;

        for ( uint i = 0; i < _tokensId.length; i++ ) {
            require(isTheCorrectPrice(_tokensId[i]));

            address exOwner = tokenERC721.ownerOf(_tokensId[i]);

            tokenERC721.clearApproval(exOwner, _tokensId[i]);
            tokenERC721.removeToken(exOwner, _tokensId[i]);
            tokenERC721.addToken(msg.sender, _tokensId[i]);
            BuyTokens(exOwner, msg.sender, _tokensId[i]);
        }

        require(amount == 0);
        
        //substract Trading fees is 1%
        exOwner.transfer(msg.value.sub((msg.value).div(100)));

        //send trading fee to contract Owner
        owner.transfer((msg.value).div(100));

    }
    
    function isTheCorrectPrice(uint _tokenId) internal returns(bool) {
        
        uint tokenPrice = tokenERC721.tokenPriceOf(_tokenId);
        bool isTrue = tokenPrice <= amount;

        amount = amount.sub(tokenPrice);
        
        return isTrue;
    }

}