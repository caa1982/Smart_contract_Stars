const Mintable = artifacts.require("./Mintable.sol");
const ERC721Token = artifacts.require("./ERC721Token.sol");

const EVMrevert = require("./helpers/EVMrevert");
const EVMopcode = require("./helpers/EVMopcode");

require("chai")
  .use(require("chai-as-promised"))
  .should()

contract('Mintable', accounts => {

  const owner = accounts[0];
  const account1 = accounts[1];
  const account2 = accounts[2];
  let contractMintable;
  let contractERC721;

  const deployDetails = {
    initPrice: [15000000000000000, 1000000000000000000, 1000000000000000000, 1000000000000000000, 1000000000000000000]
  };

  beforeEach(async () => {

    contractERC721 = await ERC721Token.new();

    contractMintable = await Mintable.new(deployDetails.initPrice, contractERC721.address, { from: owner })

    await contractERC721.allowAccess(contractMintable.address);

    contractMintable.mintTokens([1], ["star"], [1000000000000000000], ["Sun"], {from: owner, value: deployDetails.initPrice[0]})

  })

  it("Should be able to access the contractERC721", () =>
    contractERC721.accessAllowed(contractMintable.address).then(bool => {
      assert.equal(bool, true, "contractMintable has no access");
    })
  );

  it("Should be able to access the contractERC721", () =>
    contractERC721.accessAllowed(owner).then(bool => {
      assert.equal(bool, true, "owner has no access");
    })
  );

  it("Should not be able to access directly the contractERC721", () =>
    contractERC721.accessAllowed(account1).then(bool => {
      assert.equal(bool, false, "owner has access");
    })
  );

  it("Should be the owner of the contract", () =>
    contractMintable.owner().then(_owner => {
      assert.equal(_owner, owner, "owner is not the owner of contractMintable");
    })
  );

  it("Should have the correct price for the sun", () =>
    contractERC721.tokenPriceOf(1).then(price => {
      assert.equal(price, 1000000000000000000, "the Sun Price is incorrect");
    })
  );

  it("Should have the correct amount of tokens", () =>
    contractERC721.totalSupply().then(amount => {
      assert.equal(amount, 1, "the amount of tokens should be 1");
    })
  );

  it("Should revert when minting a Planet token with a bad id 7", async () => {
    await contractMintable.mintTokens([7], ["planet"], [2500000000000000000], ["Mars"], {from: account1, value: deployDetails.initPrice[1]})
    .should.be.rejectedWith(EVMrevert)
  });

  it("Should revert when minting a Planet token with the wrong initial price", async () => {
    await contractMintable.mintTokens([98827], ["planet"], [2500000000000000000], ["Mars"], {from: account1, value: deployDetails.initPrice[0]})
    .should.be.rejectedWith(EVMopcode)
  });
  
  it("Should be able to mint tow stars token", async () => {
    await contractMintable.mintTokens([2, 3], ["star", "star"], [2500000000000000000, 2500000000000000000], ["HD1", "HD2"], { from: account1, value: deployDetails.initPrice[0] * 2 });
    contractERC721.ownerOf(2).then(_owner => {
      assert.equal(_owner, account1, "it should have created a star token");
    })
    contractERC721.ownerOf(3).then(_owner => {
      assert.equal(_owner, account1, "it should have created a star token");
    })
  });

  it("Should be able to mint one Planet token", async () => {
    await contractMintable.mintTokens([98827], ["planet"], [2500000000000000000], ["Mars"], {from: account1, value: 0});
    contractERC721.ownerOf(98827).then(_owner => {
        assert.equal(_owner, account1, "it should have created a planet token");
    })
  });

  it("Should be able to buy the Sun token", async () => {
    await contractMintable.buyTokens([1], [2000000000000000000], {from: account1, value: 1000000000000000000});
    contractERC721.ownerOf(1).then(_owner => {
        assert.equal(_owner, account1, "it should have been able to buy the star");
    })
  });

  it("Should revert when trying to buy the Sun token with the wrong price", async () => {
    await contractMintable.buyTokens([1], [2000000000000000000], {from: account1, value: 10000000000000000000})
    .should.be.rejectedWith(EVMrevert)
  });

});
