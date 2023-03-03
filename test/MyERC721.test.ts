import { ethers } from "hardhat";
import { expect } from "chai";
// @ts-ignore
import { MyERC721 } from "../typechain-types";

describe("MyERC721", function () {
  let contract: MyERC721;

  beforeEach(async function () {
    // get owner (first account)
    const [owner] = await ethers.getSigners();

    // deploy MyERC721 contract
    const MyERC721 = await ethers.getContractFactory("MyERC721");
    contract = await MyERC721.deploy(
      owner.address, // owner
      "Imaginary Immutable Iguanas", // name
      "III", // symbol
      "https://example-base-uri.com/", // baseURI
      "https://example-contract-uri.com/" // contractURI
    );
    await contract.deployed();

    // grant owner the minter role
    await contract.grantRole(await contract.MINTER_ROLE(), owner.address);
  });

  it.skip("Should be deployed with the correct arguments", async function () {
    expect(await contract.name()).to.equal("Imaginary Immutable Iguanas");
    expect(await contract.symbol()).to.equal("III");
    expect(await contract.baseURI()).to.equal("https://example-base-uri.com/");
    expect(await contract.contractURI()).to.equal(
      "https://example-contract-uri.com/"
    );
  });

  // it("Account with minter role should be able to mint multiple NFTs", async function () {
  //   const [owner, recipient] = await ethers.getSigners();
  //   await contract.connect(owner).permissionedMint(recipient.address, 5);
  //   expect(await contract.balanceOf(recipient.address)).to.equal(5);
  //   expect(await contract.ownerOf(1)).to.equal(recipient.address);
  //   expect(await contract.ownerOf(2)).to.equal(recipient.address);
  //   expect(await contract.ownerOf(3)).to.equal(recipient.address);
  //   expect(await contract.ownerOf(4)).to.equal(recipient.address);
  //   expect(await contract.ownerOf(5)).to.equal(recipient.address);
  // });

  it("medata ", async function () {
    const [owner, recipient] = await ethers.getSigners();
    const md = "ewogICJkZXNjcmlwdGlvbiI6ICJGcmllbmRseSBPcGVuU2VhIENyZWF0dXJlIHRoYXQgZW5qb3lzIGxvbmcgc3dpbXMgaW4gdGhlIG9jZWFuLiIsIAogICJleHRlcm5hbF91cmwiOiAiaHR0cHM6Ly9vcGVuc2VhY3JlYXR1cmVzLmlvLzMiLCAKICAiaW1hZ2UiOiAiaHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL29wZW5zZWEtcHJvZC5hcHBzcG90LmNvbS9wdWZmcy8zLnBuZyIsIAogICJuYW1lIjogIkRhdmUgU3RhcmJlbGx5Igp9"
    let tokenID = await contract.connect(owner).permissionedMint2(recipient.address, md);

    console.log("token id", tokenID)
    expect(await contract.getMetadataOf(1)).to.equal(md);
  });
  it("dynamic  ", async function () {
    const [owner, recipient] = await ethers.getSigners();

    const desc = "yayyyy "
    const md = "data:image/webp;base64,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"
    let tokenID = await contract.connect(owner).permissionedMint3(recipient.address, desc, md);

    console.log("token id", tokenID)
    expect(await contract.getMetadataOf(1)).to.equal(`data:application/json;base64,${md}`);
  });

  // it("Account without minter role should not be able to mint NFTs", async function () {
  //   const [_, acc1] = await ethers.getSigners();
  //   const minterRole = await contract.MINTER_ROLE();
  //   await expect(
  //     contract.connect(acc1).permissionedMint(acc1.address, 1)
  //   ).to.be.revertedWith(
  //     `AccessControl: account 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 is missing role ${minterRole}`
  //   );
  // });
});
