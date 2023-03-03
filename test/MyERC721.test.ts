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
      "https://example-contract-uri.com/", // contractURI,
    );
    await contract.deployed();

    // grant owner the minter role
    await contract.grantRole(await contract.MINTER_ROLE(), owner.address);
  });

  it("Should be deployed with the correct arguments", async function () {
    expect(await contract.name()).to.equal("Imaginary Immutable Iguanas");
    expect(await contract.symbol()).to.equal("III");
    expect(await contract.baseURI()).to.equal("https://example-base-uri.com/");
    expect(await contract.contractURI()).to.equal(
      "https://example-contract-uri.com/"
    );
  });

  it("Account with minter role should be able to mint multiple NFTs", async function () {
    const [owner, recipient] = await ethers.getSigners();
    await contract.connect(owner).permissionedMint(recipient.address, 5);
    expect(await contract.balanceOf(recipient.address)).to.equal(5);
    expect(await contract.ownerOf(1)).to.equal(recipient.address);
    expect(await contract.ownerOf(2)).to.equal(recipient.address);
    expect(await contract.ownerOf(3)).to.equal(recipient.address);
    expect(await contract.ownerOf(4)).to.equal(recipient.address);
    expect(await contract.ownerOf(5)).to.equal(recipient.address);
  });

  it("Test that metadata exists for nft that is minted by permissionedMintWithMetadata", async function () {
    const [owner, recipient] = await ethers.getSigners();
    const desc = "yayyyy";

    let tokenId = 0
    await new Promise(async res => {
      contract.on('Transfer', (_from: any, _to: any, tokenIdOnEvent) => {
        tokenId = Number(tokenIdOnEvent)
        console.log(tokenId)
        res('')
      })

      try {
        await contract
          .connect(owner)
          .permissionedMintWithMetadata(recipient.address, desc, {
            value: 1000
          })
      } catch (e) {
        console.log(e)
      }
    })

    const decode = (str: string): string =>
      Buffer.from(str, "base64").toString();

    const [_, data] = (await contract.getMetadataOf(tokenId)).split("base64,");
    const json = JSON.parse(decode(data));
  });

  it("Account without minter role should not be able to mint NFTs", async function () {
    const [_, acc1] = await ethers.getSigners();
    const minterRole = await contract.MINTER_ROLE();
    await expect(
      contract.connect(acc1).permissionedMint(acc1.address, 1)
    ).to.be.revertedWith(
      `AccessControl: account 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 is missing role ${minterRole}`
    );
  });
});
