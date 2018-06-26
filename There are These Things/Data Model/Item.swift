//
//  Item.swift
//  There are These Things
//
//  Created by Jared Boynton on 6/23/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? //optional
    //inverse relationship to item (going backward relationship). Each item has one relationship with a category
    //the property is the relationship seen in category. The List
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
