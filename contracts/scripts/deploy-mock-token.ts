// scripts/deploy-mock-token.ts
import { ethers } from "hardhat";

async function main() {
  const MockERC20 = await ethers.getContractFactory("MockERC20");
  const mockToken = await MockERC20.deploy("Mock DAI", "mDAI", ethers.utils.parseEther("1000000")
  );

  await mockToken.deployed();
  console.log(`MockERC20 desplegado en: ${mockToken.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});