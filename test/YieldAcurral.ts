import { network } from "hardhat";
import { describe } from "node:test";
import { formatUnits } from "viem";
describe("Testing arethmetic operations and how to handle decimals", async function () {
  try {
    const { viem } = await network.connect();
    const publicClient = await viem.getPublicClient();
    const calculator = await viem.deployContract("YieldVault");
    const result: any = await publicClient.readContract({
      address: calculator.address,
      abi: calculator.abi,
      functionName: "testCalculation",
    });
    console.log("Calc Result RAW: ", result);
    console.log("Calc Result Parsed: ", Number(formatUnits(result, 18)));
  } catch (error) {
    console.log(error);
  }
});

//format units to descale a value
//parseunits to scale a value
