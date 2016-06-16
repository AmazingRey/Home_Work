//
//  ArticalListEntity+CoreDataProperties.h
//  XKRW
//
//  Created by ss on 16/6/16.
//  Copyright © 2016年 XiKang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ArticalListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticalListEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSString *adID;

@end

NS_ASSUME_NONNULL_END
