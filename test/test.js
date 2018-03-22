const Mintable = artifacts.require("./Mintable.sol");
const ERC721Token = artifacts.require("./ERC721Token.sol");

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

    contractERC721.allowAccess(contractMintable.address);

  })

  it("Should be able to access the contract", () =>
    contractERC721.accessAllowed(contractMintable.address).then(bool => {
      assert.equal(bool, true, "contractMintable has no access");
    })
  );

  it("Should have the correct mount of tokens", () =>
    contractERC721.totalSupply().then(amount => {
      assert.equal(amount, 0, "the amount of tokens should be 0");
    })
  );

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
    await contractMintable.mintTokens([98827], ["planet"], [2500000000000000000], ["Mars"], {from: account1, value: deployDetails.initPrice[1]});
    contractERC721.ownerOf(98827).then(_owner => {
        assert.equal(_owner, account1, "it should have created a planet token");
    })
  });

});
