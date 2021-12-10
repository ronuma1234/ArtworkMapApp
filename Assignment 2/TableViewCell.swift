//
//  TableViewCell.swift
//  Assignment 2
//
//  Created by Robert Onuma on 07/12/2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeThumbNail: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
