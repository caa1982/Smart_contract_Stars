pragma solidity ^0.4.19;

import "./Buyable.sol";

contract Mintable is Buyable {
    
    uint256 public initStarsPrice;
    uint256 public initPlanetsPrice;
    uint256 public initDwarfPlanetsPrice;
    uint256 public initSatellitesPrice;
    uint256 public initExoplanetsPrice;

    uint256 private amount;
    
    event MintTokens(address from, uint256 id);
    
    function Mintable(uint256[] _initPrice, address _tokenERC721Address) public {
        initStarsPrice = _initPrice[0];
        initPlanetsPrice = _initPrice[1];
        initDwarfPlanetsPrice = _initPrice[2];
        initSatellitesPrice = _initPrice[3];
        initExoplanetsPrice = _initPrice[4];
        
        tokenERC721 = ERC721Token(_tokenERC721Address);
    }

    function mintTokens(uint256[] _tokensId, bytes32[] _tokensType, uint256[] _tokensPrice, bytes32[] _tokensName) payable external {
        require(msg.value > 0);
        require(msg.sender != address(0));
        require(_tokensId.length > 0);
        require(_tokensId.length <= 5);
        require(_tokensId.length == _tokensType.length);
        require(_tokensId.length == _tokensPrice.length); 
        require(_tokensId.length == _tokensName.length); 
        
        amount = msg.value;

        for ( uint256 i = 0; i < _tokensId.length; i++ ) {
            require(isTheInitialPriceCorrect(_tokensId[i],  _tokensType[i])); 
            
            tokenERC721.createToken(_tokensId[i], _tokensType[i], _tokensName[i], _tokensPrice[i]);
            tokenERC721.addToken(msg.sender, _tokensId[i]);

            MintTokens(msg.sender, _tokensId[i]);
        }

        require(amount == 0);
        owner.transfer(this.balance);
        
    }

    function isTheInitialPriceCorrect(uint256 _tokenId, bytes32 _tokenType) internal returns (bool) {
        bool isTrue;

        if (_tokenType == stringToBytes32("star")) {
            require(_tokenId >= 1 && _tokenId <= 98826);
            
            isTrue = initStarsPrice <= amount;

            if(amount != 0) {
                amount = amount.sub(initStarsPrice);
            }

            return isTrue;

        } else if (_tokenType == stringToBytes32("exoplanet")) {
            require(_tokenId >= 98853 && _tokenId <= 102363);
            
            isTrue = initExoplanetsPrice <= amount;

            if(amount != 0) {
                amount = amount.sub(initExoplanetsPrice);
            }

            return isTrue;

        } else if (_tokenType == stringToBytes32("satellite")) {
            require(_tokenId >= 98827 && _tokenId <= 98845);

            isTrue = initSatellitesPrice <= amount;

            if(amount != 0) {
                amount = amount.sub(initSatellitesPrice);
            }
            
            return isTrue;

        } else if (_tokenType == stringToBytes32("planet")) {
            require(_tokenId >= 98846 && _tokenId <= 98852); 
            
            isTrue = initPlanetsPrice <= amount;

            if(amount != 0) {
                amount = amount.sub(initPlanetsPrice);
            }
            
            return isTrue;

        } else if (_tokenType == stringToBytes32("dwarfPlanet")) {
            require(_tokenId >= 102364 && _tokenId <= 102374);

            isTrue = initDwarfPlanetsPrice <= amount;

            if(amount != 0) {
                amount = amount.sub(initDwarfPlanetsPrice);
            }
            
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