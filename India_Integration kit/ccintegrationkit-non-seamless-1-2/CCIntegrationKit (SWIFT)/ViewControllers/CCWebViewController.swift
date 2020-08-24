//
//  CCWebViewController.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/4/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import UIKit
import Foundation
import WebKit

/**
 * class: CCWebViewController
 * CCWebViewController is responsible for to take all the values from the merchant and process futher for the payment
 * We will generate the RSA Key for this transaction first by using access code of the merchant and the unique order id for this transaction
 * After generating Successful RSA Key we will use that key for encrypting amount and currency and the encrypted details will use for intiate the transaction
 * Once the transaction is done  we will pass the transaction result to the next page (ie CCResultViewController here)
 */

class CCWebViewController: UIViewController,WKUIDelegate, WKNavigationDelegate {
    
    var accessCode = String()
    var merchantId = String()
    var orderId = String()
    var amount = String()
    var currency = String()
    var redirectUrl = String()
    var cancelUrl = String()
    var rsaKeyUrl = String()
    var rsaKeyDataStr = String()
    var rsaKey = String()
    static var statusCode = 0//zero means success or else error in encrption with rsa
    var encVal = String()
    var isHere = false
    
    convenience public init(accessCode: String, merchantId: String, orderId: String, amount: String, currency: String, redirectUrl: String, cancelUrl: String, rsaKeyUrl: String){
        self.init()
        self.accessCode = accessCode
        self.merchantId = merchantId
        self.orderId = orderId
        self.amount = amount
        self.currency = currency
        self.redirectUrl = redirectUrl
        self.cancelUrl = cancelUrl
        self.rsaKeyUrl = rsaKeyUrl
    }
    
    
    private var notification: NSObjectProtocol?
    
    lazy var viewWeb: WKWebView = {
        var webView = WKWebView()
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.contentMode = UIView.ContentMode.scaleAspectFit
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
    
    var request: NSMutableURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        notification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: .main) {
            [unowned self] notification in
            self.checkResponseUrl()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /**
         * In viewWillAppear we will call gettingRsaKey method to generate RSA Key for the transaction and use the same to encrypt data
         */
        
        if !isHere {
            isHere = true
            self.gettingRsaKey(){
                (success, object) -> () in
                DispatchQueue.main.sync {
                    if success {
                        self.encyptCardDetails(data: object as! Data)
                    }
                    else{
                        self.displayAlert(msg: object as! String)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(view: self.view)
    }
    
    /**
     This method is to get response when user complete his payment using UPI. Since user switch to Vendor UPI application to complete his/her payment, when user comes back to application 'UIApplicationWillEnterForeground' observer calls this method and checks for the response
     */
    fileprivate func checkResponseUrl(){
        LoadingOverlay.shared.hideOverlayView()
        if self.viewWeb.isLoading{
            if let urlAsString = (self.viewWeb.url?.absoluteString){
                if urlAsString.contains(redirectUrl) ||  urlAsString.contains(cancelUrl){
                    processWebResponse(viewWeb)
                }
            }
        }
    }
    
    //MARK:
    //MARK: setupWebView
    
    private func setupWebView(){
        //setup webview
        view.addSubview(viewWeb)
        if #available(iOS 11.0, *) {
            viewWeb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            viewWeb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            viewWeb.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            viewWeb.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        viewWeb.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewWeb.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _ = [viewWeb .setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.vertical)]
    }
    
    
    //MARK:
    //MARK: Get RsaKey & encrypt card details
    
    /**
     * In this method we will generate RSA Key from the URL for this we will pass order id and the access code as the request parameter
     * after the successful key generation we'll pass the data to the request handler using complition block
     */
    
    private func gettingRsaKey(completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()){
        DispatchQueue.main.async {
            self.rsaKeyDataStr = "access_code=\(self.accessCode)&order_id=\(self.orderId)"
            
            let requestData = self.rsaKeyDataStr.data(using: String.Encoding.utf8)
            
            guard let urlFromString = URL(string: self.rsaKeyUrl) else{
                return
            }
            
            var urlRequest = URLRequest(url: urlFromString)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            print("session",session)
            
            session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode{
                    guard let responseData = data else{
                        print("No value for data")
                        completion(false, "Not proper data for RSA Key" as AnyObject?)
                        return
                    }
                    print("data :: ",responseData)
                    completion(true, responseData as AnyObject?)
                }
                else{
                    completion(false, "Unable to generate RSA Key please check" as AnyObject?)                }
            }.resume()
        }
    }
    
    /**
     * encyptCardDetails method we will use the rsa key to encrypt amount and currency and onece the encryption is done we will pass this encrypted data to the initTrans to initiate payment
     */
    
    private func encyptCardDetails(data: Data){
        guard let rsaKeytemp = String(bytes: data, encoding: String.Encoding.ascii) else{
            print("No value for rsaKeyTemp")
            return
        }
        rsaKey = rsaKeytemp
        rsaKey = self.rsaKey.trimmingCharacters(in: CharacterSet.newlines)
        rsaKey =  "-----BEGIN PUBLIC KEY-----\n\(self.rsaKey)\n-----END PUBLIC KEY-----\n"
        print("rsaKey :: ",rsaKey)
        
        let myRequestString = "amount=\(amount)&currency=\(currency)"
        
        do{
            let encodedData = try RSAUtils.encryptWithRSAPublicKey(str: myRequestString, pubkeyBase64: rsaKey)
            let querySet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted
            var encodedStr = encodedData?.base64EncodedString(options: [])
            encodedStr = encodedStr?.addingPercentEncoding(withAllowedCharacters: querySet)
            CCWebViewController.statusCode = 0
            
            //Preparing for webview call
            if CCWebViewController.statusCode == 0{
                CCWebViewController.statusCode = 1
                let urlAsString = "https://secure.ccavenue.com/transaction/initTrans"
                let encryptedStr = "merchant_id=\(merchantId)&order_id=\(orderId)&redirect_url=\(redirectUrl)&cancel_url=\(cancelUrl)&enc_val=\(encodedStr!)&access_code=\(accessCode)"
                let myRequestData = encryptedStr.data(using: String.Encoding.utf8)
                
                request  = NSMutableURLRequest(url: URL(string: urlAsString)! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
                request?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                request?.setValue(urlAsString, forHTTPHeaderField: "Referer")
                request?.httpMethod = "POST"
                request?.httpBody = myRequestData
                DispatchQueue.main.async {
                    self.viewWeb.load(self.request! as URLRequest)
                }
            }
            else{
                print("Unable to create requestURL")
                displayAlert(msg: "Unable to create requestURL")
            }
        }
        catch let err {
            print(err)
        }
        
    }
    
    func displayAlert(msg: String){
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            LoadingOverlay.shared.hideOverlayView()
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:
    //MARK: WK delegate
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LoadingOverlay.shared.hideOverlayView()
        print("Fail to load webpage currently, Please try again later.")
        print("Error: ", error.localizedDescription)
    }
    
    func processWebResponse(_ webView:WKWebView){
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
            if error == nil
            {
                var htmlArray1 = (html! as! String).components(separatedBy: "<tbody>")
                if htmlArray1.count > 1{
                    let htmlString1 = htmlArray1[1]
                    var htmlArray2 = htmlString1.components(separatedBy: "</tbody>")
                    if htmlArray2.count > 0{
                        var jsonString = htmlArray2[0]
                        jsonString = jsonString.replacingOccurrences(of: " ", with: "")
                        jsonString = jsonString.replacingOccurrences(of: "<td>", with: "\"")
                        jsonString = jsonString.replacingOccurrences(of: "<tr>", with: "")
                        jsonString = jsonString.replacingOccurrences(of: "</tr>", with: ",")
                        
                        let words = jsonString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                        var nospacestring = words.joined(separator: "")
                        nospacestring = nospacestring.replacingOccurrences(of: "</td>", with: "\" : ")
                        
                        nospacestring = nospacestring.replacingOccurrences(of: " : ,", with: ",")
                        
                        if nospacestring.count > 0 {
                            nospacestring = String(nospacestring.dropLast()) //((nospacestring as? NSString)?.substring(to: nospacestring.count - 1))!
                        } else {
                            //no characters to delete... attempting to do so will result in a crash
                            //print("Unable to get string without spaces")
                        }
                        nospacestring = "{\(nospacestring)}"
                        
                        var finalResponseDictionary: [AnyHashable : Any]? = nil
                        if let anEncoding = nospacestring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                            do {
                                ///merchant can use json response to process ahead, print response to get more inside
                                finalResponseDictionary = try JSONSerialization.jsonObject(with: anEncoding, options: []) as? [AnyHashable : Any]
                                
                                let controller: CCResultViewController = CCResultViewController()
                                controller.transStatus = finalResponseDictionary!["order_status"] as! String
                                self.present(controller, animated: true, completion: nil)
                            }
                            catch let err {
                                var finalResponseDictionary: [AnyHashable : Any] = [:]
                                finalResponseDictionary["order_id"] = self.orderId
                                finalResponseDictionary["order_status"] = "Unable to fetch response, please confirm corder status with CCAvenue"
                                finalResponseDictionary["tracking_id"] = "NA"
                                let controller: CCResultViewController = CCResultViewController()
                                controller.transStatus = "Unable to fetch response, please confirm corder status with CCAvenue"
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        })
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoadingOverlay.shared.hideOverlayView()
        
        if let urlAsString = webView.url?.absoluteString{
            //print("current url is  :: ",urlAsString)
            if urlAsString.contains(redirectUrl) ||  urlAsString.contains(cancelUrl){
                processWebResponse(webView)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

