import { ethers } from "hardhat";
import { expect } from "chai";
import { Lock } from "typechain-types"; // El import de tipos generado

describe("Lock contract", function () {
  it("Should deploy and store the right unlock time", async function () {
    const [owner] = await ethers.getSigners();

    const unlockTime = (await ethers.provider.getBlock("latest")).timestamp + 1000;
    const LockFactory = await ethers.getContractFactory("Lock");
    const lock = (await LockFactory.deploy(unlockTime, { value: ethers.utils.parseEther("1") })) as Lock;

    expect(await lock.unlockTime()).to.equal(unlockTime);
    expect(await ethers.provider.getBalance(lock.address)).to.equal(ethers.utils.parseEther("1"));
  });
});