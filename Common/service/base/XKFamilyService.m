//
//  XKFamilyService.m
//  XKCommon
//
//  Created by YourName on 13-4-3.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKFamilyService.h"
#import "family.h"
#import "XKRpcUtil.h"

@implementation XKFamilyService

static XKFamilyService *_instance;

+(XKFamilyService *)sharedService{
    if (_instance == nil) {
        _instance = [[XKFamilyService alloc] init];
    }
    return _instance;
}

//- (void)addFamilyWithRelation:(XKFamilyRelationEntity *)relation{
//    FamilyServiceClient *client = [self rpcClientForClass:FamilyServiceClient.class];
//    CommArgs *commArgs = [XKRpcUtil commArgsForDigestAuth];
//    [client addFolk:commArgs relation:relation];
//}

- (void)updateFamilyWithFamilyID:(NSString *)familyID callMe:(NSString *)callMe callTa:(NSString *)callTa{
    FamilyServiceClient *client = [self rpcClientForClass:FamilyServiceClient.class];
    CommArgs *commArgs = [XKRpcUtil commArgsForDigestAuth];
    [client updateFolkNickname:commArgs folkId:familyID callMe:callMe callTa:callTa];
}

//- (NSString *)registerAndAddFamilyWithRelation:(XKFamilyRelationEntity *)relation
//                                         email:(NSString *)email
//                                     mobileNum:(NSString *)mobileNum
//                                      password:(NSString *)password
//                                      userName:(NSString *)userName
//                                       account:(NSString *)account{
//    FamilyServiceClient *client = [self rpcClientForClass:FamilyServiceClient.class];
//    CommArgs *commArgs = [XKRpcUtil commArgsForDigestAuth];
//    return [client registerAndAddFolk:commArgs email:email mobileNum:mobileNum password:password userName:userName account:account relation:relation];
//}

@end
