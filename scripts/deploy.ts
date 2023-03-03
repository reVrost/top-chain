import { ethers } from "hardhat";
// @ts-ignore
import { MyERC721, MyERC721__factory } from "../typechain-types";

async function deploy() {
  // get deployer
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // check account balance
  console.log(
    "Account balance:",
    ethers.utils.formatEther(await deployer.getBalance())
  );

  // deploy MyERC721 contract
  const MyERC721: MyERC721__factory = await ethers.getContractFactory(
    "MyERC721"
  );
  const contract: MyERC721 = await MyERC721.connect(deployer).deploy(
    deployer.address, // owner
    "Imaginary Immutable Iguanas", // name
    "III", // symbol
    "https://example-base-uri.com/", // baseURI
    "https://example-contract-uri.com/" // contractURI
  );
  await contract.deployed();

  // log deployed contract address
  console.log(`MyERC721 contract deployed to ${contract.address}`);
}

deploy().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
