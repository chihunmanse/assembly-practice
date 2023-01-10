/** @format */

import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";
import { ethers, expect } from "hardhat";

describe("Test1", () => {
  let admin: SignerWithAddress, notAdmin: SignerWithAddress;
  let test1: Contract;

  before(async () => {
    [admin, notAdmin] = await ethers.getSigners();

    const Test1 = await ethers.getContractFactory("Test1");
    test1 = await Test1.deploy();
    await test1.deployed();
  });

  describe("Number", () => {
    it("Get Number", async () => {
      const number = await test1.getNumber();
      const numberYul = await test1.getNumberYul();

      expect(number).to.equal(numberYul);
    });

    it("Set Number", async () => {
      const setNumberTx = await test1.setNumber(2);
      await setNumberTx.wait();

      expect(await test1.getNumber()).to.equal(2);

      const setNumberYulTx = await test1.setNumberYul(3);
      await setNumberYulTx.wait();

      expect(await test1.getNumber()).to.equal(3);
    });
  });

  describe("Revert", () => {
    it("Revert Test", async () => {
      const revertTestTx = test1.revertTest();

      await expect(revertTestTx).to.revertedWithCustomError(
        test1,
        "RevertTest"
      );
    });

    it("Revert Test Yul", async () => {
      const revertTestYulTx = test1.revertTestYul();

      await expect(revertTestYulTx).to.revertedWithCustomError(
        test1,
        "RevertTest"
      );
    });
  });
});
