import { Contract } from "ethers"
import { task, types } from "hardhat/config"

task("deploy:pod", "Deploy box contract")
  .addOptionalParam<boolean>("logs", "Logs ", true, types.boolean)
  .setAction(async ({ logs }, { ethers }): Promise<Contract> => {
    const Pod = await ethers.getContractFactory("PoDNFT")
    const pod = await (await Pod.deploy()).deployed()

    console.log("pod:", pod.address)

    return pod
  })
