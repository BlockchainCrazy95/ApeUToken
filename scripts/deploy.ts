// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers, upgrades } from "hardhat";

const CHAIN_ID = "cchain"

const addresses = {
  JoeRouter02: {
    "cchain": "0x60aE616a2155Ee3d9A68541Ba4544862310933d4",
    "test": ""
  },
  JoePair: {
    "cchain": "0x454e67025631c065d3cfad6d71e6892f74487a15",
    "test": ""
  },
  AnysawpV5ERC20: {
    "cchain": "0x130966628846bfd36ff31a822705796e8cb8c18d",
    "test" : ""
  }
}

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account: ", owner.address);

  console.log("Account balance: ", (await owner.getBalance()).toString());

  // console.log("=== PlanetManagerContract deploy START")
  // const planetManagerFactory = await ethers.getContractFactory("PlanetsManagerUpgradeable");
  // const planetManagerContract = await upgrades.deployProxy(
  //   planetManagerFactory,
  //   [],
  //   {initializer: 'initialize'}
  // )
  // await planetManagerContract.deployed()
  // console.log("PlanetManagerContract address = ", planetManagerContract.address)

  // console.log("=== APEContract deploy START")
  // const apeFactory = await ethers.getContractFactory("ApeUniverse");
  // const apeContract = await apeFactory.deploy(
  //   planetManagerContract.address
  // );
  // await apeContract.deployed()
  // console.log("ApeUContract deployed to: ", apeContract.address)

  const lpManagerFactory = await ethers.getContractFactory("LiquidityPoolManager");
  const lpManagerContract = await lpManagerFactory.deploy(
    addresses.JoeRouter02[CHAIN_ID],
    [
      // apeContract.address,
      "0x59E2414BF32DA7B7AA695975f00bC9fba99643Cf", 
      addresses.AnysawpV5ERC20[CHAIN_ID]
    ],
    ethers.utils.parseEther("10000000")
  );
  await lpManagerContract.deployed()
  console.log("LiquidityPoolManagerContract deployed to: ", lpManagerContract.address)
  console.log("Threshold=", ethers.utils.parseEther("10000000"))

  // console.log("=== WalletObserverContract deploy START")
  // const walletObserverFactory = await ethers.getContractFactory("WalletObserverUpgradeable");
  // const walletObserverContract = await upgrades.deployProxy(
  //   walletObserverFactory,
  //   [],
  //   {initializer: 'initialize'}
  // )
  // await walletObserverContract.deployed()
  // console.log("WalletObserverContract address = ", walletObserverContract.address)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


/*
 ***** Addresses

  JoeRouter02 Address
    C-Chain: 0x60aE616a2155Ee3d9A68541Ba4544862310933d4
    Testnet: 
  JoePair Address
    C-Chain: 0x454e67025631c065d3cfad6d71e6892f74487a15
    Testnet:

  ***** Parameters *****
  LiquidityPoolManager: constructor(
        address _router, // JoeRouter02
        address[2] memory path, // leftSide = universeAddress,   rightSide=AnyswapV5ERC20 : createPair(path)...
        uint256 _swapTokensToLiquidityThreshold  // 10000000000000000000000000
    )
*/

/*
npx hardhat verify --network [NETWORK_NAME] --constructor-args scripts/arguments.js [DEPLOYED_CONTRACT_ADDRESS]

------------------------- Avalanche_Mainnet Deployed __ old_version
Deploying contracts with the account:  0x2cA62Cf3F7D24A31D7125962b55809A61e05560a
Account balance:  592860812297497618
=== PlanetManagerContract deploy START
PlanetManagerContract address =  0x9c0554D2D9Df403084C68715aa0C1FE8Ce121EDd
=== APEContract deploy START
ApeUContract deployed to:  0xb7d5058c28291c40CD02F799Fb711560AE92C102  : verified
=== LiquidityPoolManager deploy START
LiquidityPoolManagerContract deployed to:  0x0e7ED20898C6aD276100F0c370D1474992817180
Done in 96.19s.


======================= 
Deploying contracts with the account:  0x2cA62Cf3F7D24A31D7125962b55809A61e05560a
Account balance:  272542796082605259
=== PlanetManagerContract deploy START
PlanetManagerContract address =  0xdc200aDBAa9adB5F8dD79b796c612EDBbD4EB371
PlanetManagerImplementation address = 0x2afc08b10628cD4d51523d5A50E63311C9cbB7B7
=== APEContract deploy START
ApeUContract deployed to:  0x59E2414BF32DA7B7AA695975f00bC9fba99643Cf
=== LiquidityPoolManager deploy START
LiquidityPoolManagerContract deployed to:  0x973ab14EBa2a0a795Ef04A129B57d34DcCE6Aa45
=== WalletObserverContract deploy START
WalletObserverContract address =  0x05ead69146874E3DDBf2105f226Cc8F7A6596f4d

======================== Last Version
PlanetManagerProxy: 0xdc200aDBAa9adB5F8dD79b796c612EDBbD4EB371
PlanetManagerProxy.Impl = PlanetManagerUpgradeable: 0x2afc08b10628cD4d51523d5A50E63311C9cbB7B7
ApeUniverse: 0x59E2414BF32DA7B7AA695975f00bC9fba99643Cf
LiquidityPoolManager: 0xE0722d1eac5EfacE992eA5DCFdF4D343c3dA327A
WalletObserverProxy :0x05ead69146874E3DDBf2105f226Cc8F7A6596f4d
WalletObserverProxy.Impl = WalletObserverUpgradeable: 0x50b1a7A3659065675d9aFF2997B20A88B7e11Cae
 */

/*
Treasury:
0x5F9C87D10dc25F15327130B9c1FFB6CCB17F6729
Dev:
0xC11CE84779429F4f73d01dc0D503C3Cb1f4C1288
Marketing:
0x0c8A8ea1d30C821228c551043661327406D240Dc
Donation:
0x6C6b1903e33723Df753eBa535418a0E2FD28e7A4



Final Liquidity P

*/