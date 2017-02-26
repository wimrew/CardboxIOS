//
//  Card.swift
//  CardBoxIOS
//
//  Created by macmini on 2/4/17.
//  Copyright © 2017 macmini. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Card: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var gotitCount: Int64=0
    
    let applicationDocumentsDirectory: String = {
        let paths = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true)
        return paths[0]
        }()
    
    
    var photoPath: String {
        assert(path != nil, "No photo ID set")
        let filename = "Photo-\(path!).jpg"
        print("the photopath:")
        print(filename)
        return (applicationDocumentsDirectory as NSString)
        .stringByAppendingPathComponent(filename)
    }
    
    
    var photoImage: UIImage? {
            return UIImage(contentsOfFile: photoPath)
    }
    
    
    class func nextPhotoID() -> String {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let currentID = userDefaults.integerForKey("PhotoID")
            userDefaults.setInteger(currentID + 1, forKey: "PhotoID")
            userDefaults.synchronize()
            return String(currentID)
    }
    
    
    
    
    class func actualDeckID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let currentID = userDefaults.integerForKey("ActualDeckID")
       
        return currentID
    }
    
    
    class func setActualDeckID(deckID: Int)  {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setInteger(deckID, forKey: "ActualDeckID")
                userDefaults.synchronize()
                    }

    
    
    
    
    
    
    
    
    var hasPhoto: Bool { return true
    }
    
   
     func imageForCard(card: Card) -> UIImage {
        if card.hasPhoto, let image = card.photoImage {
            return image }
        return UIImage()
    }
    
    func removePhotoFile() { if hasPhoto {
            let path = photoPath
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
            do {
        try fileManager.removeItemAtPath(path)
    } catch {
        print("Error removing file: \(error)")
            } }
            } }

    
    
    
}
