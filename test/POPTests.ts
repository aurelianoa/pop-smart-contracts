import { expect } from "chai";
import { ethers } from "hardhat";
import { Signer } from "ethers";
import { TestReference, TestContract } from "../typechain-types";



describe("POP", function () {
    let owner: Signer;
    let eventOwner: Signer;
    let testReference: TestReference;
    let testContract: TestContract;

    beforeEach(async function () {
        [owner, eventOwner] = await ethers.getSigners();
        const testReferenceFactory = await ethers.getContractFactory("TestReference");
        testReference = await testReferenceFactory.deploy();
        const testContractFactory = await ethers.getContractFactory("TestContract");
        testContract = await testContractFactory.deploy();
    });

    it("should set and verify the reference contract", async function () {
        const referenceAddress = await testReference.getAddress();
        const testContractAddress = await testContract.getAddress();
        await testReference.registerReference(testContractAddress);
        
        expect(await testContract.verifyReference(referenceAddress)).to.equal(true);
    });
});
