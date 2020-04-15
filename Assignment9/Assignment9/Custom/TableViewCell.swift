//
//  TableViewCell.swift
//  Assignment9
//
//  Created by Nguyễn Lâm on 4/14/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
