# Using Scaffold-ETH 2 to deploy a dApp on Metis L2

Follow this tutorial to create a quick dApp prototype and to deploy on Metis.

## Requirements

- [Node JS](https://nodejs.org/en/download/)
- [Yarn](https://yarnpkg.com/getting-started/install)
- [Git](https://git-scm.com/downloads)

## 1- Scaffold Quickstart

To get started with Scaffold-ETH 2, follow the steps below:

1. Clone the Scaffold repo & install dependencies

```
git clone https://github.com/scaffold-eth/scaffold-eth-2.git
```

Make sure to navigate to the scaffold folder:

cd scaffold-eth-2

And make sure to install yarn
`yarn install`


2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `hardhat.config.ts`.

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in `packages/hardhat/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/hardhat/deploy` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. 

You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

## 2- Modify back-end and front-end

2.1 - Front-End: Edit page.tsx

Add below 'Edit your smart contract':

```
<p className="text-center text-lg mt-4">
<strong style={{ fontSize: '36px', color: '#04D1FF' }}>DEPLOY ON METIS</strong>
</p> 
```

2.2 - Back-End: Edit `YourContract.sol` 

Add a function to store a number:

```
// Mapping from address to number
mapping(address => uint) public userNumbers;
event NumberUpdated(address indexed user, uint number);

// Function to store a number
function storeNumber(uint _number) public {
      userNumbers[msg.sender] = _number;
      emit NumberUpdated(msg.sender, _number);
    }
```

## 3- Deploying on Metis:

First, avoid issues with public keys and create one for this tutorial:

```
yarn generate
```

- Private Key saved to packages/hardhat/.env file
- Import wallet and send funds
- Check the status with `yarn account`

3.1 - Edit the hardhat config to add Metis Network:

```
    andromeda: {
      url: "https://andromeda.metis.io/?owner=1088",
      accounts: [deployerPrivateKey],
      verify: {
        etherscan: {
          apiKey: "apiKey is not required, just set a placeholder",
          apiUrl: "https://api.routescan.io/v2/network/mainnet/evm/1088/etherscan",
        },
      },
    },
    metisSepolia: {
      url: "https://sepolia.metisdevops.link/",
      accounts: [deployerPrivateKey],
      verify: {
        etherscan: {
          apiKey: "apiKey is not required, just set a placeholder",
          apiUrl: "https://sepolia.explorer.metisdevops.link",
        },
      },
    },
```

3.2 - Deploy on testnet and then mainnet with these commands:

```
yarn deploy --network metisSepolia
```

```
yarn deploy --network andromeda
```

3.3 - Verify: 

```
yarn verify --network andromeda
```

( make sure to the check contract on routerscan or other explorer)

3.4 - Update front-end

Go to scaffold.config.ts and edit the targetNetworks

```
targetNetworks: [chains.metis]
```
_______________________________________________________________________________________

That's it! 

You now have completed all the steps necessary to use Scaffold ETH-2 and spin up a dApp on Metis L2. 

For more details on how to build on Metis, visit the documentation [here](https://docs.metis.io/dev)

_______________________________________________________________________________________

#### Bonus: 

You can deploy your dApp on Vercel with the command ´yarn vercel´ (need to connect Vercel and GitHub first).
