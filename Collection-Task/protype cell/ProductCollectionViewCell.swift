//
//  ProductCollectionViewCell.swift
//  Collection-Task
//
//  Created by Mohana on 19/04/18.
//  Copyright © 2018 F22. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var orginalPriceLbl: UILabel!
    
    
    override func layoutSubviews() {
        productImg.layer.cornerRadius = productImg.bounds.width/2
        productImg.clipsToBounds = true
        self.layer.cornerRadius = 4.0
    }
    
    override func awakeFromNib() {
        let attributedString = NSMutableAttributedString(string: "$32")
        attributedString.addAttribute(.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
         attributedString.addAttribute(.strikethroughColor, value: self.orginalPriceLbl.textColor, range: NSMakeRange(0, attributedString.length))
        self.orginalPriceLbl.attributedText = attributedString
    }
}
