require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/Pf_lGdmLksXF1SiaaA_LyeY8-N5QIA6o",
      accounts: ["0xb038e03f4d51672f1011ad8fc8562b091b6fbc30eee5b1aac9a269d0062c7df4"]
    }
  }
};
