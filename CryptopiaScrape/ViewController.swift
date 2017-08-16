//
//  ViewController.swift
//  CryptopiaScrape
//
//  Created by Daniel Ziabko on 2017-08-03.
//  Copyright © 2017 Daniel Ziabko. All rights reserved.
//

import UIKit
import WebKit
//import Alamofire

class ViewController: UIViewController,
    UISearchBarDelegate{

    @IBOutlet weak var introText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introText.text = "This app grabs all the coin pairs from cryptopia, and displays the selected coin's data."
        
              
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

