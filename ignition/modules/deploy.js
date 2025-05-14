const { ethers } = require("hardhat");

async function main() {
  const MockERC20 = await ethers.getContractFactory("MockERC20");
  const mockToken = await MockERC20.deploy("Mock Token", "MTK", "0x9cc68505B2fa69a936E032B12c654E5bA8b52bcE", ethers.parseEther("1000"));
  console.log("Mock Token deployed to:", mockToken.address);
}

// execute the script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });