//
//  TeamPostNumEntity+CoreDataProperties.swift
//  XKRW
//
//  Created by 忘、 on 16/1/28.
//  Copyright © 2016年 XiKang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TeamPostNumEntity {

    @NSManaged var teamID: String?
    @NSManaged var postNum: NSNumber?
    @NSManaged var userID:  NSNumber?
}

