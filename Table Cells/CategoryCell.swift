//
//  CategoryCell.swift
//  EFAB
//
//  Created by Sean Crowl on 11/2/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var category: Category!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ category : Category, total: Bool) {
        self.category = category
        nameLabel.text = category.name ?? ""
        
        let amount = category.amount ?? 0
        let prefix = amount < 0 ? "-" : ""
        
        amountLabel.text = Utils.formatNumber(amount, prefix: prefix)
        if let amount = category.amount {
            amountLabel.textColor = amount < 0.0 ? ColorPalette.NegativeColor : ColorPalette.PositiveColor
        }
        
        if total {
            self.accessoryType = .none
        } else {
            self.accessoryType = .disclosureIndicator
        }
    }

}
