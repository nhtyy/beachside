Contracts marked abstract with initializers should be inherited by a child contract that also inherits initializer

```
    import "./tokens/ProxyERC20.sol";
    import "./proxy/Intialize.sol"

    Contract Token is ProxyERC20, Initializer {
        function initialize() external initializer {
            ERC20Init();
        }
    }
```