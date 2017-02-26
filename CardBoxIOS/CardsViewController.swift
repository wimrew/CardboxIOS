//
//  CardsViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/5/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CardsViewController: UITableViewController, AddCardViewControllerDelegate {
 var deck = Deck()
    var managedObjectContext: NSManagedObjectContext!
    var deckPosition: Int64=10
    
    var image: UIImage?

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deck.cards.count
    }
    
    @IBAction func back(){
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "CardItem", forIndexPath: indexPath)
        let label = cell.viewWithTag(1100) as! UILabel
        
        label.text=deck.cards[indexPath.row].fronttext
        
        return cell }
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            decks[selectedDeckID].selectedDeck=false
            let tempPath = NSIndexPath(forRow:selectedDeckID, inSection: 0)
            tableView.cellForRowAtIndexPath(tempPath)?.accessoryType = .None
            
            selectedDeckID=indexPath.row
            decks[selectedDeckID].selectedDeck=true
            print("selected deck id")
            print(selectedDeckID)
            
            }                 }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    */
    
    
    override func tableView(tableView: UITableView,
                commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
                // 1
                    print(deck.cards[indexPath.row])
                    managedObjectContext.deleteObject(deck.cards[indexPath.row])
                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                deck.cards.removeAtIndex(indexPath.row)
                // 2
                let indexPaths = [indexPath]
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    
    
    
    func addCardViewControllerDidCancel(controller: AddCardViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func addCardViewController(controller: AddCardViewController, didFinishAddingCard card: Cardd) {
        
        print("arrived to CardsViewController")
        let entity =  NSEntityDescription.entityForName("Card",
            inManagedObjectContext:managedObjectContext)
        
        let cardC = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        let applicationDocumentsDirectory: String = {
            let paths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true)
            return paths[0]
            }()
        
       
        
        if let image = image { // 1
            
            // 2
            if let data = UIImageJPEGRepresentation(image, 0.5) { // 3
            do {
                try data.writeToFile((applicationDocumentsDirectory as NSString)
                .stringByAppendingPathComponent("Photo-\(card.photoID).jpg"), options: .DataWritingAtomic)
        } catch {
                print("Error writing file: \(error)")
            } }
        }
        
        
        
        
        cardC.setValue(card.frontText, forKey: "fronttext")
        cardC.setValue(card.backText, forKey: "backtext")
        cardC.setValue(card.cardID, forKey: "id")
        cardC.setValue(card.photoID, forKey: "path")
        cardC.setValue(card.deckName, forKey: "deckname")
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
print("card created and inserted")
        
        let newRowIndex = deck.cards.count
        deck.cards.append(cardC as! Card)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths,
            withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
        print("contr dismissed after card insert")
        
    }
    
    
    
    func addCardViewController(controller: AddCardViewController, didFinishEditingCard card: Card) {
            
            
            
                       
            
        if let index = deck.cards.indexOf(card) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: card)
            }
        }
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        dismissViewControllerAnimated(true, completion: nil) }
    
    
    func configureTextForCell(cell: UITableViewCell,
        withChecklistItem card: Card) {
            let label = cell.viewWithTag(1100) as! UILabel
            label.text = card.fronttext}

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 1
        if segue.identifier == "AddCard" { // 2
            let navigationController = segue.destinationViewController
            as! UINavigationController
            // 3
            let controller = navigationController.topViewController
            as! AddCardViewController
            // 4
            controller.delegate = self
        controller.deck = deck
            controller.deckPosition = deckPosition
        }
            else if segue.identifier == "EditCard" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController as! AddCardViewController
            controller.delegate = self
            controller.deck = deck
            controller.deckPosition = deckPosition
            
            let point = tableView.convertPoint(CGPointZero, fromView: sender as! UIButton)
            if let indexPath = tableView.indexPathForRowAtPoint(point){
                controller.cardToEdit = deck.cards[indexPath.row] }
        }
    }
    
    
}
