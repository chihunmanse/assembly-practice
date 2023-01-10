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

  describe("Get", () => {
    it("Get Number", async () => {
      const number = await test1.getNumber();
      const numberYul = await test1.getNumberYul();

      expect(number).to.equal(numberYul);
    });
  });
});
