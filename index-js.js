import { createWalletClient, custom, createPublicClient } from "https://esm.sh/viem"

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
        await walletClient.requestAddresses()
        publicClient = createPublicClient({
            transport: custom(window.ethereum)
        })
        await publicClient.simulateContract({
            address: custom.address
        })

    } else {

        connectButton.innerHTML = "Please Install Metamask!"
    }
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

