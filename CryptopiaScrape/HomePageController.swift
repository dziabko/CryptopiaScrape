//
//  HomePageController.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-16.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import UIKit

class HomePageController: UITableViewController {
    
    var coins = [Coin]()
    
    //BaseSymbol Hashmap
    var baseHashMap = ["USDT" : "$",
                       "NZDT" : "$",
                       "BTC" : "฿",
                       "LTC" : "Ł",
                       "DOGE" : "Ð"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Create 2 default coins
        guard let coin1 = Coin(coinSymbol: "CHAO", coinBaseSymbol: "BTC", coinPrice: 44.44) else{
            fatalError("SA")
        }
        guard let coin2 = Coin(coinSymbol: "IFLT", coinBaseSymbol: "BTC" ,coinPrice: 0.00000001 ) else{
            fatalError("T")
        }
        
        //Add the default coins
        coins += [coin1, coin2]
        print(coins)
        
        // Do any additional setup after loading the view.
    }
    
    //Reload tableview when view appears
    override func viewDidAppear(_ animated: Bool) {
        print(coins)
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Retunr number of coins stored
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HomePageTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomePageTableViewCell else {
            fatalError("The dequeued cell is not an instance of HomePageTableViewCell.")
        }
        
        //Fetches the appropriate coin for the layout
        let coin = coins[indexPath.row]
        
        //Set the cell's price and symbol
        cell.coinPriceLabel.text = baseHashMap[coin.coinBaseSymbol]! + String(format: "%.8f", coin.coinPrice)
        cell.coinSymbolLabel.text = coin.coinSymbol
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Perform the Segue to next page
        print("DID SELECT ROW TABLEVIEW")
        performSegue(withIdentifier: "CoinDetailSegue", sender: indexPath)
    }
    
    
    
    //MARK: ISSUE
    //Runs Prepare
    //RUNS didSelect tablerow
    //Then prepare again
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("TEST1")
        if (segue.identifier == "CoinDetailSegue"){
            print("PREPARE SEGUE")
            let navVC = segue.destination// as! UINavigationController
            
            //Current Selected row
            let  row = (sender as! NSIndexPath).row
            //var pairData2
            
            var pairData2 = coins[row]
            
            //Receiving View Controller
            let receiverVC = navVC as! CoinPageViewController  //.topViewController as! AddCoinViewController
            
            
            //Passing data to next View
            receiverVC.pairData = pairData2.coinSymbol + "_" + pairData2.coinBaseSymbol
            
            
            //Setting the ReceiverVC pairID & symbol
            receiverVC.pairID = pairData2.coinSymbol
            receiverVC.symbol = pairData2.coinSymbol
            receiverVC.baseSymbol = pairData2.coinBaseSymbol
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
