import "@nomiclabs/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@typechain/hardhat";
import { HardhatUserConfig } from "hardhat/config";

const config: HardhatUserConfig = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,      // or whatever chainId your node uses
    },
  },
  solidity: "0.8.28",
  // si ya tienes typechain en config no hace falta repetirlo,
  // pero podrías añadir:
  // typechain: { outDir: "typechain-types", target: "ethers-v5" },
};

export default config;