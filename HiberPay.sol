// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/token/ERC20/IERC20.sol";

contract HiberPay is ReentrancyGuard {
    struct Transfer {
        address token;
        address recipient;
        uint256 amount;
        uint256 unlockTime;
        bool executed;
    }

    Transfer[] public transfers;
    address public developer;
    uint256 public feePercentage = 1;

    event TransferScheduled(
        uint256 indexed id,
        address indexed sender,
        address indexed token,
        address recipient,
        uint256 amount,
        uint256 unlockTime
    );

    event TransferExecuted(
        uint256 indexed id,
        address indexed token,
        address recipient,
        uint256 amount
    );

    constructor() {
        developer = msg.sender;
    }

    function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transferFrom failed");
    }

    function safeTransfer(address token, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transfer.selector, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "transfer failed");
    }

    function scheduleTransfer(
        address _token,
        address _recipient,
        uint256 _amount,
        uint256 _unlockTime
    ) external payable {
        require(_recipient != address(0), "Invalid recipient");
        require(_unlockTime > block.timestamp, "Unlock time must be future");
        require(_amount > 0, "Amount must be > 0");

        uint256 fee = (_amount * feePercentage) / 100;
        uint256 amountAfterFee = _amount - fee;
        require(amountAfterFee > 0, "Amount after fee too small");

        if (_token == address(0)) {
            // 預約 ETH
            require(msg.value == _amount, "Incorrect ETH sent");
            payable(developer).transfer(fee);
        } else {
            // 預約 ERC-20
            safeTransferFrom(_token, msg.sender, address(this), _amount);
            safeTransfer(_token, developer, fee);
        }

        transfers.push(Transfer({
            token: _token,
            recipient: _recipient,
            amount: amountAfterFee,
            unlockTime: _unlockTime,
            executed: false
        }));

        emit TransferScheduled(
            transfers.length - 1,
            msg.sender,
            _token,
            _recipient,
            amountAfterFee,
            _unlockTime
        );
    }

    function executeTransfer(uint256 id) external nonReentrant {
        require(id < transfers.length, "Invalid ID");

        Transfer storage t = transfers[id];
        require(!t.executed, "Already executed");
        require(block.timestamp >= t.unlockTime, "Too early");

        t.executed = true;

        if (t.token == address(0)) {
            // ETH
            (bool sent, ) = payable(t.recipient).call{value: t.amount}("");
            require(sent, "ETH transfer failed");
        } else {
            // ERC-20
            safeTransfer(t.token, t.recipient, t.amount);
        }

        emit TransferExecuted(id, t.token, t.recipient, t.amount);
    }

    function getAllTransfers() external view returns (Transfer[] memory) {
        return transfers;
    }

    receive() external payable {}
}
