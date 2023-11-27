import * as dotenv from "dotenv";
import { ethers } from "hardhat";
import { POPEventIndex, POPEvent, POPBadge } from "../typechain-types";

dotenv.config();
const eventIndexAddress = process.env.EVENT_INDEX_CONTRACT || '';
const eventAddress = process.env.EVENT_CONTRACT || '';
const badgeAddress = process.env.BADGE_CONTRACT || '';

let eventIndex: POPEventIndex;
let eventContract: POPEvent;
let badgeContract: POPBadge;

async function main() {
    const eventIndexFacotry = await ethers.getContractFactory("POPEventIndex");
    eventIndex = eventIndexFacotry.attach(eventIndexAddress) as POPEventIndex;
    const eventFacotry = await ethers.getContractFactory("POPEvent");
    eventContract = eventFacotry.attach(eventAddress) as POPEvent;
    const badgeFacotry = await ethers.getContractFactory("POPBadge");
    badgeContract = badgeFacotry.attach(eventAddress) as POPBadge;
    
    const tx = await eventContract.registerReference(eventIndexAddress)
    .catch((error) => {
        console.error(error);
    });
    console.log('Registering reference', tx);
    const tx2 = await eventContract.setBadge(badgeAddress)
    .catch((error) => {
        console.error(error);
    });
    console.log('Setting badge', tx2);

    const tx3 = await eventIndex.registerEvent(eventAddress)
    .catch((error) => {
        console.error(error);
    });
    console.log('Registering event', tx3);

    const tx4 = await eventContract.setAuthorizedAgent('0x862E845e7ac5e021d58bb7986500B12e7c4e5bB7', true)
    .catch((error) => {
        console.error(error);
    });
    console.log('Registering event', tx4);
    
    
    

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});