pragma solidity ^0.4.19;

import "../node_modules/zeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "./ERC721Token.sol";

contract HeadInTheStars is ERC721Token, Destructible {
  
    // Mapping from tokenId to TokenPrice
    mapping (uint256 => uint256) public tokenPrice;

    // Mapping from tokenId to Object Name / object HD eg. star HD888 or planet name mars
    mapping (uint256 => bytes32) public tokenName;
    
    uint public initStarsPrice;
    uint public initPlanetsPrice;
    uint public initDwarfPlanetsPrice;
    uint public initSatellitesPrice;
    uint public initExoplanetsPrice;

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

    /**
    * @dev Mint token function
    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
    * @param _tokenPrice uint256 Price of the token for future sale in WEI to be minted by the msg.sender
    * @param _tokenType string eg. star, planet etc.
    */
    function mint(uint _tokenId, bytes32 _tokenType, uint _tokenPrice, bytes32 _tokenName) payable public {
        require(msg.value > 0);
        
        require(isTheInitialPriceCorrect(_tokenId,  _tokenType)); 
        require(msg.sender != address(0));

        addToken(msg.sender, _tokenId);
        Transfer(0x0, msg.sender, _tokenId);

        tokenName[_tokenId] = _tokenName;
        tokenPrice[_tokenId] = _tokenPrice;
        
        if(this.balance != 0) {
            owner.transfer(this.balance);
        }
    }

    function mintTokens(uint[] _tokensId, bytes32[] _tokensType, uint[] _tokensPrice, bytes32[] _tokensName) payable external {
        require(_tokensId.length <= 5);
        require(_tokensId.length == _tokensType.length);
        require(_tokensId.length == _tokensPrice.length); 
        require(_tokensId.length == _tokensName.length); 
        
        for ( uint i = 0; i < _tokensId.length; i++ ) {
            mint(_tokensId[i], _tokensType[i], _tokensPrice[i], _tokensName[i]);
        }
    }

    function changeTokenPriceByOwner(uint256 _tokenId, uint256 _tokenPrice) public onlyOwnerOf(_tokenId) {
        tokenPrice[_tokenId] = _tokenPrice;
    }

    function changeTokenPrice(uint256 _tokenId, uint256 _tokenPrice) public onlyOwner {
        tokenPrice[_tokenId] = _tokenPrice;
    }
    
    function isTheInitialPriceCorrect(uint256 _tokenId, bytes32 _tokenType) internal view returns (bool) {
        
        if (_tokenType == stringToBytes32("star")) {
            require(_tokenId >= 1 && _tokenId <= 98826);
            return initStarsPrice <= msg.value;

        } else if (_tokenType == stringToBytes32("exoplanet")) {
            require(_tokenId >= 98853 && _tokenId <= 102363);
            return initExoplanetsPrice <= msg.value;

        } else if (_tokenType == stringToBytes32("satellite")) {
            require(_tokenId >= 98846 && _tokenId <= 98852);
            return initSatellitesPrice <= msg.value;

        } else if (_tokenType == stringToBytes32("planet")) {
            require(_tokenId >= 98827 && _tokenId <= 98845); 
            
            return initPlanetsPrice <= msg.value;

        } else if (_tokenType == stringToBytes32("dwarfPlanet")) {
            require(_tokenId >= 102364 && _tokenId <= 102374);
            return initDwarfPlanetsPrice <= msg.value;

        }

        return false;

    }

    function buyTokens(uint[] _tokensId, uint[] _newTokensPrice) public payable {
        require(_tokensId.length <= 5);
        require(_tokensId.length == _newTokensPrice.length);

        for ( uint i = 0; i < _tokensId.length; i++ ) {
            buyToken(_tokensId[i], _newTokensPrice[i]);
        }
    }

    function buyToken(uint256 _tokenId, uint256 _newTokenPrice) public payable {
        require(isTheCorrectPrice(_tokenId));

        address exOwner = ownerOf(_tokenId);

        clearApproval(exOwner, _tokenId);
        removeToken(exOwner, _tokenId);
        addToken(msg.sender, _tokenId);
        Transfer(exOwner, msg.sender, _tokenId);

        tokenPrice[_tokenId] = _newTokenPrice;

        //substract Trading fees is 1%
        exOwner.transfer(msg.value.sub((msg.value).div(100)));

        //send trading fee to contract Owner
        owner.transfer((msg.value).div(100));
    }
    
    function isTheCorrectPrice(uint256 _tokenId) internal view returns(bool) {
        return tokenPrice[_tokenId] == msg.value;
    }

    function tokenPriceOf(uint256 _tokenId) public view returns (uint) {
        uint price = tokenPrice[_tokenId];
        require(price > 0);
        return price;
    }

    function tokenNameOf(uint256 _tokenId) public view returns (string) {
        bytes32 name = tokenName[_tokenId];
        return bytes32ToStr(name);
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

    function bytes32ToStr(bytes32 _bytes32) internal pure returns (string){
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
            }
        return string(bytesArray);
    }


    // change tokenName
    
    //only owner can mint a completly new token

}