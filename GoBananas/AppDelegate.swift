//
//  AppDelegate.swift
//  GoBananas
//
//  Created by Nick Justicz on 8/9/16.
//  Copyright © 2016 Nick Justicz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let nc = window?.rootViewController as? UINavigationController {
            if let vc = nc.topViewController as? GBTVC {
                
        let groceries = vc.cart
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
        }

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if let nc = window?.rootViewController as? UINavigationController {
            if let vc = nc.topViewController as? GBTVC {
                
                let groceries = vc.cart
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
        }
    }


}

