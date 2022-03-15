//SPDX-License-Identifier: MIT
//Modified version of the Solmate ERC20 (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
pragma solidity ^0.8.10;

abstract contract ProxiableERC20 { 
    ///===========================
    /// ERRORS
    ///===========================

    ///@notice Thrown if an action is performed to the zero address.
    error ToZeroAddy();

    ///@notice Thrown if an action is performed from the zero address.
    error FromZeroAddy();

    ///===========================
    /// STATE
    ///===========================

    ///@notice Name of the token.
    string public name;

    ///@notice Symbol of the token.
    string public symbol;

    ///@notice Decimals of the token.
    ///@dev Used for display purposes, default is 18.
    uint8 public decimals;

    ///@notice Total supply of the token.
    uint256 public totalSupply;

    ///@notice Maps an address to a balance.
    mapping(address => uint256) public balanceOf;

    ///@notice Maps an address to the amount other address are allowed to spend from it.
    mapping(address => mapping(address => uint256)) public allowance;

    ///@notice Emitted when a transfer occurs.
    ///@dev Also emitted when a mint or burn transaction occurs.
    event Transfer(address indexed from, address indexed to, uint256 amount);

    ///@notice Emitted when an approval occurs.
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    ///===========================
    /// INIT
    ///===========================

    ///@notice Initialize the token.
    ///@dev Takes the place of what a non-proxiable ERC-20 may use a constructor for.
    ///@param _name Set the name of the token.
    ///@param _symbol Set the symbol of the token.
    ///@param _decimals Set the decimals of the token.
    function init(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) internal {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    ///===========================
    /// FUNCTIONS
    ///===========================

    ///@notice Transfer the token to a provided address.
    ///@param to Address to transfer the tokens to.
    ///@param amount Amount to transfer.
    function transfer(address to, uint256 amount) public virtual returns (bool) {
        if (msg.sender == address(0)) revert FromZeroAddy();
        if (to == address(0)) revert ToZeroAddy();

        balanceOf[msg.sender] -= amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    ///@notice Transfer the token from a provided address to another provided address.
    ///@param from Address to transfer the tokens from.
    ///@param to Address to transfer the tokens to.
    ///@param amount Amount to transfer.
    function transferFrom(
        address from, 
        address to, 
        uint256 amount
    ) public virtual returns (bool) {
        if (msg.sender == address(0)) revert FromZeroAddy();
        if (to == address(0)) revert ToZeroAddy();

        uint256 allowed = allowance[from][msg.sender];

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    ///@notice Approve an address for spending the token.
    ///@param spender Address to approve.
    ///@param amount Amount to approve.
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    ///===========================
    /// INTERNAL
    ///===========================

    ///@notice Mint a given amount of tokens.
    ///@param to Address to mint to.
    ///@param amount Amount to mint. 
    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    ///@notice Burn a given amount of tokens.
    ///@param from Address to burn from.
    ///@param amount Amount to burn.
    function _burn(address from, uint256 amount) internal virtual {
        if (from == address(0)) revert FromZeroAddy();

        balanceOf[from] -= amount;

        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}