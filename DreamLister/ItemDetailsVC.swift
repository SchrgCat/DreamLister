//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 24.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
}
