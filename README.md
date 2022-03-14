Proxiable Contracts marked abstract should be inherited by a child contract that also inherits ```proxy/Initialize.sol```
and executes their initializers like so:

```
    import "./tokens/ProxiableERC20.sol";
    import "./proxy/Initialize.sol"

    Contract Token is ProxiableERC20, Initializer {
        function initialize() external initializer {
            ERC20Init();
        }
    }
```