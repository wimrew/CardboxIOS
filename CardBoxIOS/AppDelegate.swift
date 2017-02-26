//
//  AppDelegate.swift
//  CardBoxIOS
//
//  Created by macmini on 2/4/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var decks = [Deck]()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            initializeCards()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstlaunch1.0")
            NSUserDefaults.standardUserDefaults().synchronize();
            
        }
        
        fetchFromCoreData()
       Card.setActualDeckID(1)
        let tabBarController = window!.rootViewController as! UITabBarController
        
        if let tabBarViewControllers = tabBarController.viewControllers {
            let currentLocationViewController = tabBarViewControllers[0] as! FirstViewController
            currentLocationViewController.decks = decks
            currentLocationViewController.managedObjectContext=self.managedObjectContext
        }
        
        if let tabBarViewControllers2 = tabBarController.viewControllers {
            let currentLocationViewController2 = tabBarViewControllers2[1] as! UINavigationController
            let deckcontroller = currentLocationViewController2.childViewControllers[0] as! DecksViewController 
            deckcontroller.decks = decks
            deckcontroller.managedObjectContext=self.managedObjectContext
        }

        if let tabBarViewControllers3 = tabBarController.viewControllers {
                let currentLocationViewController3 = tabBarViewControllers3[2] as! AboutViewController
                currentLocationViewController3.decks = decks
        }
        
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let modelURL = NSBundle.mainBundle().URLForResource("ModelCard", withExtension: "momd") else {
            fatalError("Could not find data model in app bundle")
        }
        
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing model from: \(modelURL)")
        }
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.URLByAppendingPathComponent("DataStore.sqlite")
        print(storeURL)
        
        do {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {
            fatalError("Error adding persistent store at \(storeURL): \(error)")
        }
        }()
    
    
    func initializeCards(){
        
        let managedContext = self.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Card",
            inManagedObjectContext:managedContext)
        
        let card = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        card.setValue("kutya", forKey: "fronttext")
        card.setValue("dog", forKey: "backtext")
        card.setValue(1, forKey: "id")
        card.setValue("dog.jpg", forKey: "path")
        card.setValue("Hungarian-English", forKey: "deckname")
        
        let card1 = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        card1.setValue("alma", forKey: "fronttext")
        card1.setValue("apple", forKey: "backtext")
        card1.setValue(2, forKey: "id")
        card1.setValue("apple.jpg", forKey: "path")
        card1.setValue("Hungarian-English", forKey: "deckname")
        
        
        let card2 = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        card2.setValue("nyolc", forKey: "fronttext")
        card2.setValue("opt", forKey: "backtext")
        card2.setValue(3, forKey: "id")
        card2.setValue("eight.jpg", forKey: "path")
        card2.setValue("Hungarian-Romanian", forKey: "deckname")
        
        
        let card3 = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        card3.setValue("vonat", forKey: "fronttext")
        card3.setValue("tren", forKey: "backtext")
        card3.setValue(4, forKey: "id")
        card3.setValue("train.jpg", forKey: "path")
        card3.setValue("Hungarian-Romanian", forKey: "deckname")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    func fetchFromCoreData(){
        var cards = [Card]()
        
        let managedContext = self.managedObjectContext
        print("in fetch cards")
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Card")
        
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            cards = results as! [Card]
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("Count: ")
        print(cards.count)
        
       
        for actCard in cards{
            var found = false
            
            for actDeck in decks{
                
                if actCard.deckname == actDeck.deckName{
                    actDeck.cards.append(actCard)
                    found=true
                }
            }
            if !found{
                var tempDeck =  Deck()
                tempDeck.deckName=actCard.deckname!
                tempDeck.cards.append(actCard)
                decks.append(tempDeck)
            }
        }
        print(decks[1].deckName)
  
    }
    
    
    
    
    
}

