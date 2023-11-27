import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 50000,
      },
    },
  },
  networks: {
    testnet: {
      chainId: 4201,
      url: "https://rpc.testnet.lukso.network",
      accounts: [process.env.PRIVATEKEY || '']
    },
    mainnet: {
      url: "https://rpc.mainnet.lukso.network",
      accounts: [process.env.PRIVATEKEY || '']
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: "my-api-key",
    customChains: [
      {
        network: 'testnet',
        chainId: 4201,
        urls: {
          apiURL: 'https://explorer.execution.testnet.lukso.network/api',
          browserURL: 'https://explorer.execution.testnet.lukso.network/',
        },
      },
    ],
  },
};

export default config;
