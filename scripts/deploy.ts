import { ethers } from "hardhat";

async function main() {
  const eventIndex = await ethers.deployContract("POPEventIndex");
  const eventContract = await ethers.deployContract("POPEvent");
  const badgeContract = await ethers.deployContract("POPBadge");

  await eventIndex.waitForDeployment();
  await eventContract.waitForDeployment();
  await badgeContract.waitForDeployment();

  console.log(
    `EventIndex with deployed to ${eventIndex.target}`
  );
  console.log(
    `Event with deployed to ${eventContract.target}`
  );
  console.log(
    `Badges with deployed to ${badgeContract.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
