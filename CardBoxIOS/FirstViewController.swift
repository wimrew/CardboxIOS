//
//  FirstViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/4/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var gotitButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    
    var deck: Deck?
    var card: Card?
    
    var learnNumber: Int64=2
    
    var decks = [Deck]()
    
  //  var actCard = 0
    var actDeck = 1
    
    var actCard: Int = 0

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("switched viewcontrl")
        
        fetchFromCoreData()
        
        gotitButton.hidden=true
        againButton.hidden=true
        flipButton.hidden=false
        actCard = 0
          getDeck()
        unlearnDeck()
         loadCard()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("decks in first viewc")
     //   print(decks.count)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func flip() {
        changeScreen()
        textLabel.text = card?.backtext
    }
    
    @IBAction func gotit() {
        print(card?.gotitCount)
        card?.gotitCount++
        changeScreen()
        getNewCardAndLoad()
        
        
    }
    
    @IBAction func again() {
        changeScreen()
        getNewCardAndLoad()
        
    }

    
    func changeScreen(){
        gotitButton.hidden = !gotitButton.hidden
        againButton.hidden = !againButton.hidden
        flipButton.hidden = !flipButton.hidden
    }
    
    func getNewCardAndLoad(){
        if deckLearned() {
            closeDeck()} else{
        actCard = getRandomCard()
        print(actCard)
        print(decks[actDeck].cards.count)
       card = decks[actDeck].cards[actCard]
        
        
        
        loadCard()
    }
    }
    
    func getDeck(){
        
        /*
        for index in 0...decks.count-1{
            if decks[index].selectedDeck{
               actDeck = index
                print("new selected deck with id")
                print(decks[actDeck].deckName)
            }
        }
*/
        actDeck = Card.actualDeckID()
        deck = decks[actDeck]
        card = deck?.cards[actCard]
        
        
    
        
    }
    
    
    func  getRandomCard()->Int{
        
        
        let tempRandomNumberMax: UInt32 = UInt32(decks[actDeck].cards.count)
        var tempRandomNumber = Int(arc4random_uniform(tempRandomNumberMax))
        var tempCard = decks[actDeck].cards[tempRandomNumber]
        
        while tempCard.gotitCount>=learnNumber{
             tempRandomNumber = Int(arc4random_uniform(tempRandomNumberMax))
             tempCard = decks[actDeck].cards[tempRandomNumber]
        }

        return tempRandomNumber
        
    }
    
    func closeDeck(){
        imageCard.image=nil
        flipButton.hidden=true
        textLabel.text="You finished this deck. Go to 'Decks' and start another one!"
    }
    
    func deckLearned() ->Bool{
        var count=0
        for cardLearned in decks[actDeck].cards{
            if cardLearned.gotitCount>=learnNumber{count++}
        }
        if count==decks[actDeck].cards.count{
            print("deck learned")
            return true}
        else {
            return false}
    }
    
    func loadCard(){
        print(card?.fronttext)
        textLabel.text=card?.fronttext
        
            imageCard.image = UIImage(named: (card?.path)!)
        if (UIImage(named: (card?.path)!) == nil) {
            print("picture value is nil")
            imageCard.image = card?.photoImage
        }
        
    }
    
    func unlearnDeck(){
        for cardLearned in decks[actDeck].cards{
            cardLearned.gotitCount=0
        }
    }
    
    
    
    
    
    
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

