//
//  Category.swift
//  There are These Things
//
//  Created by Jared Boynton on 6/23/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name: String = ""
    //this is creating a relationship
    //List is a Realm framework thing like arrays
    let items = List<Item>()
    
}
