//
//  CoinPageViewController.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-29.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import UIKit
import Charts

class CoinPageViewController: UIViewController {

    @IBOutlet weak var coinTextView: UILabel!
    
    
    @IBOutlet weak var askPrice: UILabel!
    @IBOutlet weak var bidPrice: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var change: UILabel!
    
    //Chart Data
    var chartData = [CandleChartDataEntry]()
    @IBOutlet weak var barChart: CandleStickChartView!
    
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(pairData)
        print("https://www.cryptopia.co.nz/api/GetMarket/\(pairData)")
        
        //Set the title
        coinTextView.text = symbol + "/" + baseSymbol
        
        //Do request for coin's data
        let url = URL(string: "https://www.cryptopia.co.nz/api/GetMarket/" + pairData)
        let urlReq = URLRequest(url: url!)
        
        //Grab all the Labels
        var labelArray = [String]()
        getCoinData(request: urlReq) {response in
            print(response)
            labelArray = response
        }
        
        
        //Chart Data
        let url1 = URL(string: ("https://min-api.cryptocompare.com/data/histohour?fsym=" + symbol + "&tsym=" + baseSymbol + "&limit=23&e=Cryptopia"))
        let urlReq1 = URLRequest(url: url1!)
        
        getCoinChartData(request: urlReq1){response in
            print(response)
        }
        print("HI")
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
    
    func getCoinChartData(request: URLRequest, completion: @escaping ([String])->Void) {
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
                print("HI")
                print(json)
                //let data = JSONSerialization.jsonObject(with: Data)(with: json?["Data"]) as NSArray
                if let data2 = json?["Data"] as? [[String:AnyObject]]{
                    
                    
                    //print(data2)
                    
                    //print(data2[1])
                    //print("PRINTING SNAP OF JSON!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    let dataSet = CandleChartDataSet()
                    self.barChart.setScaleEnabled(false)
                    self.barChart.chartDescription?.text = "BAR GRAPH"
                    self.barChart.drawMarkers = false
                    
                    var x = 0
                    for snap in data2{
                        let time = snap["time"] as! Double
                        let close = snap["close"] as! Double
                        let high = snap["high"] as! Double
                        let low = snap["low"] as! Double
                        let open = snap["open"] as! Double
                        //let snapJson = try JSONSerialization.jsonObject(with: snap)
                        
                        let myDate = NSDate.init(timeIntervalSince1970: time)
                        print(myDate as Date)
                        

                        let hour = NSCalendar.current.component(.hour, from: myDate as Date)
                        let minute = NSCalendar.current.component(.minute, from: myDate as Date)
                        
                        
                        
                        var Cx: CandleChartDataEntry
                        if (hour == 0) {
                            Cx = CandleChartDataEntry(x: Double(24), shadowH: high, shadowL: low, open: open, close: close)
                        }else{
                            Cx = CandleChartDataEntry(x: Double(hour), shadowH: high, shadowL: low, open: open, close: close)
                        }
                        dataSet.addEntry(Cx)
                        
                        x = x+1
                                                //myDate.
                        //let comp = Calendar.dateComponents([.hour, . minute], from: myDate as Date)
                        //let hour = comp.
                        
                        //let components = NSCalendar.components(NSCalendar)
                        
                        //let unitFlag: NSDateComponents = [.hour, .minute]
                        //let component = NSCalendar.component(.hour, from: myDate as Date)
                        print(String(hour) + ":" + String(minute))
                        //myDate.
                        
                        

                    }
                    //Adding Data to barchart
                    
                    dataSet.drawValuesEnabled = false
                    
                    
                    //dataSet.setColor(NSUIColor.red)
                    dataSet.setColor(NSUIColor.green)
                    
                    dataSet.increasingColor = NSUIColor.green
                    dataSet.decreasingColor = NSUIColor.red
                    dataSet.shadowColorSameAsCandle = true
                    
                
                    dataSet.increasingFilled = true
                    dataSet.decreasingFilled = true
                    let data = CandleChartData(dataSets: [dataSet])
                    self.barChart.data = data
                    //self.barChart.drawMarkers = false
                    self.barChart.legend.enabled  = false
                    
                    //Update data asynchronously to not interfere with main thread
                    DispatchQueue.main.async {
                        self.barChart.notifyDataSetChanged()
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
    
    
    


    @IBAction func back(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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
