//
//  CCInitView.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/4/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import Foundation
import UIKit


class CCInitView: NSObject{
    
    //MARK:
    //MARK: init method
    override init() {
        super.init()
    }
}

extension CCInitViewController{
    
    func setupView(){
        let container = UILayoutGuide()
        view.addSubview(accessCodeLabel)
        view.addSubview(merchantIdLabel)
        view.addSubview(currencyLabel)
        view.addSubview(amountLabel)
        view.addSubview(orderIdLabel)
        view.addSubview(cancelUrlLabel)
        view.addSubview(redirectUrlLabel)
        view.addSubview(rsaKeyUrlLabel)
        
        view.addSubview(accessCodeTextField)
        view.addSubview(merchantIdTextField)
        view.addSubview(currencyTextField)
        view.addSubview(amountTextField)
        view.addSubview(orderIdTextField)
        view.addSubview(cancelUrlTextField)
        view.addSubview(redirectUrlTextField)
        view.addSubview(rsaKeyUrlTextField)
        
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        
        let views = ["accessCodeLabel":accessCodeLabel,"accessCodeTextField":accessCodeTextField,
                     "merchantIdLabel":merchantIdLabel,"merchantIdTextField":merchantIdTextField,
                     "CurrencyLabel":currencyLabel,"currencyTextField":currencyTextField,
                     "AmountLabel":amountLabel,"amountTextField":amountTextField,
                     "orderIdLabel":orderIdLabel,"orderIdTextField":orderIdTextField,
                     "cancelUrlLabel": cancelUrlLabel,"cancelUrlTextField": cancelUrlTextField,
                     "RedirectUrlLabel": redirectUrlLabel, "redirectUrlTextField": redirectUrlTextField,
                     "RsaKeyUrlLabel":rsaKeyUrlLabel, "RsaKeyUrlTextField": rsaKeyUrlTextField,
                     "submitButton":submitButton,"cancelButton":cancelButton] as [String : Any]
        
        let metrics = ["spacing": 10]
        
        view.addLayoutGuide(container)
        
        accessCodeTextField.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
//        NSLayoutConstraint.activate(NSLayoutConstraint.)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[accessCodeLabel]-[accessCodeTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[merchantIdLabel]-[merchantIdTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[CurrencyLabel]-[currencyTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[AmountLabel]-[amountTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[orderIdLabel]-[orderIdTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cancelUrlLabel]-[cancelUrlTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[RedirectUrlLabel]-[redirectUrlTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[RsaKeyUrlLabel]-[RsaKeyUrlTextField]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[submitButton]-[cancelButton(==submitButton)]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[accessCodeTextField(==35)]-[merchantIdTextField(==accessCodeTextField)]-[currencyTextField(==accessCodeTextField)]-[amountTextField(==accessCodeTextField)]-[orderIdTextField(==accessCodeTextField)]-[cancelUrlTextField(==accessCodeTextField)]-[redirectUrlTextField(==accessCodeTextField)]-[RsaKeyUrlTextField(==accessCodeTextField)]", options: [.alignAllLeading, .alignAllTrailing], metrics: metrics, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[RsaKeyUrlTextField]-(spacing)-[submitButton(==40@1000)]", options: [], metrics: metrics, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[cancelButton(==submitButton)]", options: [], metrics: nil, views: views))
        
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        _ = [rsaKeyUrlLabel .setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)]
        _ = [submitButton .setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.vertical)]
        
        
        //MARK::
        //MARK:: setupValues in textField
        let randomNumber = (arc4random() % 9999999) + 1
        orderIdTextField.text = String(randomNumber)
    }
}


class LeftPaddedTextField: DesignableTextField{
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10 , y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10 , y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
    }
}

struct Color {
    
    static let orange = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
}
