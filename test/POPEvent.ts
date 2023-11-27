import { expect } from "chai";
import { ethers } from "hardhat";
import { Signer } from "ethers";
import { POPEventIndex, POPEvent, POPBadge } from "../typechain-types";

describe.only("POPEvent", function () {
    let owner: Signer;
    let eventOwner: Signer;
    let user: Signer;
    let agent: Signer;
    let popEventIndex: POPEventIndex;
    let popEvent: POPEvent;
    let popBadge: POPBadge;
    let popEventAddress: string;
    let popEventIndexAddress: string;
    let popBadgeAddress: string;
    

    beforeEach(async function () {
        [owner, eventOwner, user, agent] = await ethers.getSigners();
        const popEventIndexFactory = await ethers.getContractFactory("POPEventIndex");
        popEventIndex = await popEventIndexFactory.deploy();
        const popEventFactory = await ethers.getContractFactory("POPEvent");
        popEvent = await popEventFactory.connect(eventOwner).deploy();
        const popBadgeFactory = await ethers.getContractFactory("POPBadge");
        popBadge = await popBadgeFactory.deploy();

        popEventIndexAddress = await popEventIndex.getAddress();
        popEventAddress = await popEvent.getAddress();
        popBadgeAddress = await popBadge.getAddress();
        await popEvent.registerReference(popEventIndexAddress);
        await popEventIndex.registerEvent(popEventAddress);
    });

    it("should set and verify the reference contract", async function () {       
        expect(await popEventIndex.verifyReference(popEventAddress)).to.equal(true);
    });

    it("should let user to getTicket", async function () {
        const amount = 1;
        await popEvent.connect(user).getTicket();
        expect(await popEvent.balanceOf(await user.getAddress())).to.equal(amount);
    });
    it("should checkIn the user", async function () {
        /// register the agent on the POPEvent contract
        await popEvent.connect(eventOwner).setAuthorizedAgent(await agent.getAddress(), true);
        /// register Badge on the POPEvent contract
        await popEvent.connect(eventOwner).setBadge(popBadgeAddress);
        /// get the ticket for the user
        await popEvent.connect(user).getTicket();
        /// checkIn the user
        await popEvent.connect(agent).checkIn(await user.getAddress(), popBadgeAddress);
        expect(await popEvent.balanceOf(await user.getAddress())).to.equal(0);
        expect(await popBadge.balanceOf(await user.getAddress())).to.equal(1n);
    });
});