const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MockERC20", function () {
  let mockToken;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    const MockERC20 = await ethers.getContractFactory("MockERC20");
    [owner, addr1, addr2] = await ethers.getSigners();
    mockToken = await MockERC20.deploy("Mock Token", "MTK", owner.address, ethers.parseEther("1000"));
  });

  describe("Deployment", function () {
    it("Should set the correct name and symbol", async function () {
      expect(await mockToken.name()).to.equal("Mock Token");
      expect(await mockToken.symbol()).to.equal("MTK");
    });
    it("Should assign the initial balance", async function () {
      const balance = await mockToken.balanceOf(owner.address);
      expect(balance).to.equal(ethers.parseEther("1000"));
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      await mockToken.transfer(addr1.address, ethers.parseEther("100"));
      const addr1Balance = await mockToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(ethers.parseEther("100"));
    });
    it("Should approve tokens for spending", async function () {
      await mockToken.approve(addr1.address, ethers.parseEther("50"));
      const allowance = await mockToken.allowance(owner.address, addr1.address);
      expect(allowance).to.equal(ethers.parseEther("50"));
    });
    it("Should transfer tokens from one account to another", async function () {
      await mockToken.approve(addr1.address, ethers.parseEther("50"));
      await mockToken.connect(addr1).transferFrom(owner.address, addr2.address, ethers.parseEther("50"));
      const addr2Balance = await mockToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(ethers.parseEther("50"));
    });
  });
});