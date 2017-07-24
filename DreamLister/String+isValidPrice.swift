//
//  String+isValidPrice.swift
//  DreamLister
//
//  Created by Mikołaj Skawiński on 25.07.2017.
//  Copyright © 2017 Mikołaj Skawiński. All rights reserved.
//

import Foundation

extension String {
    public var isValidPrice: Bool {
        let priceRegex = "[0-9]*"
        let priceTest = NSPredicate(format: "SELF MATCHES %@", priceRegex)
        return priceTest.evaluate(with: self)
    }
}
