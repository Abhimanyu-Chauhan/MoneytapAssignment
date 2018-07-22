//
//  SearchCellTableViewCell.swift
//  MoneyTapAssignment
//
//  Created by CE-367 on 7/22/18.
//  Copyright © 2018 CE-367. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
