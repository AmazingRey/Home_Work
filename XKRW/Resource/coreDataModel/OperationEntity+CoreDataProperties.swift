//
//  OperationEntity+CoreDataProperties.swift
//  XKRW
//
//  Created by 忘、 on 16/2/29.
//  Copyright © 2016年 XiKang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension OperationEntity {

    @NSManaged var operationID: String?
    @NSManaged var operationTitle: String?
    @NSManaged var userID: NSNumber?

}
