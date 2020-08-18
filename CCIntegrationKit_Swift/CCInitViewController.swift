//
//  CCInitViewController.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/3/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import UIKit
//import OpenSSL

/**
 * class: CCInitViewController
 * This class is responsible for displaying initial view controller to the merchant
 * In this page we will accept the access code, merchant id, currency, amount, redirect url, cancel url and the RSA url from the merchant
 * We'll generate order id randomly for the merchant (As we required unique order id for each transaction)
 */

class CCInitViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:
    //MARK:: Textfields
    
    lazy var accessCodeTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter access code"
        textField.text = "4YRUXLSRO20O8NIH".trimmingCharacters(in: .whitespacesAndNewlines) //AVHP02EC52CK26PHKC
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var merchantIdTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter merchant ID"
        textField.text = "2".trimmingCharacters(in: .whitespacesAndNewlines) //43205
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var currencyTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter Currency"
        textField.text = "INR" //AED
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var amountTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter amount"
        textField.text = "1.00"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var orderIdTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter order ID"
        textField.text = ""
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var cancelUrlTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter cancel URL"
        textField.text = "https://test.ccavenue.com/jsp/ccavResponseHandler_test.jsp".trimmingCharacters(in: .whitespacesAndNewlines) //"http://122.182.6.216/merchant/ccavResponseHandler.jsp" //https://secure.ccavenue.com/jsp/ccavResponseHandler.jsp  //http://122.182.6.216/ae/ccavResponseHandler_nonS.jsp
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var redirectUrlTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter redirect URL"
        textField.text = "https://test.ccavenue.com/jsp/ccavResponseHandler_test.jsp".trimmingCharacters(in: .whitespacesAndNewlines) //"http://122.182.6.216/merchant/ccavResponseHandler.jsp".trimmingCharacters(in: .whitespacesAndNewlines) //https://secure.ccavenue.com/jsp/ccavResponseHandler.jsp   //http://122.182.6.216/ae/ccavResponseHandler_nonS.jsp
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var rsaKeyUrlTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter RSA Key URL"
        textField.text = "https://secure.ccavenue.com/transaction/jsp/GetRSA.jsp".trimmingCharacters(in: .whitespacesAndNewlines) //http://122.182.6.216/ae/GetRSA.jsp
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    //MARK :: Labels
    
    let accessCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Access code"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let merchantIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Merchant ID"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Currency"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let orderIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Order ID"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelUrlLabel: UILabel = {
        let label = UILabel()
        label.text = "Cancel URL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let redirectUrlLabel: UILabel = {
        let label = UILabel()
        label.text = "Redirect URL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rsaKeyUrlLabel: UILabel = {
        let label = UILabel()
        label.text = "RSA Key URL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let submitButton:DesignableButton = {
        let button = DesignableButton()
        let attributedTitle = NSMutableAttributedString(string: "Submit", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), NSForegroundColorAttributeName: Color.orange])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(Color.orange, for: .normal)
        button.cornerRadius = 5
        button.borderWidth = 1
        button.borderColor = Color.orange
        button.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.backgroundColor = .green
        return button
    }()
    
    let cancelButton:DesignableButton = {
        let button = DesignableButton()
        let attributedTitle = NSMutableAttributedString(string: "Cancel", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), NSForegroundColorAttributeName: Color.orange])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(Color.orange, for: .normal)
        button.cornerRadius = 5
        button.borderWidth = 1
        button.borderColor = Color.orange
        button.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.backgroundColor = .green
        return button
    }()
    
    //MARK:
    //MARK:: Submit button click action
    
    /**
     * In submitButtonClick method we wil check for the all the textfield if any of the textfield is empty we will show error and user can't procced further
     * If there is no error then we need to pass all the value form the textField to the second view controller (ie. CCWebViewController in this case) to procced futher for the payment
     */
    
    func submitButtonClick(){
        var isError = false
        var marchantIdText = String()
        var accesCodeText = String()
        var amountText = String()
        var currencyText = ""
        var orderIdText = ""
        var redirectUrlText = ""
        var cancelUrlText = ""
        var rsaKeyUrlText = ""
        print("submit button click")
        
        let controller:CCWebViewController = CCWebViewController()
        
        if accessCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.accessCodeTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Access code is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            accessCodeTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            accesCodeText = (accessCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            accessCodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if merchantIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.merchantIdTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Merchant ID is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            merchantIdTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            marchantIdText = (merchantIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            merchantIdTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.amountTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Amount is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            amountTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            
            let numberFormatter = NumberFormatter()
            let number:Float = numberFormatter.number(from: (amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) as! Float
            print(number)
            print(number < 0)
            if number <= 0{
                isError = true
                self.amountTextField.layer.borderColor = UIColor.red.cgColor
                let alert: UIAlertController = UIAlertController(title: "ERROR", message: "Amount should be greater than 0", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    print("amount should be greater than zero")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                isError = false
                amountText = (amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
                amountTextField.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        
        if currencyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.currencyTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Currency is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            currencyTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            currencyText = (currencyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            currencyTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if orderIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.orderIdTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Order ID is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            orderIdTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            orderIdText = (orderIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            orderIdTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if redirectUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.redirectUrlTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Redirect URL is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            redirectUrlTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            redirectUrlText = (redirectUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            redirectUrlTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if cancelUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.cancelUrlTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "Cancel URL is required field",
                                                   attributes:[NSForegroundColorAttributeName: UIColor.red])
            cancelUrlTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            cancelUrlText = (cancelUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            cancelUrlTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if rsaKeyUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isError = true
            self.rsaKeyUrlTextField.layer.borderColor = UIColor.red.cgColor
            let attributedStr = NSAttributedString(string: "RSA Key URL is required field",
                                                attributes:[NSForegroundColorAttributeName: UIColor.red])
            rsaKeyUrlTextField.attributedPlaceholder = attributedStr
            return
        }
        else{
            isError = false
            rsaKeyUrlText = (rsaKeyUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            rsaKeyUrlTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if !isError{
            controller.accessCode = accesCodeText
            controller.merchantId = marchantIdText
            controller.amount = amountText
            controller.currency = currencyText
            controller.orderId = orderIdText
            controller.redirectUrl = redirectUrlText
            controller.cancelUrl = cancelUrlText
            controller.rsaKeyUrl = rsaKeyUrlText
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        observeKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    //MARK::
    //MARK:: textFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
