pragma solidity ^0.4.19;

import "../ERC721/ERC721Token.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../node_modules/zeppelin-solidity/contracts/lifecycle/Destructible.sol";


contract Buyable is Destructible {
    using SafeMath for uint256256;

    ERC721Token tokenERC721;
    
    event BuyTokens(address exOwner, address newOwner, uint256 id, uint256 Price);

    function () public payable {
        revert();
    }
    
    function buyTokens(uint256[] _tokensId, uint256[] _newTokensPrice) payable external {
        require(msg.value > 0);
        require(msg.sender != address(0));
        require(_tokensId.length <= 5);
        require(_tokensId.length == _newTokensPrice.length);

        uint256 amount = msg.value;

        for ( uint256 i = 0; i < _tokensId.length; i++ ) {
            require(tokenERC721.ownerOf(_tokensId[i] != msg.sender));
            require(tokenERC721.tokenPriceOf(_tokensId[i]) != 0);
            
            uint256 tokenPrice = tokenERC721.tokenPriceOf(_tokensId[i]);

            require(tokenPrice <= amount);

            if(amount != 0) {
                amount = amount.sub(tokenPrice);
            }
            
            address exOwner = tokenERC721.ownerOf(_tokensId[i]);
            
            //substract Trading fees is 1%
            exOwner.transfer(tokenPrice.sub(tokenPrice.div(100)));

            //send trading fee to contract Owner
            owner.transfer(tokenPrice.div(100));
            
            tokenERC721.clearApprovalAndTransfer(exOwner, msg.sender, _tokensId[i]);

            BuyTokens(exOwner, msg.sender, _tokensId[i], tokenPrice);
        }

        require(amount == 0);

    }

}