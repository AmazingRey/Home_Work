//
//  XKFamilyService.h
//  XKCommon
//
//  Created by YourName on 13-4-3.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKService.h"
//#import "XKFamilyRelationEntity.h"

@interface XKFamilyService : XKService

+(XKFamilyService *)sharedService;

//- (void)addFamilyWithRelation:(XKFamilyRelationEntity *)relation;
- (void)updateFamilyWithFamilyID:(NSString *)familyID callMe:(NSString *)callMe callTa:(NSString *)callTa;
// 注册病添加家人
//- (NSString *)registerAndAddFamilyWithRelation:(XKFamilyRelationEntity *)relation
//                                         email:(NSString *)email
//                                     mobileNum:(NSString *)mobileNum
//                                      password:(NSString *)password
//                                      userName:(NSString *)userName
//                                       account:(NSString *)account;

@end
