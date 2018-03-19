pragma solidity ^0.4.17;

import '../node_modules/zeppelin-solidity/contracts/lifecycle/Destructible.sol';
import "./ERC721Token.sol";

contract HeadInTheStars is ERC721Token, Destructible {
  
  // Mapping from tokenId to TokenPrice
  mapping (uint256 => uint256) public tokenPrice;

  // Mapping from tokenId to Object Name / object HD eg. star HD888 or planet name mars
  mapping (uint256 => string) public tokenName;
  
  uint public initStarsPrice;
  uint public initPlanetsPrice;
  uint public initDwarfPlanetsPrice;
  uint public initSatellitesPrice;
  uint public initExoplanetsPrice;

  function HeadInTheStars(uint[] _sun, string _tokenName, uint[] _initPrice) public {
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
  function mint(uint256 _tokenId, string _tokenType, uint256 _tokenPrice, string _tokenName) payable public {
    require(msg.value > 0);
    require(isTheInitialPriceCorrect(_tokenId,  _tokenType));
    require(msg.sender != address(0));

    addToken(msg.sender, _tokenId);
    Transfer(0x0, msg.sender, _tokenId);

    tokenName[_tokenId] = _tokenName;
    tokenPrice[_tokenId] = _tokenPrice;
    owner.transfer(msg.value);
  }

  function mintTokens(uint[] _tokensId, string[] _tokensType, uint[] _tokensPrice, string[] _tokensName) payable external {
    require(_tokensId.length <= 5);
    require(_tokensId.length == _tokensType.length);
    require(_tokensId.length == _tokensPrice.length); 

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
  
  function isTheInitialPriceCorrect(uint256 _tokenId, string _tokenType) internal view returns (bool) {

    if (keccak256(_tokenType) == keccak256("star")) {
      require(_tokenId >= 1 && _tokenId <= 98826);
      return initStarsPrice == msg.value;

    } else if (keccak256(_tokenType) == keccak256("exoplanet")) {
      require(_tokenId >= 98853 && _tokenId <= 102363);
      return initExoplanetsPrice == msg.value;

    } else if (keccak256(_tokenType) == keccak256("satellite")) {
      require(_tokenId >= 98846 && _tokenId <= 98852);
      return initSatellitesPrice == msg.value;

    } else if (keccak256(_tokenType) == keccak256("planet")) {
      require(_tokenId >= 98827 && _tokenId <= 98845);
      return initPlanetsPrice == msg.value;

    } else if (keccak256(_tokenType) == keccak256("dwarfPlanet")) {
      require(_tokenId >= 102364 && _tokenId <= 102374);
      return initDwarfPlanetsPrice == msg.value;

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
    string memory name = tokenName[_tokenId];
    return name;
  }

  // change tokenName
  
  //only owner can mint a completly new token

}