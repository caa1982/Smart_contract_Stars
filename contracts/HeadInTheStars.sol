pragma solidity ^0.4.17;

import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import "./ERC721Token.sol";

contract HeadInTheStars is Ownable, ERC721Token {
  
  // Mapping from tokenId to TokenPrice
  mapping (uint256 => uint256) private tokenPrice;

  uint public initStarsPrice;
  uint public initPlanetsPrice;
  uint public initDwarfPlanetsPrice;
  uint public initSatellitesPrice;
  uint public initExoplanetsPrice;

  function HeadInTheStars(uint[] _sun, uint[] _initPrice) public {
    initStarsPrice = _initPrice[0];
    initPlanetsPrice = _initPrice[1];
    initDwarfPlanetsPrice = _initPrice[2];
    initSatellitesPrice = _initPrice[3];
    initExoplanetsPrice = _initPrice[4];

    tokenPrice[_sun[1]] = _sun[2];

    addToken(msg.sender, _sun[1]);
    Transfer(0x0, msg.sender, _sun[1]);
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
  function mint(uint256 _tokenId, string _tokenType, uint256 _tokenPrice) payable public {
    require(msg.value > 0);
    require(isTheInitialPriceCorrect(_tokenId,  _tokenType));
    require(msg.sender != address(0));

    addToken(msg.sender, _tokenId);
    Transfer(0x0, msg.sender, _tokenId);

    tokenPrice[_tokenId] = _tokenPrice;
    owner.transfer(msg.value);
  }

  function ChangeTokenPriceByOwner(uint256 _tokenId, uint256 _tokenPrice) public onlyOwnerOf(_tokenId) {
      tokenPrice[_tokenId] = _tokenPrice;
  }

  function ChangeTokenPrice(uint256 _tokenId, uint256 _tokenPrice) public onlyOwner {
      tokenPrice[_tokenId] = _tokenPrice;
  }
  
  function isTheInitialPriceCorrect(uint256 _tokenId, string _tokenType) internal returns (bool) {

    if(keccak256(_tokenType) == keccak256("star")) {
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
  
  function buyTokens(uint[] _tokensId, uint[] _newTokensPrice) public payable{
    require(_tokensId.length <= 5);
    require(_tokensId.length == _newTokensPrice.length);

    for (uint i=0; i<_tokensId.length; i++) {
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
  
  function isTheCorrectPrice(uint256 _tokenId) internal returns(bool) {
    return tokenPrice[_tokenId] == msg.value;
  }

  function tokenPriceOf(uint256 _tokenId) public view returns (uint) {
    uint price = tokenPrice[_tokenId];
    require(price > 0);
    return price;
  }

}