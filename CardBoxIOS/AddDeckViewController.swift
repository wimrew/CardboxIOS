//
//  AddDeckViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/5/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import UIKit



protocol AddDeckViewControllerDelegate: class {
    func addDeckViewControllerDidCancel(controller: AddDeckViewController)
    func addDeckViewController(controller: AddDeckViewController,
    didFinishAddingDeck deck: Deck)
    
    func addDeckViewController(controller: AddDeckViewController, didFinishEditingDeck deck: Deck)
}




class AddDeckViewController: UITableViewController, UITextFieldDelegate {
@IBOutlet weak var textField: UITextField!
@IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddDeckViewControllerDelegate?
    
    var deckToEdit: Deck?

    @IBAction func cancel() { delegate?.addDeckViewControllerDidCancel(self)
    }
    
    
    
    @IBAction func done() {
    if let deck = deckToEdit {
        deck.deckName = textField.text!
        delegate?.addDeckViewController(self, didFinishEditingDeck: deck)
    } else {
    let deck = Deck()
    deck.deckName = textField.text!
    delegate?.addDeckViewController(self, didFinishAddingDeck: deck)
    }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    
    override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
    }
    
    
    override func viewDidLoad() { super.viewDidLoad()
        if let deck = deckToEdit { title = "Edit Deck"
            
                      
        textField.text = deck.deckName
        doneBarButton.enabled = true
        } }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
        let oldText:NSString = textField.text!
        let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        if newText.length > 0 {
        doneBarButton.enabled=true
    } else {
        doneBarButton.enabled = false
        }
        return true
    }
    

}