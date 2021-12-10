//
//  TransitionTableViewCell.swift
//  Assignment 2
//
//  Created by Robert Onuma on 08/12/2021.
//

import UIKit

class TransitionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewTrans: UIImageView!
    
    @IBOutlet weak var titleLabelTrans: UILabel!
    
    @IBOutlet weak var artistLabelTrans: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
