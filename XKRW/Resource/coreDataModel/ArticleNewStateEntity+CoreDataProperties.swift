//
//  ArticleNewStateEntity+CoreDataProperties.swift
//  XKRW
//
//  Created by ss on 16/6/28.
//  Copyright © 2016年 XiKang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ArticleNewStateEntity {

    @NSManaged var nid: String?
    @NSManaged var userID: NSNumber?

}
