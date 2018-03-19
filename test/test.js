const HeadInTheStars = artifacts.require("./HeadInTheStars.sol");

contract('HeadInTheStars', accounts => {

  const owner = accounts[0];
  const account1 = accounts[1];
  const account2 = accounts[2];
  let contract;

  const deployDetails = {
    sun: [1, 15000000000000000],
    initPrice: [15000000000000000, 1000000000000000000, 1000000000000000000, 1000000000000000000, 1000000000000000000]
  };

  beforeEach(() =>
    HeadInTheStars.new(deployDetails.sun, deployDetails.initPrice,{ from: owner })
      .then(instance => contract = instance)
  );

  it("Should be own by the owner", () =>
    contract.owner().then(_owner => {
      assert.equal(_owner, owner, "Contract is not owned by the owner");
    })
  );

  it("Should have the correct price for the sun", () =>
    contract.tokenPriceOf(1).then(price => {
      assert.equal(price, deployDetails.sun[1], "the Sun Price is incorrect");
    })
  );

  it("Should have the correct mount of tokens", () =>
    contract.totalSupply().then(amount => {
      assert.equal(amount, 1, "the amount of tokens should be 1");
    })
  );

  it("Should be able to mint a star token", async () => {
    await contract.mint(2, "star", 2500000000000000000, {from: account1, value: deployDetails.initPrice[0]});
    contract.ownerOf(2).then(_owner => {
        assert.equal(_owner, account1, "it should have created a star token");
    })
  });

  it("Should be able to mint a Planet token", async () => {
    await contract.mint(98827, "planet", 2500000000000000000, {from: account1, value: deployDetails.initPrice[1]});
    contract.ownerOf(98827).then(_owner => {
        assert.equal(_owner, account1, "it should have created a planet token");
    })
  });

});
