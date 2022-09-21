const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Borrower", () => {
  beforeEach(async () => {
    accounts = await ethers.getSigners();
    deployer = accounts[0];

    const TokenContract = await ethers.getContractFactory("Token");
    const Lender = await ethers.getContractFactory("Lender");
    const Borrower = await ethers.getContractFactory("Borrower");

    token = await TokenContract.deploy();
    await token.deployed();
    lender = await Lender.deploy(token.address, 10, 1000);
    borrower = await Borrower.deploy(lender.address, token.address);

    //console.log(`Token Deployed at: ${token.address}`);
    //console.log(`Lender Deployed at: ${lender.address}`);
    //console.log(`Borrower Deployed at: ${borrower.address}`);
  });

  it("checks the token symbol.", async () => {
    expect(token.symbol == "MTK");
  });

  it("deployer has all the supply", async () => {
    expect(token.balanceOf(deployer.address) == token.totalSupply_);
  });

  it("transfers 5 tokens from deployer to lender", async () => {
    await token.transferFrom(deployer.address, lender.address, 5);
    //let transaction = await lender.connect(deployer).depositTokens(5);
    expect(token.balanceOf(deployer.address) == token.totalSupply_ - 5);
    expect(token.balanceOf(lender.address) == 5);

    borrower.action();

    expect(token.balanceOf(lender.address) == 5);
  });
});
