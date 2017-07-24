//
//  Item+creationDate.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 23.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        created = NSDate()
    }
    
}
