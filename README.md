# # Boxch Wallet

Non-custodial wallet

Download here https://boxch.net

Boxch Wallet Prototype supports a number features such as:
* Create/Access Wallet with seed. Your private keys are only stored on your current device
* Displaying balances of SOL token and SPL tokens
* Displaying the value of assets in dollars
* Send and receive SOL token and SPL tokens
* Transaction history
* QR code generation
* Nice UI

Further development:
* Improving security
* Buy&Sell crypto
* Earn tokens

# Build

If you'd rather build the application yourself, please ensure you have flutter/dart already installed locally

* Clone the repository
```git clone https://github.com/boxch/boxch.git```

* Rename the file
```lib/utils/config_s.dart to lib/utils/config.dart ```

* Install dependencies
```flutter pub get```

* Build
```flutter build apk```

```IMPORTANT! The standard Solana RPC API is limited in speed, which can cause problems with launching the application. To fix this, please use private entrepoints```
