/** @format */

import { Contract } from "ethers";
import { ethers, expect } from "hardhat";

describe("GetterAndSetter", () => {
  let getterAndSetter: Contract;

  before(async () => {
    const GetterAndSetter = await ethers.getContractFactory("GetterAndSetter");
    getterAndSetter = await GetterAndSetter.deploy();
    await getterAndSetter.deployed();
  });

  describe("Getter", () => {
    it("Get Number", async () => {
      const number = await getterAndSetter.getNumber();

      expect(number).to.equal(5);
    });

    it("Get Number Of Array", async () => {
      const number = await getterAndSetter.getNumberOfArray(1);

      expect(number).to.equal(2);
    });

    it("Get Mapping Value", async () => {
      const value = await getterAndSetter.getMappingValue();

      expect(value).to.equal(100);
    });
  });

  describe("Getter", () => {
    it("Set Number", async () => {
      const setTx = await getterAndSetter.setNumber(10);
      await setTx.wait();

      const number = await getterAndSetter.getNumber();
      expect(number).to.equal(10);
    });

    it("Set Number Of Array", async () => {
      const setTx = await getterAndSetter.setNumberOfArray(1, 10);
      await setTx.wait();

      const number = await getterAndSetter.getNumberOfArray(1);
      expect(number).to.equal(10);
    });

    it("Set Number Of Array : Failed", async () => {
      const setTx = getterAndSetter.setNumberOfArray(3, 10);

      await expect(setTx).revertedWithoutReason();
    });

    it("Set Mapping Value", async () => {
      const setTx = await getterAndSetter.setMappingValue(200);
      await setTx.wait();

      const value = await getterAndSetter.getMappingValue();
      expect(value).to.equal(200);
    });
  });
});
