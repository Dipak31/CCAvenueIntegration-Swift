//
//  DesignableTableViewCell.swift
//  eSamyak Order App
//
//  Created by Ram Mhapasekar on 18/03/17.
//  Copyright © 2017 eSamyak. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTableViewCell: UITableViewCell {

    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
