//
//  CollectionTableViewCell.swift
//  Collection-Task
//
//  Created by Mohana on 16/04/18.
//  Copyright © 2018 F22. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func layoutSubviews() {
        containerView.layer.cornerRadius = 4.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
