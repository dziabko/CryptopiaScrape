//
//  Coin.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-16.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import Foundation
import os.log

class Coin: NSObject, NSCoding {
    
    //Coin's data
    var coinSymbol: String
    var coinPrice: Double
    var coinBaseSymbol: String
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("coins")

    
    
    init?(coinSymbol: String, coinBaseSymbol: String, coinPrice: Double){
        self.coinSymbol = coinSymbol
        self.coinPrice = coinPrice
        self.coinBaseSymbol = coinBaseSymbol
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coinSymbol, forKey: "coinSymbol")
        aCoder.encode(coinPrice, forKey: "coinPrice")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let coinSymbol = aDecoder.decodeObject(forKey: "coinSymbol") as? String else{
            os_log("Unable to decode the coin symbol.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let coinBaseSymbol = aDecoder.decodeObject(forKey: "coinBaseSymbol") as? String else{
            os_log("Unable to decode the coin base symbol.", log: OSLog.default, type: .debug)
            return nil
        }

        
        guard let coinPrice = aDecoder.decodeObject(forKey: "coinprice") as? Double else{
            os_log("Unable to decode the coin price.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //Call designated initializer
        self.init(coinSymbol: coinSymbol, coinBaseSymbol: coinBaseSymbol, coinPrice: coinPrice)
    }
    
    
}
