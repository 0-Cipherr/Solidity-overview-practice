import { network } from "hardhat";
import { describe } from "node:test";
//eth sepolia has 0.5
const privatekey =
  "a83d708fc7df292f4242faa492fe9ba102628341b4c37e4c7dfbde00010538a5";
//renetrancy is caused when we update values after for exampleproivding users assets or depositing assets

//to prevent this from happening update blockhain atae data before giving out/back assets or depositing line 22-28 shows the rentrancy mistake

//testing the contracts is simply easy with hardhat look at each ddescribe example here for referenc e

// describe("Counter", async function () {
//   const { viem } = await network.connect();
//   const publicClient = await viem.getPublicClient();

//   it("Should emit the Increment event when calling the inc() function", async function () {
//     const counter = await viem.deployContract("Counter");

//     await viem.assertions.emitWithArgs(
//       counter.write.inc(),
//       counter,
//       "Increment",
//       [1n]
//     );
//   });

//   it("The sum of the Increment events should match the current value", async function () {
//     const counter = await viem.deployContract("Counter");
//     const deploymentBlockNumber = await publicClient.getBlockNumber();

//     // run a series of increments
//     for (let i = 1n; i <= 10n; i++) {
//       await counter.write.incBy([i]);
//     }

//     const events = await publicClient.getContractEvents({
//       address: counter.address,
//       abi: counter.abi,
//       eventName: "Increment",
//       fromBlock: deploymentBlockNumber,
//       strict: true,
//     });

//     // check that the aggregated events match the current value
//     let total = 0n;
//     for (const event of events) {
//       total += event.args.by;
//     }

//     assert.equal(total, await counter.read.x());
//   });
// });

//example on how to test a function and see what the fucntion returruns
// describe("DataLocations", async function () {
//   //connect to netwokr
//   const { viem } = await network.connect();
//   const publicClient = await viem.getPublicClient();

//   //deploy your contract u made in the contracts folder specify the name of the contract so it knows
//   const dataLocationCA: any = await viem.deployContract("DataLocations");

//   //use viems readcontract fucntion romthe public client to get result
//   const result: any = await publicClient.readContract({
//     address: dataLocationCA.address,
//     abi: dataLocationCA.abi,
//     functionName: "f",
//   });
//   //print the result onto the terminal
//   console.log("gas for transaction: ", result);
// });

// describe("comparing data storage gas ", async function () {
//   //connect to netwokr
//   const { viem } = await network.connect();
//   const publicClient = await viem.getPublicClient();
//   const testArray = [2, 4, 9, 12];
//   //deploy your contract u made in the contracts folder specify the name of the contract so it knows
//   const dataLocationCA: any = await viem.deployContract(
//     "DataLocationsAssignment"
//   );

//   //use viems readcontract fucntion romthe public client to get result
//   const callDataGas: any = await publicClient.estimateContractGas({
//     address: dataLocationCA.address,
//     abi: dataLocationCA.abi,
//     functionName: "callDataSum",
//     args: [testArray],
//   });

//   //use viems readcontract fucntion romthe public client to get result
//   const memoryGas: any = await publicClient.estimateContractGas({
//     address: dataLocationCA.address,
//     abi: dataLocationCA.abi,
//     functionName: "memorySum",
//     args: [testArray],
//   });
//   //print the result onto the terminal
//   console.log("calldata gas for transaction: ", callDataGas);
//   console.log("memory gas for transaction: ", memoryGas);
// });

//in this demosntration we deploy a contract and call write methods in the contract and coall read methods as wlel
// describe("State Persistance demonstration state updates but doesnt reset!", async function () {
//   const { viem } = await network.connect();
//   const publicClient = await viem.getPublicClient();
//   const [deployer, user1] = await viem.getWalletClients();

//   //deploy contract
//   const statePersistanceCA: any = await viem.deployContract("StatePersistence");
//   //loop though
//   for (let i = 0; i < 10; i++) {
//     //call the write fucntion 10 times within this for loop
//     const hash = await statePersistanceCA.write._callFunction();
//     await publicClient.waitForTransactionReceipt({ hash });
//     //////////////////////////////////////////////////////////////////
//     console.log("hash: ", hash);

//     //complete must do writecontract call _callFunction() test and then call get timestamps and function times called
//   }

//   //read contract functions are called

//   const timesFunctionCalled = await publicClient.readContract({
//     address: statePersistanceCA.address,
//     abi: statePersistanceCA.abi,
//     functionName: "_getTimesCalled",
//   });

//   const firstFiveTimestamps = await publicClient.readContract({
//     address: statePersistanceCA.address,
//     abi: statePersistanceCA.abi,
//     functionName: "_getTimestamps",
//     args: ["5"],
//   });
//   //////////////////////////////////////////////////////////////

//   //here we console, log the result for the read contracts
//   console.log("TImes fucntion was called: ", timesFunctionCalled);
//   console.log("First five timestamps: ", firstFiveTimestamps);
//   //////////////////////////////////////////////////////////////
// });

// describe("Checks balance for usdc of a user on a mainnet deployed usdc contract", async function () {
//   //we set the mainnet we wanna connect to we set this up in hardhatconfig.ts

//   const { viem } = await network.connect("hardhatMainnet");
//   const publicClient = await viem.getPublicClient();

//   //deploy contract
//   //the array contains the constructors arguments optional if it has no constructor dont inclde this array
//   //since the contract is in a folder itself in that same contracts directory we speciy the path to the contract
//   const UsdcContract = await viem.deployContract("TokenBalanceChecker", [
//     "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
//   ]);

//   const userBalance = await publicClient.readContract({
//     address: UsdcContract.address,
//     abi: UsdcContract.abi,
//     functionName: "getBalance",
//     args: ["0xe1940f578743367F38D3f25c2D2d32D6636929B6"],
//   });

//   //this logs User USDC Balance:  1399999999009577n

//   console.log("User USDC Balance: ", userBalance);
// });

// describe("Emits event when we sucessfully call the _makeSum funciton", async function () {
//   //this example listens for events
//   const { viem } = await network.connect();
//   const publicCLient = await viem.getPublicClient();

//   const eventEmitterCA = await viem.deployContract("EventsDemonstration");

//   //this variable listens for events we can also add a specific event to to listen for ifwe want to but in this case
//   //its a simple contract so i wont do
//   const unwatch = publicCLient.watchContractEvent({
//     address: eventEmitterCA.address,
//     abi: eventEmitterCA.abi,
//     onLogs: (logs) => console.log("Event: ", logs),
//   });
//   //params for a function must be an array
//   const hash = await eventEmitterCA.write._makeSum([10n, 30000n]);

//   console.log("Transaction Success Hash: ", hash);
//   //event printed in terminal will be printed in this format

//   //   Event:  [
//   //   {
//   //     eventName: '_sumExcecuted',
//   //     args: { _excecutionTimestamp: 1767580767n, gasToPay: 970478483n },
//   //     removed: false,
//   //     logIndex: 0,
//   //     transactionIndex: 0,
//   //     transactionHash: '0x5feb622cb09e5a55a33f6fcf1ed688a68f50756e626bbde55026ce1cbc733f2f',
//   //     blockHash: '0x6e1503dc2150300ba5779c9a2127e41ca4c3cab2c8791ffc27c4c8a3f0f7841e',
//   //     blockNumber: 2n,
//   //     address: '0x5fbdb2315678afecb367f032d93f642f64180aa3',
//   //     data: '0x00000000000000000000000000000000000000000000000000000000695b245f0000000000000000000000000000000000000000000000000000000039d85393',
//   //     topics: [
//   //       '0xf4d51eff745d5ff132c930a9c66172c637fe4d33cd8493a96806c3645c25aca3'
//   //     ],
//   //     blockTimestamp: undefined
//   //   }
//   // ]
// });

//works flaawlessly we can progress now to another project

// describe("Deploy a erc20 token and test its core fucntionalities", async function () {
//   try {
//     const { viem } = await network.connect("hardhatMainnet");
//     const publicClient = await viem.getPublicClient();
//     const [walletClient] = await viem.getWalletClients();

//     const testTokenDeployed = await viem.deployContract("TestToken", [
//       "Test Token",
//       "TEST",
//       1000000n,
//     ]);

//     //listen to the events emitted
//     const eventsLog = publicClient.watchContractEvent({
//       address: testTokenDeployed.address,
//       abi: testTokenDeployed.abi,
//       onLogs: (log) => console.log("Event detected: ", log),
//     });

//     //approve spending for test wallet
//     const approveHash = await testTokenDeployed.write.approve([
//       walletClient.account.address,
//       1000000000n,
//     ]);
//     await publicClient.waitForTransactionReceipt({ hash: approveHash });

//     // Simulate to catch revert reason
//     //we must simulate in order to see where the error happens when we run the test this should be done for all write fucntions
//     await testTokenDeployed.simulate._batchTransfer([
//       [
//         "0xFB74767C1ce1aadA0a0E114441173b57f8C1571b",
//         "0x4024e7447E0f4C5037144Bff332e37578f983d72",
//       ],
//       [300000n, 500000n],
//     ]);

//     //test the batch transfers
//     const batchHash = await testTokenDeployed.write._batchTransfer([
//       [
//         "0xFB74767C1ce1aadA0a0E114441173b57f8C1571b",
//         "0x4024e7447E0f4C5037144Bff332e37578f983d72",
//       ],
//       [300000n, 500000n],
//     ]);

//     const batchv2Hash = await testTokenDeployed.write._batchTransfer([
//       ["0x4024e7447E0f4C5037144Bff332e37578f983d72"],
//       [100000n],
//     ]);
//     const receipt = await publicClient.waitForTransactionReceipt({
//       hash: batchHash,
//     });
//     const receiptv2 = await publicClient.waitForTransactionReceipt({
//       hash: batchv2Hash,
//     });
//     console.log("Batch Success! tx hash: ", batchHash);
//     console.log("Batch Success! tx hash: ", batchv2Hash);

//     //get balance history
//     const balanceHsitoryFirst = await publicClient.readContract({
//       address: testTokenDeployed.address,
//       abi: testTokenDeployed.abi,
//       functionName: "_getHistory",
//       args: ["0xFB74767C1ce1aadA0a0E114441173b57f8C1571b"],
//     });
//     const balanceHsitorySecond = await publicClient.readContract({
//       address: testTokenDeployed.address,
//       abi: testTokenDeployed.abi,
//       functionName: "_getHistory",
//       args: ["0x4024e7447E0f4C5037144Bff332e37578f983d72"],
//     });
//     console.log(
//       "Balance history for 0xFB74767C1ce1aadA0a0E114441173b57f8C1571b: ",
//       balanceHsitoryFirst
//     );
//     console.log(
//       "Balance history for 0xFB74767C1ce1aadA0a0E114441173b57f8C1571b: ",
//       balanceHsitorySecond
//     );
//     //get token info struct
//     const tokenInfoStruct = await publicClient.readContract({
//       address: testTokenDeployed.address,
//       abi: testTokenDeployed.abi,
//       functionName: "_getTokenInfo",
//     });
//     console.log("Token info struct response: ", tokenInfoStruct);
//   } catch (error: any) {
//     console.log("❌ REVERT REASON:", error.shortMessage || error.message);
//     console.log("Full error:", error);
//   }
// });

describe("Deploy simple vault and test its fucntionalities and make sure it works flawlessly low gas and efficiently", async function () {
  const { viem } = await network.connect("hardhatMainnet");
  const publicClient = await viem.getPublicClient();
  const [walletClient] = await viem.getWalletClients();

  //deploy vault token

  //test starts   do everthing step by step do first fails to make sure system works and blocks malicious entities
  //tm we finnish this
  //make sure   contracts are gas efficient and low in gas this is big priority we must master thhis gas is trickky in solidity

  try {
    //you can fine tune testing this vault and the actions in the test everything from my end works flwlessly
    const vaultToken = await viem.deployContract("VaultToken", [
      "Vault Token",
      "VToken",
    ]);
    //deploy ault passing in vault token address
    const vault = await viem.deployContract("SimpleVault", [
      vaultToken.address,
    ]);
    const tokenEvents = publicClient.watchContractEvent({
      address: vaultToken.address,
      abi: vaultToken.abi,
      onLogs: (logs) => console.log(logs[0].eventName, logs[0].args),
    });

    const vaultEvents = publicClient.watchContractEvent({
      address: vaultToken.address,
      abi: vaultToken.abi,
      onLogs: (logs) => console.log(logs[0].eventName, logs[0].args),
    });

    // //the error   from modifier shhows properly revert works
    // await vault.simulate._deposit([[300000n]]);

    // //test the deposit
    // const depositHash = await vault.write._deposit([[300000n]]);

    // const receipt = await publicClient.waitForTransactionReceipt({
    //   hash: depositHash,
    // });

    //simualte and test a deposit properly WORKS PROPERLY
    await vaultToken.simulate.approve([vault.address, 500000n]);

    //test the deposit approve spending
    const approveHash = await vaultToken.write.approve([
      vault.address,
      500000n,
    ]);

    const approveReciept = await publicClient.waitForTransactionReceipt({
      hash: approveHash,
    });

    //deposit
    await vault.simulate._deposit([300000n]);

    //test the deposit
    const depositHash = await vault.write._deposit([300000n]);

    const depositReciept = await publicClient.waitForTransactionReceipt({
      hash: depositHash,
    });

    const vaultBalance = await publicClient.readContract({
      address: vault.address,
      abi: vault.abi,
      functionName: "_getVaultBalance",
      args: [walletClient.account.address],
    });

    console.log("Your vault Balance after deposit : ", vaultBalance);
    ///////////////////////////////////////////////////
    //try a withdraw all

    await vault.simulate._withdrawAll();

    const withdrawAllHash = await vault.write._withdrawAll();

    const withdrawAllReciept = await publicClient.waitForTransactionReceipt({
      hash: withdrawAllHash,
    });

    //withdraw from vault works flawlessly event reverts are working flawlessly

    // await vault.simulate._withdraw([50000n]);

    // const withdrawHash = await vault.write._withdraw([50000n]);

    // const withdrawReciept = await publicClient.waitForTransactionReceipt({
    //   hash: withdrawHash,
    // });

    //gets updated balance from vault
    const vaultBalanceAfterWithdraw = await publicClient.readContract({
      address: vault.address,
      abi: vault.abi,
      functionName: "_getVaultBalance",
      args: [walletClient.account.address],
    });
    console.log(
      "Your vault Balance after withdraw: ",
      vaultBalanceAfterWithdraw
    );

    //////////////////////////////////////////////////////////////////////
  } catch (error) {
    console.log(error);
  }
});
