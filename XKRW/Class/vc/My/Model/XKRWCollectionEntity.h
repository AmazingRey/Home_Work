//
//  XKRWCollectionEntity.h
//  XKRW
//
//  Created by Jack on 15/5/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWCollectionEntity : NSObject
/**
 *  收藏id
 */
//@property (nonatomic,assign) NSInteger cid;
/**
 *  收藏用户的id
 */
@property (nonatomic,assign) NSInteger uid;
/**
 *  收藏的类型type：0 文章，1 食物，2 运动
 */
@property (nonatomic,assign) NSInteger collectType;

/**
 *  收藏(文章、食物、运动)原本的id
 */
@property (nonatomic,assign) NSInteger originalId;

/**
 *  收藏的名字，分别表示文章标题(naviTitle)，食物名字，运动名称
 */
@property (nonatomic,strong)NSString *collectName;

///**
// *  收藏的卡路里
// */
//@property(nonatomic,assign) int calorie;

/**
 *  收藏的头图片url
 */
@property (nonatomic,strong)NSString *imageUrl;

/**
 *  收藏时间
 */
@property (nonatomic,strong) NSDate *date;

/**
 *  是否同步到服务器，是为1，否为0
 */
//@property (nonatomic) NSInteger sync;


#pragma mark - 以下为不同的部分
#pragma mark - 食物的字段
/**
 *  收藏的食物能量
 */
@property (nonatomic, assign) NSInteger foodEnergy;


#pragma mark - 运动的字段
///**
// *  收藏的运动mets
// */
//
//@property (nonatomic, assign) float     sportMets;
//

#pragma mark - 文章的字段
/**
 *  收藏的文章路径
 */
@property(nonatomic,strong)NSString *contentUrl;
/**
 *  收藏的文章类型
 */
@property(nonatomic,assign)XKOperation categoryType;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryInCollectionTable;



@end
