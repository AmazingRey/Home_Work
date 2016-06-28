//
//  UserHadReadPostEntity+CoreDataProperties.h
//  XKRW
//
//  Created by Seth Chen on 16/2/17.
//  Copyright © 2016年 XiKang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserHadReadPostEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserHadReadPostEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *postID;
@property (nullable, nonatomic, retain) NSString *postName;
@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) UserHadReadPostEntity *info;

@end

NS_ASSUME_NONNULL_END
