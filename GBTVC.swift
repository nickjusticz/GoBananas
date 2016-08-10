//
//  GBTVC.swift
//  GoBananas
//
//  Created by Nick Justicz on 8/9/16.
//  Copyright © 2016 Nick Justicz. All rights reserved.
//

import UIKit
import Foundation

protocol GBDelegate {
    func hasClicked(item:groceryItemCell)
    func hasEdited(item:groceryItemCell)
}

struct groceryItem {
    var item : String
    var itemNum: Int
    var itemDetails : String?
    var inCart : Bool
    
    init(name:String, details:String, num:Int, iC: Bool) {
        self.item = name
        self.itemNum = num
        self.itemDetails = details
        self.inCart = iC
    }
}

class groceryItemCell : UITableViewCell {
    @IBOutlet weak var groceryName: UILabel!
    @IBOutlet weak var groceryDetails: UILabel!
    @IBOutlet weak var inCartButton: UIButton!

    var delegate : GBDelegate?
    var gc : groceryItem? {
        didSet {
            if gc != nil {
            groceryName.text = "\(gc!.itemNum)x \(gc!.item)"
            groceryDetails.text = gc?.itemDetails
            if gc?.inCart == false {
                inCartButton.setImage(UIImage.init(named: "np"), forState: .Normal)
                gc?.inCart = true
            } else {
                inCartButton.setImage(UIImage.init(named: "p"), forState: .Normal)
                gc?.inCart = false
                }
            }
        }
    }
    
    @IBAction func hasClicked(sender: UIButton) {
        delegate?.hasClicked(self)
    }
    @IBAction func hasEdited(sender: AnyObject) {
        delegate?.hasEdited(self)
    }
}

class GBTVC: UITableViewController, GBDelegate {
    var cart = [groceryItem]()
    var editCard = groceryItem?()
    var isEdit = false
    var index = 0
    
    @IBAction func addHit(sender: UIBarButtonItem) {
    }
    
    func hasClicked(item:groceryItemCell) {
        if let gc = tableView.indexPathForCell(item) {
            if cart[gc.row].inCart == false {
                item.inCartButton.setImage(UIImage.init(named: "p"), forState: .Normal)
                cart[gc.row].inCart = true
            } else {
                item.inCartButton.setImage(UIImage.init(named: "np"), forState: .Normal)
                cart[gc.row].inCart = false
            }
            tableView.reloadRowsAtIndexPaths([gc], withRowAnimation: .Fade)
        }
        saveGroceries()
    }
    
    func hasEdited(item:groceryItemCell) {
        if let gc = tableView.indexPathForCell(item) {
            editCard = cart[gc.row]
            isEdit = true
            index = gc.row
            performSegueWithIdentifier("toGroc", sender: self)
        }
    }
    
    func getGroceries() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let testArray : AnyObject? = defaults.objectForKey("keySave")
        if testArray != nil {
            var tasks = [groceryItem]()
            for t in testArray as! [NSArray] {
                let task = groceryItem(name: t[0] as! String, details: t[1] as! String, num: t[2] as! Int, iC: t[3] as! Bool)
                tasks.append(task)
            }
            self.cart += tasks
            tableView.reloadData()
        }
    }
    
    func saveGroceries() {
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
        isEdit = false
        getGroceries()
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groceryItemCell", forIndexPath: indexPath) as! groceryItemCell
        cell.gc = cart[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGroc" {
        let viewControllerB = segue.destinationViewController as? pop
        viewControllerB!.cart = cart
        viewControllerB!.editCard = editCard
        viewControllerB!.index = index
        viewControllerB!.isEdit = isEdit
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        cart.removeAtIndex(indexPath.row)
        saveGroceries()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } 
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let gc = cart.removeAtIndex(fromIndexPath.row)
        cart.insert(gc, atIndex: toIndexPath.row)
    }
}

