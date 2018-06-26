//
//  AppDelegate.swift
//  There are These Things
//
//  Created by Jared Boynton on 5/26/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //this is the location where the data is stored.
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
            _ = try Realm()
        } catch {
            print("There was an error instantiating a new realm object \(error)")
        }
        
        return true
    }

}

