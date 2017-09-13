//
//  ChartDataEntry.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-09-11.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import Foundation

class ChartDataEntry{
    //Entry's data
    var x: Double
    var y: Int
    
    init?(x: Double, y: Int){
        self.x = x
        self.y = y
    }
    
}
