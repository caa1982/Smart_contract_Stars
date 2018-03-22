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

  beforeEach(() =>
   
      Mintable.new(deployDetails.initPrice, ERC721Token.address, { from: owner })
        .then(instance => {
          contractMintable = instance;
          console.log("1", contractMintable.address)
          ERC721Token.new()
            .then(inst => {
              contractERC721 = inst;
              console.log("2", contractMintable.address)
              inst.allowAccess(contractMintable.address);
            })
        })
  
  );

// it("Should be own by the owner", () =>
//   contractERC721.accessAllowed(contractMintable.address).then(bool => {
//     assert.equal(bool, true, "Contract is not owned by the owner");
//   })
// );

// // it("Should have the correct price for the sun", () =>
// //   contractERC721.tokenPriceOf(1).then(price => {
// //     assert.equal(price, deployDetails.sun[1], "the Sun Price is incorrect");
// //   })
// // );

// it("Should have the correct mount of tokens", () =>
//   contractERC721.totalSupply().then(amount => {
//     assert.equal(amount, 0, "the amount of tokens should be 1");
//   })
// );

it("Should be able to mint a star token", async () => {
  await contractMintable.mintTokens([2, 3], ["star", "star"], [2500000000000000000, 2500000000000000000], ["HD1", "HD2"], {from: account1, value: deployDetails.initPrice[0]*2});
  contractERC721.ownerOf(2).then(_owner => {
      assert.equal(_owner, account1, "it should have created a star token");
  })
});

// it("Should be able to mint a Planet token", async () => {
//   await contract.mint(98827, "planet", 2500000000000000000, "Mars", {from: account1, value: deployDetails.initPrice[1]});
//   contract.ownerOf(98827).then(_owner => {
//       assert.equal(_owner, account1, "it should have created a planet token");
//   })
// });

// it("Should be able to mint an array of token and return the correct Name", async () => {
//   await contractMintable.mintTokens([6, 2, 3], ["star", "star", "star"], [2500000000000000000, 2500000000000000000, 2500000000000000000], ["Mars", "Venus", "Venus"], { from: account1, value: deployDetails.initPrice[0] * 3 });
//   contractERC721.tokenNameOf(6).then(_name => {
//     assert.equal(_name, "Mars", "it should have created a planet token");
//   })
// });

});
