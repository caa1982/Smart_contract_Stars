var ERC721Token = artifacts.require("./ERC721Token.sol");
var Mintable = artifacts.require("./Mintable.sol");

module.exports = function(deployer, network, wallet) {
    trezorTestAccount0 = "0x161108E8182a7F5EdB43CA2158521EeB109175d5";
    trezorAccount0 = "";
  
    if(network === "development"){
      icoFunds = wallet[0];
    } else if (network === "ropsten") {
      icoFunds = trezorTestAccount0;
    } else {
      //hard coded
      icoFunds = trezorAccount0;
    }
  
    const deployDetails = {
      initPrice: [15000000000000000, 100000000000000000000, 10000000000000000000, 10000000000000000000, 2500000000000000000]
    };
  
    deployer.deploy(Mintable, deployDetails.initPrice, ERC721Token.address)
    .then(() => 
      ERC721Token.deployed()
      .then( inst => {
        inst.allowAccess(Mintable.address) 
      })
    );
};
