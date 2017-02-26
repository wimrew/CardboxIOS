//
//  AddDeckViewController.swift
//  CardBoxIOS
//
//  Created by macmini on 2/5/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import UIKit
import CoreData



protocol AddCardViewControllerDelegate: class {
    func addCardViewControllerDidCancel(controller: AddCardViewController)
    func addCardViewController(controller: AddCardViewController,
        didFinishAddingCard card: Cardd)
    
    func addCardViewController(controller: AddCardViewController, didFinishEditingCard card: Card)
}




class AddCardViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldFrontText: UITextField!
    @IBOutlet weak var textFieldBackText: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    var image: UIImage?
    
    weak var delegate: AddCardViewControllerDelegate?
    
    var cardToEdit: Card?
    var deck: Deck?
    var deckPosition: Int64 = 11
    
    
    
    
    let applicationDocumentsDirectory: String = {
        let paths = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true)
        return paths[0]
        }()
    
    
    @IBAction func onAddPhoto() {
        pickPhoto()
    }
    
    @IBAction func cancel() { delegate?.addCardViewControllerDidCancel(self)
    }
    
    
    
    @IBAction func done() {
        if let card = cardToEdit {
            card.fronttext = textFieldFrontText.text!
            card.backtext = textFieldBackText.text!
            
            
            
            
            if let image = image { // 1
                print("saving the image in edit")
                if let data = UIImageJPEGRepresentation(image, 0.5) { // 3
                    print("saving the image2")
                    do {
                        
                        let filename = "Photo-\(card.path!).jpg"
                        print("card picture saved with filename")
                        print(filename)
                        let photoPath = (applicationDocumentsDirectory as NSString)
                            .stringByAppendingPathComponent(filename)
                        print("the photopath from the filename")
                        print(photoPath)
                        
                        try data.writeToFile(photoPath,
                            options: .DataWritingAtomic)
                        print("picture written to disk")
                    } catch {
                        print("Error writing file: \(error)")
                    }

                }
            
            }
            
            
            
            
            
            delegate?.addCardViewController(self, didFinishEditingCard: card)
        } else {
                                   let tempCardd = Cardd()
            tempCardd.frontText=textFieldFrontText.text!
            tempCardd.backText=textFieldBackText.text!
            tempCardd.deckName=(deck?.deckName)!
            tempCardd.cardID=NSNumber(longLong:(deckPosition*10+(deck?.cards.count)!))
            tempCardd.photoID=Card.nextPhotoID()
            
            
            
            
            if let image = image { // 1
                print("saving the image")
                if let data = UIImageJPEGRepresentation(image, 0.5) { // 3
                print("saving the image2")
                do {
                
                let filename = "Photo-\(tempCardd.photoID).jpg"
                    print("card picture saved with filename")
                print(filename)
                let photoPath = (applicationDocumentsDirectory as NSString)
                    .stringByAppendingPathComponent(filename)
                    print("the photopath from the filename")
                print(photoPath)
                
               try data.writeToFile(photoPath,
                options: .DataWritingAtomic)
                    print("picture written to disk")
            } catch {
            print("Error writing file: \(error)")
                }
                }
                print("saving the image3")
        }
                
                    
            
             print("making a new cardD")
            
            
            
            
            
            
            delegate?.addCardViewController(self, didFinishAddingCard: tempCardd)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textFieldFrontText.becomeFirstResponder()
    }
    
    
    override func viewDidLoad() { super.viewDidLoad()
        if let card = cardToEdit { title = "Edit Card"
            textFieldFrontText.text = card.fronttext
            textFieldBackText.text = card.backtext
            doneBarButton.enabled = true
            print("in edit card")
            print(card.path?.characters.count)
            print(card.path?.characters.count>0)
            print("card path in editcard")
            print(card.path)
            
            if card.path?.characters.count>0 {
                print("value of card.photoimage")
                print(card.photoImage)
                
                if let image = card.photoImage {
                
                showImage(image)
                }
            }
            

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
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("clicked on section and row")
        print(indexPath.section)
        print(indexPath.row)
        if indexPath.section == 0 && indexPath.row == 2 {
        takePhotoWithCamera()
        }
        }
    
    func showImage(image: UIImage) {
            imageView.image = image
            imageView.hidden = false
            
    }
    
}



extension AddCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func takePhotoWithCamera() {
    print("took photo with camera")
    
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .Camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
    
    }
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    image = info[UIImagePickerControllerEditedImage] as? UIImage
    if let image = image { showImage(image)
    }
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil) }
    
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) { dismissViewControllerAnimated(true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
        showPhotoMenu() } else {
        choosePhotoFromLibrary() }
    }
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil,
        preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let takePhotoAction = UIAlertAction(title: "Take Photo",
        style: .Default, handler: nil)
        alertController.addAction(takePhotoAction)
        let chooseFromLibraryAction = UIAlertAction(title:
        "Choose From Library", style: .Default, handler: nil)
        alertController.addAction(chooseFromLibraryAction)
        presentViewController(alertController, animated: true, completion: nil)
    }


}