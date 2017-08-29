//
//  HomePageTableViewCell.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-16.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
