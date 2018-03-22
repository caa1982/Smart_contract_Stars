pragma solidity ^0.4.19;

import "../ERC721/ERC721Token.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../node_modules/zeppelin-solidity/contracts/lifecycle/Destructible.sol";

contract Mintable is Destructible {
    using SafeMath for uint;
    
    uint public initStarsPrice;
    uint public initPlanetsPrice;
    uint public initDwarfPlanetsPrice;
    uint public initSatellitesPrice;
    uint public initExoplanetsPrice;

    uint public amount;

    ERC721Token tokenERC721;

    event MintTokens(address, uint);

    function Mintable(uint[] _sun, bytes32 _tokenName, uint[] _initPrice, address _tokenERC721Address) public {
        initStarsPrice = _initPrice[0];
        initPlanetsPrice = _initPrice[1];
        initDwarfPlanetsPrice = _initPrice[2];
        initSatellitesPrice = _initPrice[3];
        initExoplanetsPrice = _initPrice[4];
        
        tokenERC721 = ERC721Token(_tokenERC721Address);

        tokenERC721.changeTokenPrice(_sun[0], _sun[1]);
        tokenERC721.changeTokenName(_sun[0], _tokenName);

        tokenERC721.addToken(msg.sender, _sun[0]);
        MintTokens(msg.sender, _sun[0]);
    }

    function () public payable {
        revert();
    }

    function mintTokens(uint[] _tokensId, bytes32[] _tokensType, uint[] _tokensPrice, bytes32[] _tokensName) payable external {
        require(msg.value > 0);
        require(msg.sender != address(0));
        require(_tokensId.length > 0);
        require(_tokensId.length <= 5);
        require(_tokensId.length == _tokensType.length);
        require(_tokensId.length == _tokensPrice.length); 
        require(_tokensId.length == _tokensName.length); 
        
        amount = msg.value;

        for ( uint i = 0; i < _tokensId.length; i++ ) {
            require(isTheInitialPriceCorrect(_tokensId[i],  _tokensType[i])); 

            tokenERC721.addToken(msg.sender, _tokensId[i]);
            tokenERC721.changeTokenPrice(_tokensId[i], _tokensPrice[i]);
            tokenERC721.changeTokenName(_tokensId[i], _tokensName[i]);

            MintTokens(msg.sender, _tokensId[i]);
        }

        require(amount == 0);
        owner.transfer(this.balance);
        
    }

    function isTheInitialPriceCorrect(uint _tokenId, bytes32 _tokenType) internal returns (bool) {
        bool isTrue;

        if (_tokenType == stringToBytes32("star")) {
            require(_tokenId >= 1 && _tokenId <= 98826);
            
            isTrue = initStarsPrice <= amount;

            amount = amount.sub(initStarsPrice);

            return isTrue;

        } else if (_tokenType == stringToBytes32("exoplanet")) {
            require(_tokenId >= 98853 && _tokenId <= 102363);
            
            isTrue = initExoplanetsPrice <= amount;

            amount = amount.sub(initExoplanetsPrice);

            return isTrue;

        } else if (_tokenType == stringToBytes32("satellite")) {
            require(_tokenId >= 98846 && _tokenId <= 98852);

            isTrue = initSatellitesPrice <= amount;

            amount = amount.sub(initSatellitesPrice);
            
            return isTrue;

        } else if (_tokenType == stringToBytes32("planet")) {
            require(_tokenId >= 98827 && _tokenId <= 98845); 
            
            isTrue = initPlanetsPrice <= amount;

            amount = amount.sub(initPlanetsPrice);
            
            return isTrue;

        } else if (_tokenType == stringToBytes32("dwarfPlanet")) {
            require(_tokenId >= 102364 && _tokenId <= 102374);

            isTrue = initDwarfPlanetsPrice <= amount;

            amount = amount.sub(initDwarfPlanetsPrice);
            
            return isTrue;

        }

        return false;

    }

    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }

}