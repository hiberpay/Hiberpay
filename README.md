# HiberPay Smart Contract

HiberPay is a decentralized platform for **scheduling crypto transfers** (ETH & ERC-20) with a simple 1% fee model.  
It allows users to lock a transfer and execute it after a defined unlock time — useful for **future payments, gifts, or automation**.

## 🔗 Contract Details

- **Chain:** Ethereum Mainnet  
- **Contract Name:** `HiberPay`  
- **Contract Address:** `0xYourContractAddressHere`  
- **Compiler Version:** `0.8.20`  
- **License:** MIT  
- **Audit Status:** [Pending/Completed by Secure3 or insert firm name]

## ✨ Features

- Schedule ETH or ERC-20 transfers to any recipient
- Transfers execute only after the unlock timestamp
- 1% fee is deducted and sent to the platform developer
- ERC-20 transfers handled securely with `safeTransferFrom`

## 🛡 Security

This contract implements:
- OpenZeppelin's `ReentrancyGuard`
- Custom `safeTransfer` and `safeTransferFrom` with low-level checks
- Fallback function to accept ETH (`receive()`)

✅ Code has been verified on [Etherscan](https://etherscan.io/address/0xYourContractAddressHere#code)  
🔒 Security audit request submitted to [Secure3](https://secure3.io)

## 🚀 How It Works

1. Users call `scheduleTransfer(token, recipient, amount, unlockTime)`
2. ETH is sent directly; ERC-20 is approved then transferred from wallet
3. A 1% fee is deducted automatically
4. After `unlockTime`, `executeTransfer(id)` can be called by anyone

## 🧪 Example

```solidity
// Schedule 10 LINK to be sent to Alice at a future time
scheduleTransfer(
  0x514910771AF9Ca656af840dff83E8264EcF986CA,  // LINK
  0xAliceAddress,
  10 * 1e18,
  1714579200 // Unix timestamp
);
