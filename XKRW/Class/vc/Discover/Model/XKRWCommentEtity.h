//
//  XKRWCommentEtity.h
//  XKRW
//
//  Created by Shoushou on 15/9/29.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWReplyEntity.h"

#define ExactlySixLinesHeight [XKRWUtil createAttributeStringWithString:@"\n \n \n \n \n " font:XKDefaultFontWithSize(14) color:colorSecondary_666666 lineSpacing:3.5 alignment:NSTextAlignmentLeft].size.height 

@interface XKRWCommentEtity : NSObject
// 是否展开全文
@property (nonatomic, assign) BOOL isOpen;
// 是否显示“全文”Btn
@property (nonatomic, assign) BOOL isShowBtn;
// 头像
@property (nonatomic, strong) NSString *iconUrl;
// 等级
@property (nonatomic, strong) NSString *levelUrl;
// 昵称
@property (nonatomic, strong) NSString *nameStr;
// 宣言
@property (nonatomic, strong) NSString *declaration;
// 传入的时间戳
@property (nonatomic, assign) NSInteger time;
// 经过逻辑计算显示的时间
@property (nonatomic, strong) NSString *timeShowStr;
// 评论
@property (nonatomic, strong) NSString *commentStr;
// 当前评论显示的文字高度
@property (nonatomic, assign) CGFloat mainCommentHeight;
@property (nonatomic, assign) CGFloat currentHeight;
// 实际评论完全高
@property (nonatomic, assign, readonly) CGFloat commentHeight;

@property (nonatomic, strong) NSNumber *comment_id;

@property (nonatomic, strong) NSMutableArray <XKRWReplyEntity *> *sub_Array;
// 计算评论Str实际高
- (void)calculateCommentStrHeight;
// 计算实际显示时间Str
- (void)calculateTimeShowStr;
@end
