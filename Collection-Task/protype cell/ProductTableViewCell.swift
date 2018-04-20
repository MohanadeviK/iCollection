//
//  ProductTableViewCell.swift
//  Collection-Task
//
//  Created by Mohana on 19/04/18.
//  Copyright © 2018 F22. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var btnFav: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
