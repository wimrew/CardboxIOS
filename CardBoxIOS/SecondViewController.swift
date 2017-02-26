//
//  SecondViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/4/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var decks = [Deck]()
        
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate
            as! AppDelegate
        let context = appDelegate.managedObjectContext
        print(context)
        print("decks in second viewc")
        print(decks.count)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
       

}

