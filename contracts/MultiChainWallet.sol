// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract MultiChainWallet {
    mapping(address => mapping(address => uint256)) private balances;
    mapping(address => bool) private wallets;

    event WalletCreated(address indexed owner);
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);

    modifier onlyWallet() {
        require(wallets[msg.sender], "Wallet does not exist");
        _;
    }

    function createWallet() external {
        require(!wallets[msg.sender], "Wallet already exists");
        wallets[msg.sender] = true;
        emit WalletCreated(msg.sender);
    }

    function deposit(address token, uint256 amount) external onlyWallet {
        require(amount > 0, "Invalid amount");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][token] += amount;
        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(address token, uint256 amount) external onlyWallet {
        require(balances[msg.sender][token] >= amount, "Insufficient balance");
        balances[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
        emit Withdraw(msg.sender, token, amount);
    }

    function getBalance(address token) external view onlyWallet returns (uint256) {
        return balances[msg.sender][token];
    }
}



contract MockERC20 is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory _name, string memory _symbol, address initialAccount, uint256 initialBalance) {
        name = _name;
        symbol = _symbol;
        _balances[initialAccount] = initialBalance;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(amount <= _allowances[sender][msg.sender], "Allowance exceeded");
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function approve(address spender, uint256 amount) external  returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) external   view  returns (uint256) {
        return _allowances[owner][spender];
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[sender] >= amount, "Insufficient balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        _allowances[owner][spender] = amount;
    }
}