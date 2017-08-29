//
//  SearchViewController.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-12.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating{
    
    var searchActive: Bool = false
    var pairData =  [String]()
    var filteredData = [String]()
    
    //Search/Results Controller
    var searchController: UISearchController!
    var resultsController = UITableViewController()
    
    //MapTable Storing id-pair table
    var idHashMap = NSMapTable<NSString, NSString>()
    
    //Array storing symbols
    var symbolHashMap = NSMapTable<NSString, NSString>()
    var basesymbolHashMap = NSMapTable<NSString, NSString>()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        
        //Does not dim the search results
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        //Placeholder text
        self.searchController.searchBar.placeholder = "SEARCH FOR COIN"
        
        //Gets pairs, and updates tableview with coins
        getPairs()
    }
    
    
    //Update Search Results
    func updateSearchResults(for searchController: UISearchController) {
        //Filter through the data
        
        self.filteredData = self.pairData.filter{ (pairData:String) -> Bool in
            if pairData.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            }else{
                return false
            }
        }
        
        //Update the results TableView
        resultsController.tableView.reloadData()
        //self.resultsController.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Returns row count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive && searchController.searchBar.text != ""){
            return filteredData.count
        }else{
            return pairData.count
        }
    }
    
    
    //Get the coin pairs on exchange site
    func getPairs() -> [String] {
        func grabTradePairs(request: URLRequest, completion: @escaping ([String])->Void) {
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                guard let data = data, error == nil else{
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                var labelArray = [String]()
                do {
                    //Parse each coin's data as JSON
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                    //Grab coin's data section
                    if let data = json?["Data"] as? [[String: AnyObject]]{
                        
                        for coins in data {
                            
                            DispatchQueue.main.async {
                                
                                //Grabs exchange pair and coin name
                                let coinLabel = coins["Label"] as? String
                                let coinCurrency = coins["Currency"] as? String
                                
                                //Storing the labelArray
                                labelArray.append(coinLabel!)
                                self.pairData.append(coinCurrency! + " : " + coinLabel!)
                                
                                
                                
                                //Reload table with new coin
                                self.tableView.reloadData()
                                
                                //Coin's ID for coin's data request
                                var coinID: NSString = (String (coins["Id"] as! Int)) as NSString
                                print(coinID)
                                
                                
                                //Storing the symbols with coin's name
                                let symbol = coins["Symbol"] as? String
                                self.symbolHashMap.setObject(symbol as! NSString, forKey: (coinCurrency! + " : " + coinLabel!) as NSString)
                                let baseSymbol = coins["BaseSymbol"] as? String
                                self.basesymbolHashMap.setObject(baseSymbol as! NSString, forKey: (coinCurrency! + " : " + coinLabel!) as NSString)
                                
                                
                                //Add coin's ID to a hashtable with coin's name
                                self.idHashMap.setObject(coinID, forKey: (coinCurrency! + " : " + coinLabel!) as NSString)
                            }
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
        
        //Get each trade pair on Cryptopia
        let url3 = URL(string: "https://www.cryptopia.co.nz/api/GetTradePairs")
        let urlReq3 = URLRequest(url: url3!)
        
        //Grab all the Labels
        var labelArray = [String]()
        grabTradePairs(request: urlReq3) {response in
            print(response)
            labelArray = response
        }
        
        //Returns the label array
        return labelArray
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        //If search bar is active and not empty, return filtered data, else return all coins
        if (self.searchController.isActive && self.searchController.searchBar.text != ""){
            cell.textLabel?.text = self.filteredData[indexPath.row]
            self.searchActive = true
        }else{
            cell.textLabel?.text = self.pairData[indexPath.row]
            self.searchActive = false
        }
        //Remove selection
        //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Perform the Segue to next page
        print("DID SELECT ROW TABLEVIEW")
        performSegue(withIdentifier: "coinViewSegue", sender: indexPath)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE SEGUE")
        let navVC = segue.destination// as! UINavigationController
        
        //Current Selected row
        let  row = (sender as! NSIndexPath).row
        var pairData2 = ""
        
        //Get coin from filtered, or non-filtered data
        if (searchController.isActive && searchController.searchBar.text != ""){
            pairData2 = filteredData[row]
            print("FILTEREDDATA")
        }else{
            pairData2 = pairData[row]
            print("PAIRDATA")
        }
        
        //Receiving View Controller
        let receiverVC = navVC as! AddCoinViewController  //.topViewController as! AddCoinViewController
        
        
        //Passing data to next View
        receiverVC.pairData = pairData2
        let nsPairData2 = pairData2 as NSString
        print(nsPairData2)
        print(idHashMap.object(forKey: nsPairData2) as! String)
        
        //Setting the ReceiverVC pairID & symbol
        receiverVC.pairID = idHashMap.object(forKey: (pairData2 as NSString)) as! String
        receiverVC.symbol = symbolHashMap.object(forKey: (pairData2 as NSString)) as! String
        receiverVC.baseSymbol = basesymbolHashMap.object(forKey: (pairData2 as NSString)) as! String
    }
    
    
    
    
    /*override func performSegue(withIdentifier identifier: String, sender: Any?) {
     let myCoin = storyboard?.instantiateViewController(withIdentifier: "AddCoin") as! AddCoinViewController
     
     }*/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
