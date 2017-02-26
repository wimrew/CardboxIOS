//
//  AboutViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/4/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//import Alamofire

//import SwiftyJSON


class AboutViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!
    var decks = [Deck]()
    
    @IBOutlet weak var updateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("decks in about viewc")
        print(decks.count)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func update() {
        updateLabel.text="Thanks for updating!"
        print("update done")
        updateApplication()
    }
    
    
    func updateApplication(){
    
        
        
        
        
        
        /*
    
        
        Alamofire.request("http://192.168.0.104:8080/getAllCards").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if result = response.result.value {
                print("JSON: \(result)")
            }
        }
        
        let json = JSON(data: result)
        
        
        for actCard in json {
            let cardID = element["cardID"].Int64
            let deckName = element["deckName"].String
            let fronText = element["frontText"].String
            let backText = element["backText"].String
            let path = element["path"].String
            */
            //insert to lacal db
            
        }
        
        
        
        
        
        
    }

