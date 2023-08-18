//
//  ItemCell.swift
//  Assignment1
//
//  Created by Inito on 05/08/23.
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonLabel.layer.cornerRadius = buttonLabel.frame.size.height / 2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
