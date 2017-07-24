//
//  ItemTableViewCell.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 24.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func configureCell(item: Item) {
        titleLabel.text = item.title
        priceLabel.text = "$\(item.price)"
        detailsLabel.text = item.details
    }

}
