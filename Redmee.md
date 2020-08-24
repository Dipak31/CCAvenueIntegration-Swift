IOS Integration Kit
CCAvenue iOS SDK is a secure, PCI-compliant way to accept Debit/Credit card, Net-Banking, UPI and wallet payments from your customers in your iOS app.

1. Steps to Integrate
Copy RSAUtils.swift & CCWebViewController.swift files into your native iOS application.
To process transaction merchant needs to pass Access code, Merchant Id, Order Id, Currency(ie. INR), Amount for transaction, RSA Key URL (The URL at which merchant host their getRSA File) , Return and Cancel URL to redirect payment result to the merchant. (Refer CCInitViewController.swift for the reference)

Swift:
            let orderIdText =  "123456",
            let accesCodeText =  "AVIM27FG12AU39MIUA",
            let marchantIdText =  "79562",
            let amountText = "1.00",
            let currencyText = "INR",
            let redirectUrl  =  "http://www.testserver.com/redirectPage.php"
	let cancelUrlText =  "http://www.testserver.com/cancelPage.php",
            let rsaKeyUrlText =  "http://www.testserver.com/getRSA.php",

	let controller:CCWebViewController = CCWebViewController(accessCode: accesCodeText, merchantId: marchantIdText, orderId: orderIdText, amount: amountText, currency: currencyText, redirectUrl: redirectUrlText, cancelUrl: cancelUrlText, rsaKeyUrl: rsaKeyUrlText)

2. Get payment response
Once the payment  is done we will check for that the webView url is cancel/response url if yes then we fetch the payment data.
If merchant wants to redirect directly to his desired viewcontroller then replace controller obj with desired viewcontroller's object
  
Swift:  
	/**Reference Code*/ 
let controller: CCResultViewController = CCResultViewController()
controller.transStatus = transStatus
self.present(controller, animated: true, completion: nil)




