//
//  DecksViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/5/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DecksViewController: UITableViewController, AddDeckViewControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    var decks = [Deck]()
    
    var selectedDeckID=1
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

     //   fetchFromCoreData()
      //  tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate
            as! AppDelegate
        let context = appDelegate.managedObjectContext
        print(context)
        print("decks in second viewc")
        print(decks.count)
        // Do any additional setup after loading the view, typically from a nib.
        
        decks[1].selectedDeck=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return decks.count
    }
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier( "DeckItem", forIndexPath: indexPath)
            let label = cell.viewWithTag(1000) as! UILabel
            
            label.text=decks[indexPath.row].deckName
        /*
        if decks[indexPath.row].selectedDeck==true{
                cell.accessoryType = .Checkmark
            } else {
              cell.accessoryType = .None
        }
*/
        print("redrawing decks")
        print(Card.actualDeckID())
       // print()
        if indexPath.row==Card.actualDeckID(){
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
            
            return cell }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .None && decks[indexPath.row].cards.count>0 {
                cell.accessoryType = .Checkmark
                decks[selectedDeckID].selectedDeck=false
                let tempPath = NSIndexPath(forRow:selectedDeckID, inSection: 0)
                tableView.cellForRowAtIndexPath(tempPath)?.accessoryType = .None
                
                selectedDeckID=indexPath.row
                decks[selectedDeckID].selectedDeck=true
                Card.setActualDeckID(selectedDeckID)
                print("selected deck id")
                print(selectedDeckID)
            
            }                 }
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
    
    
    override func tableView(tableView: UITableView,
                commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
                // 1
                    
                    
                    let deckTemp = decks[indexPath.row]
                    for index in 0...deckTemp.cards.count-1{
                        managedObjectContext.deleteObject(deckTemp.cards[index])
                    }
                    
                   
                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    
                    
                decks.removeAtIndex(indexPath.row)
                // 2
                let indexPaths = [indexPath]
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
   
    
    
    
    func addDeckViewControllerDidCancel(controller: AddDeckViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
   
    
    }
    
    func addDeckViewController(controller: AddDeckViewController, didFinishAddingDeck deck: Deck) {
                    
                    let newRowIndex = decks.count
                    decks.append(deck)
                    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
                    let indexPaths = [indexPath]
                    tableView.insertRowsAtIndexPaths(indexPaths,
                    withRowAnimation: .Automatic)
                    dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                    // 1
                    if segue.identifier == "AddDeck" { // 2
                    let navigationController = segue.destinationViewController
                    as! UINavigationController
                    // 3
                    let controller = navigationController.topViewController
                    as! AddDeckViewController
                    // 4
                    controller.delegate = self }
    
    
    else if segue.identifier == "ViewCards" {
   print("in viewcards")
    let navigationController = segue.destinationViewController
                        as! UINavigationController
    let controller = navigationController.topViewController
                        as! CardsViewController
                        let point = tableView.convertPoint(CGPointZero, fromView: sender as! UIButton)
if let indexPath = tableView.indexPathForRowAtPoint(point){
    controller.deck = decks[indexPath.row]
    controller.managedObjectContext=managedObjectContext
    print("the managedobjectcontext")
    print(managedObjectContext)
    controller.deckPosition=Int64(indexPath.row)
                        }
    
   }
    
            else if segue.identifier == "EditDeck" {
    let navigationController = segue.destinationViewController
        as! UINavigationController
    let controller = navigationController.topViewController
        as! AddDeckViewController
    controller.delegate = self
    
    let point = tableView.convertPoint(CGPointZero, fromView: sender as! UIButton)
    if let indexPath = tableView.indexPathForRowAtPoint(point){
    //if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        controller.deckToEdit = decks[indexPath.row] }
            }
    }
    
    func addDeckViewController(controller: AddDeckViewController, didFinishEditingDeck deck: Deck) {
                        if let index = decks.indexOf(deck) {
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                        configureTextForCell(cell, withChecklistItem: deck)
                        }
                        }
                        dismissViewControllerAnimated(true, completion: nil) }
    
    
    func configureTextForCell(cell: UITableViewCell,
        withChecklistItem deck: Deck) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = deck.deckName }
    
    
    
    
    
    
    
    
    
    
    
    func fetchFromCoreData(){
        var cards = [Card]()
        decks.removeAll()
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

