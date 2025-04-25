# HiberPay Smart Contract

HiberPay is a decentralized platform for **scheduling crypto transfers** (ETH & ERC-20) with a simple 1% fee model.
It enables users to lock a transfer and execute it at a later time — ideal for **future payments, allowances, or automation**.

## 🔗 Contract Details

- **Network:** Ethereum Mainnet
- **Contract Name:** `HiberPay`
- **Contract Address:** `0x1D2DB613a011336209510a93D82dAFA8418Fb3f7`
- **Solidity Version:** `^0.8.20`
- **License:** MIT
- **Audit Status:** [Pending or Completed] by Secure3

## ✨ Features

- Schedule ETH or ERC-20 token transfers
- Enforces `unlockTime` before execution
- Automatically deducts 1% developer fee
- Emits `TransferScheduled` and `TransferExecuted` events
- Gas-efficient low-level `safeTransfer` for compatibility

## 💡 Use Cases

- Birthday or time-locked gifts
- Payment automation for DAOs or freelancers
- Scheduled token airdrops
- Crypto subscriptions (coming soon)

## 🔐 Security

- Uses OpenZeppelin’s `ReentrancyGuard`
- Includes `safeTransferFrom` and `safeTransfer` with low-level checks
- ETH and token logic handled distinctly
- All transfers initiated by the sender and publicly visible

✅ Contract verified on [Etherscan](https://etherscan.io/address/0x1D2DB613a011336209510a93D82dAFA8418Fb3f7#code)
🔒 Audit submitted to [Secure3](https://secure3.io)

## 🧪 How It Works

```solidity
// Schedule a token transfer
scheduleTransfer(
  address _token,       // Token address (or 0x0 for ETH)
  address _recipient,   // Recipient address
  uint256 _amount,      // Amount (in wei or token units)
  uint256 _unlockTime   // Future UNIX timestamp
);
```

Once the `unlockTime` is reached, anyone can trigger:

```solidity
executeTransfer(uint256 id);
```

## 📦 Project Structure

```
├── HiberPay.sol       # Main contract
├── README.md          # Project readme
└── ...
```

## 🖥 Frontend

A live frontend is deployed at 👉 [https://hiberpay.app](https://hiberpay.app)

Frontend repo is currently closed-source. Only the smart contract is open source in this repo.

## 📌 Deployment Checklist

- [x] Mainnet contract deployed
- [x] Source code verified
- [x] Frontend live
- [ ] Full audit completed
- [ ] Integration with Chainlink Keepers (optional future)

## 🛠 Example Addresses (ERC-20)

- ETH: Native (address `0x0000000000000000000000000000000000000000`)
- USDT: `0xdAC17F958D2ee523a2206206994597C13D831ec7`
- LINK: `0x514910771AF9Ca656af840dff83E8264EcF986CA`

## 🤝 Contributing

Currently closed for pull requests. For integrations or partnership:

📬 **Contact:** [@HiberPay](https://twitter.com/HiberPay)

---

> Built with ❤️ to help crypto sleep easier.
