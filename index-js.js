import { createWalletClient, custom, createPublicClient, parseEther, defineChain } from "https://esm.sh/viem"
import { contractAddress, coffeAbi } from "./constants-js";

const connectButton = document.getElementById("connectButton");
const fundButton = document.getElementById("fundButton");
const ethAmountInput = document.getElementById("ethAmount");

let walletClient
let publicClient


async function connect() {
    if (typeof window.ethereum !== "undefined") {
        walletClient = createWalletClient({
            transport: custom(window.ethereum)
        })
        await walletClient.requestAddresses()
        connectButton.innerHTML = "Connected!"

    } else {

        connectButton.innerHTML = "Please Install Metamask!"
    }
}

async function fund() {
    const ethAmount = ethAmountInput.value
    console.log(`Funding with ${ethAmount}...`)
    if (typeof window.ethereum !== "undefined") {
        walletClient = createWalletClient({
            transport: custom(window.ethereum)
        })

        const [connectedAccount] = await walletClient.requestAddresses()
        const currentChain = await getCurrentChain(walletClient)
        publicClient = createPublicClient({
            transport: custom(window.ethereum)
        })
        const { request } = await publicClient.simulateContract({
            address: contractAddress,
            abi: coffeAbi,
            functionName: "fund",
            account: connectedAccount,
            chain: currentChain,
            value: parseEther(ethAmount),
        })
        const hash = await walletClient.writeContract(request)
        console.log(hash)
    } else {

        connectButton.innerHTML = "Please Install Metamask!"
    }
}


async function getCurrentChain(client) {
    const chainId = await client.getChainId()
    const currentChain = defineChain({
        id: chainId,
        name: "Custom Chain",
        nativeCurrency: {
            name: "Ether",
            symbol: "ETH",
            decimals: 18,
        },
        rpcUrls: {
            default: {
                http: ["http://localhost:8545"],
            },
        },
    })
    return currentChain
}

connectButton.onclick = connect
fundButton.onclick = fund




// window.ethereum.request({
//     method: "eth_requestAccounts"
// }).then((accounts) => {
//     console.log(accounts)
//     connectButton.innerHTML = accounts[0]
// }).catch((error) => {
//     console.error(error)
// })
// Coin.Sent().watch({}, '', function (error, result) {
//     if (!error) {
//         console.log("Coin transfer: " + result.args.amount + "coins were sent from" + result.args.from + "to" + result.args.to + ".");
//         console.log("Balances now:\n" + "sender: " + Coin.balances.call(result.args.from) + "Rceiver: " + Coin.balances.call(result.args.to));
//     }
// }

