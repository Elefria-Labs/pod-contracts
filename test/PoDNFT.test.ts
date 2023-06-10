import { expect } from "chai"
import { Signer } from "ethers"
import { ethers } from "hardhat"
import { PoDNFT } from "../build/typechain/PoDNFT"

describe("PoD NFT", () => {
  let accounts: Signer[]
  let podNftContract: PoDNFT
  let owner: Signer

  before(async () => {
    accounts = await ethers.getSigners()
    owner = accounts[0]
    const PoDNFT = await ethers.getContractFactory("PoDNFT")
    const podNft = await PoDNFT.deploy()
    podNftContract = await podNft.deployed()
  })

  it("Should be able mint NFT for a projectId", async () => {
    const receiver = await accounts[1].getAddress()
    const projectId = 1
    const uri = "https://ipfs.io/ipfs/bafkreier3f7aqqb4htzbjwcoir2ewmmt2zrepeuirqu4twla2iou4bn64u"
    const originAddr = ethers.constants.AddressZero
    const tokenId = 0
    expect(podNftContract.connect(owner).safeMint(receiver, projectId, uri))
      .to.emit(podNftContract, "safeTransferFrom")
      .withArgs(originAddr, receiver, tokenId)
  })

  it("Should not  be able mint NFT for a projectId by non owner", async () => {
    const receiver = await accounts[1].getAddress()
    const attacker = accounts[2]
    const projectId = 1
    const uri = "https://ipfs.io/ipfs/bafkreier3f7aqqb4htzbjwcoir2ewmmt2zrepeuirqu4twla2iou4bn64u"
    await expect(podNftContract.connect(attacker).safeMint(receiver, projectId, uri)).to.be.revertedWith(
      "Ownable: caller is not the owner"
    )
  })
})
