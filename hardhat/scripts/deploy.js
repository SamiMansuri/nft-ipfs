const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  const metadataURL = "ipfs://Qmbygo38DWF1V8GttM1zy89KzyZTPU2FLUzQtiDvB7q6i5";

  const lw3PunksContract = await ethers.deployContract("LW3Punks", [
    metadataURL,
  ]);

  await lw3PunksContract.waitForDeployment();

  console.log("LW3Punks Contract Address:", lw3PunksContract.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
