//
//  AddDeckViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/5/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import UIKit



protocol AddCardViewControllerDelegate: class {
    func addCardViewControllerDidCancel(controller: AddCardViewController)
    func addCardViewController(controller: AddCardViewController,
        didFinishAddingCard card: Card)
    
    func addCardViewController(controller: AddCardViewController, didFinishEditingCard card: Card)
}




class AddCardViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddCardViewControllerDelegate?
    
    var cardToEdit: Card?
    
    @IBAction func cancel() { delegate?.addCardViewControllerDidCancel(self)
    }
    
    
    
    @IBAction func done() {
        if let card = cardToEdit {
            card.fronttext = textField.text!
            delegate?.addCardViewController(self, didFinishEditingCard: card)
        } else {
            let card = Card()
            card.fronttext = textField.text!
            delegate?.addCardViewController(self, didFinishAddingCard: card)
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
        if let card = cardToEdit { title = "Edit Card"
            textField.text = card.fronttext
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