pragma solidity ^0.4.19;

import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./ERC721Token.sol";
import "./ByteString.sol";

contract HeadInTheStars is ERC721Token, Ownable, ByteString {
  
    // Mapping from tokenId to TokenPrice
    mapping (uint256 => uint256) public tokenPrice;

    // Mapping from tokenId to ObjectName / objectHD eg. star HD888 or planet mars
    mapping (uint256 => bytes32) public tokenName;
    
    uint public initStarsPrice;
    uint public initPlanetsPrice;
    uint public initDwarfPlanetsPrice;
    uint public initSatellitesPrice;
    uint public initExoplanetsPrice;

    uint private amount;

    function HeadInTheStars(uint[] _sun, bytes32 _tokenName, uint[] _initPrice) public {
        initStarsPrice = _initPrice[0];
        initPlanetsPrice = _initPrice[1];
        initDwarfPlanetsPrice = _initPrice[2];
        initSatellitesPrice = _initPrice[3];
        initExoplanetsPrice = _initPrice[4];

        tokenPrice[_sun[0]] = _sun[1];
        tokenName[_sun[0]] = _tokenName;

        addToken(msg.sender, _sun[0]);
        Transfer(0x0, msg.sender, _sun[0]);
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

            addToken(msg.sender, _tokensId[i]);
            Transfer(0x0, msg.sender, _tokensId[i]);

            tokenName[_tokensId[i]] = _tokensName[i];
            tokenPrice[_tokensId[i]] = _tokensPrice[i];
        }

       require(amount == 0);
       owner.transfer(this.balance);
        
    }

    function changeTokenPriceByOwner(uint256 _tokenId, uint256 _tokenPrice) external onlyOwnerOf(_tokenId) {
        tokenPrice[_tokenId] = _tokenPrice;
    }

    function isTheInitialPriceCorrect(uint256 _tokenId, bytes32 _tokenType) internal returns (bool) {
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

    function buyTokens(uint[] _tokensId, uint[] _newTokensPrice) external payable {
        require(msg.value > 0);
        require(msg.sender != address(0));
        require(_tokensId.length <= 5);
        require(_tokensId.length == _newTokensPrice.length);

        amount = msg.value;

        for ( uint i = 0; i < _tokensId.length; i++ ) {
            require(isTheCorrectPrice(_tokenId[i]));

            address exOwner = ownerOf(_tokenId[i]);

            clearApproval(exOwner, _tokenId[i]);
            removeToken(exOwner, _tokenId[i]);
            addToken(msg.sender, _tokenId[i]);
            Transfer(exOwner, msg.sender, _tokenId[i]);
        }

        require(amount == 0);
        
        //substract Trading fees is 1%
        exOwner.transfer(msg.value.sub((msg.value).div(100)));

        //send trading fee to contract Owner
        owner.transfer((msg.value).div(100));

    }
    
    function isTheCorrectPrice(uint256 _tokenId) internal returns(bool) {
        bool isTrue;

        isTrue = tokenPrice[_tokenId] <= amount;

        amount = amount.sub(tokenPrice[_tokenId])
        
        return isTrue;
    }

    function tokenPriceOf(uint256 _tokenId) external view returns (uint) {
        uint price = tokenPrice[_tokenId];
        require(price > 0);
        return price;
    }

    function tokenNameOf(uint256 _tokenId) external view returns (string) {
        bytes32 name = tokenName[_tokenId];
        return bytes32ToStr(name);
    }

    // change tokenName
    
    //only owner can mint a completly new token

}