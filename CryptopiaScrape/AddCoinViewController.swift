//
//  AddCoinViewController.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-13.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import UIKit
import Foundation

class AddCoinViewController: UIViewController {

    
    //Coin's data outlets
    @IBOutlet weak var coindataTextView: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var bidPrice: UILabel!
    @IBOutlet weak var askPrice: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    
    //Coin pair, and ID
    var pairData: String = ""
    var pairID: String = ""
    var askPriceVariable: Double = 0.0
    var symbol: String = ""
    var baseSymbol: String = ""
    
    //BaseSymbol Hashmap
    var baseHashMap = ["USDT" : "$",
                       "NZDT" : "$",
                       "BTC" : "฿",
                       "LTC" : "Ł",
                       "DOGE" : "Ð"]
    
    //Cancel button pressed
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Prepare coin label before view controller loads
    override func viewWillAppear(_ animated: Bool) {
        coindataTextView.text = pairData
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(pairData)
        print("https://www.cryptopia.co.nz/api/GetMarket/\(pairID)")
        
        //Do request for coin's data
        let url = URL(string: "https://www.cryptopia.co.nz/api/GetMarket/" + pairID)
        let urlReq = URLRequest(url: url!)
        
        //Grab all the Labels
        var labelArray = [String]()
        getCoinData(request: urlReq) {response in
            print(response)
            labelArray = response
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCoinData(request: URLRequest, completion: @escaping ([String])->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            //print(data as NSData) //<-`as NSData` is useful for debugging
            
            var labelArray = [String]()
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                print("")
                //let data = JSONSerialization.jsonObject(with: Data)(with: json?["Data"]) as NSArray
                if let data2 = json?["Data"] as? [String: Any]{
                    
                    
                    print(data2)
                    
                    var baseSymbol = self.baseHashMap[self.baseSymbol]!
                    
                    //Label Changing needs to be done on the main thread
                    DispatchQueue.main.async {
                        //High and Low Values
                        let coinHigh = data2["High"] as! Double
                        self.high.text = baseSymbol + String(format: "%.8f", coinHigh)
                        let coinLow = data2["Low"] as! Double
                        self.low.text = baseSymbol + String(format: "%.8f", coinLow)
                        
                        
                        
                        print(String(format: "%.8f", coinHigh))
                        //Other coin data
                        let coinBid = data2["BidPrice"] as! Float
                        let coinAsk = data2["AskPrice"] as! Float
                        let vol = data2["Volume"] as! Float
                        let change = data2["Change"] as! Double
                        let lastPrice = data2["LastPrice"] as! Float
                        self.bidPrice.text = baseSymbol + String(format: "%.8f", coinBid)
                        self.askPrice.text = baseSymbol + String(format: "%.8f", coinAsk)
                        self.volume.text = baseSymbol + String(format: "%.8f", coinLow)
                        self.lastPrice.text = baseSymbol + String(format: "%.8f", lastPrice)
                        self.change.text = "\(data2["Change"] as! Double)" + "%"
                        
                        self.askPriceVariable = Double(coinAsk)
                    }
                    
                    
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(labelArray)
        }
        task.resume()
    }
    
    
    //Adding the coin to table
    @IBAction func unwindTwice(_ sender: Any) {
        //Get instance of storyboard
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        //Create the new coin instance to be added
        guard let newCoin = Coin(coinSymbol: symbol, coinBaseSymbol: baseSymbol, coinPrice: askPriceVariable) else{
            fatalError("T")
        }
        print("UNWINDING")
        
        //Get the HomePageController
        let old = self.navigationController?.viewControllers
        let HomePageViewController = old![0] as! HomePageController
        
        //Add coin to the home page
        HomePageViewController.coins += [newCoin]
        
        //Pop view controllers to get to home page
        let homePage = self.navigationController?.popToRootViewController(animated: true)
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
