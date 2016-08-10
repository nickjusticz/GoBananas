//
//  POP.swift
//  GoBananas
//
//  Created by Nick Justicz on 8/9/16.
//  Copyright © 2016 Nick Justicz. All rights reserved.
//

import UIKit
import Foundation

class pop : UIViewController {
    
    var cart = [groceryItem]()
    var editCard = groceryItem?()
    var isEdit = false
    var index = 0
    var gQuant = 1
    var allPurch = false
    
    @IBOutlet weak var gName: UITextField!
    @IBOutlet weak var gDetails: UITextField!
    @IBOutlet weak var quantLabel: UILabel!
    @IBOutlet weak var quant: UIStepper!
    @IBAction func quantHit(sender: UIStepper) {
        gQuant = Int(sender.value)
        quantLabel.text = String(gQuant)
    }
    
    @IBOutlet weak var PurchOut: UISwitch!
    @IBAction func purchHit(sender: AnyObject) {
        if allPurch == false {
            allPurch = true
        } else {
            allPurch = false
        }
    }
    
    @IBAction func addGroc(sender: AnyObject) {
        
        let name = gName.text
        if name == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter Grocery", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let deets = gDetails.text
        let g = groceryItem(name: name!, details: deets!, num: gQuant, iC: allPurch)
        if isEdit == true {
        cart.removeAtIndex(index)
        }
        cart.append(g)
        
        let groceries = cart
        let toSave = groceries.map({groceryItem -> (NSArray) in
            let a = NSString(string: groceryItem.item)
            let b = NSString(string: groceryItem.itemDetails!)
            let c = (groceryItem.itemNum)
            let d = NSNumber(bool: groceryItem.inCart)
            return NSArray(objects: a,b,c,d)
        })
        let saveArray = toSave as NSArray
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(saveArray, forKey: "keySave")
        defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quant.value = 1
        quant.wraps = true
        quant.autorepeat = true
        quant.maximumValue = 15
        
        if isEdit == true {
            gName.text = editCard?.item
            gDetails.text = editCard?.itemDetails
            gQuant = (editCard?.itemNum)!
            quant.value = Double(gQuant)
            quantLabel.text = String(gQuant)
            allPurch = (editCard?.inCart)!
            if allPurch == false {
                PurchOut.setOn(false, animated: false)
            } else {
                PurchOut.setOn(true, animated: false)
            }
        }
    }
    
}

