//
//  XKRWDiscoverCell.m
//  XKRW
//
//  Created by Klein Mioke on 15/9/1.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWDiscoverCell.h"
#import "XKRWUtil.h"

#define default_imageView_height XKAppWidth * 9 / 16
#define default_small_imageView_height 70.f

@interface XKRWDiscoverCell ()

@property (nonatomic, strong) UIImageView *articleImageView;

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIButton *star;
@property (nonatomic, strong) UIButton *eye;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readNumLabel;

@property (nonatomic, strong) UIButton *moreView;
@property (nonatomic, strong) UILabel *moduleLabel;

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) BOOL showMore;

@end

@implementation XKRWDiscoverCell

#pragma mark - Initialization

- (instancetype)initWithType:(XKRWDiscoverCellType)type {
    
    NSString *reuseIdentifier = getDiscoverCellTypeDescription(type);
    
    if ([self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.type = type;
        self.showMore = YES;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    [self initPublicSubviews];
    
    if (self.type == XKRWDiscoverCellTypeOnlyImage) {
        
        // big imageView
        self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, default_imageView_height)];
        self.articleImageView.image = [UIImage imageNamed:@"sport_detail_defalut"];
        self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView insertSubview:self.articleImageView belowSubview:self.moreView];
        
        // translusent view with 25% black
        UIView *translusentView = [[UIView alloc] initWithFrame:CGRectMake(0, default_imageView_height - 64, XKAppWidth, 64)];
        translusentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        
        [self.articleImageView addSubview:translusentView];
        
        // article title
        self.titleLabel.textColor = [UIColor whiteColor];
        
        [translusentView addSubview:self.titleLabel];
        
        // article time
        self.timeLabel.origin = CGPointMake(15, self.titleLabel.bottom + 5);
        self.timeLabel.textColor = [UIColor whiteColor];
        
        // read number
        self.readNumLabel.origin = CGPointMake(XKAppWidth - 15 - self.readNumLabel.width, self.timeLabel.top);
        self.readNumLabel.textColor = [UIColor whiteColor];
        
        [translusentView addSubview:self.timeLabel];
        [translusentView addSubview:self.readNumLabel];
        
        self.eye.right = self.readNumLabel.left - 2;
        [self.eye setCenterY:self.readNumLabel.center.y];
        
        self.star.right = self.eye.left - 2;
        [self.star setCenterY:self.readNumLabel.center.y];
        
        [translusentView addSubview:self.eye];
        [translusentView addSubview:self.star];
        
        self.moreView.top = self.articleImageView.bottom;
        
        [self.contentView addSubview:self.moreView];
        
        self.height = self.moreView.bottom;
        
    } else if (self.type == XKRWDiscoverCellTypeDefault) {
        
        self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, default_small_imageView_height, default_small_imageView_height)];
        self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.articleImageView];
        self.articleImageView.backgroundColor = [UIColor black25PercentColor];
        
        self.titleLabel.left = self.articleImageView.right + 10;
        self.titleLabel.width = XKAppWidth - 30 - 10 - self.articleImageView.width;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.top = 10;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel.left = self.titleLabel.left;
        self.timeLabel.bottom = self.articleImageView.bottom;
        [self.contentView addSubview:self.timeLabel];
        
        self.readNumLabel.right = self.titleLabel.right;
        self.readNumLabel.top = self.timeLabel.top;
        [self.contentView addSubview:self.readNumLabel];
        
        self.eye.right = self.readNumLabel.left - 5;
        [self.eye setCenterY:self.readNumLabel.center.y];
        [self.contentView addSubview:self.eye];
        
        self.star.right = self.eye.left - 2;
        [self.star setCenterY:self.eye.center.y];
        [self.contentView addSubview:self.star];
        
        self.detailLabel.top = self.articleImageView.bottom + 8;
        self.detailLabel.numberOfLines = 0;
        [self.contentView addSubview:self.detailLabel];
        
        self.moreView.top = self.detailLabel.bottom + 10;
        [self.contentView addSubview:self.moreView];
        
        self.height = self.moreView.bottom;
        
    } else if (self.type == XKRWDiscoverCellTypeOnlyTitle) {
        
        [self.contentView addSubview:self.titleLabel];
        
        self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, self.timeLabel.height)];
        self.infoView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.infoView];
        
        self.timeLabel.left = 15.f;
        [self.infoView addSubview:self.timeLabel];
        
        self.readNumLabel.right = XKAppWidth - 15.f;
        [self.infoView addSubview:self.readNumLabel];
        
        self.eye.right = self.readNumLabel.left - 2;
        [self.eye setCenterY:self.readNumLabel.center.y];
        [self.infoView addSubview:self.eye];
        
        self.star.right = self.eye.left - 2;
        [self.star setCenterY:self.readNumLabel.center.y];
        [self.infoView addSubview:self.star];
        
        [self.contentView addSubview:self.moreView];
        
        [self resetSubviews];
        
    } else if (self.type == XKRWDiscoverCellTypeImageAndTitle) {
        
        self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, default_small_imageView_height, default_small_imageView_height)];
        self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.articleImageView];
        self.articleImageView.backgroundColor = [UIColor black25PercentColor];
        
        self.titleLabel.left = self.articleImageView.right + 10;
        self.titleLabel.width = XKAppWidth - 30 - 10 - self.articleImageView.width;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.top = 10;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel.left = self.titleLabel.left;
        self.timeLabel.bottom = self.articleImageView.bottom;
        [self.contentView addSubview:self.timeLabel];
        
        self.readNumLabel.right = self.titleLabel.right;
        self.readNumLabel.top = self.timeLabel.top;
        [self.contentView addSubview:self.readNumLabel];
        
        self.eye.right = self.readNumLabel.left - 2;
        [self.eye setCenterY:self.readNumLabel.center.y];
        [self.contentView addSubview:self.eye];
        
        self.star.right = self.eye.left - 2;
        [self.star setCenterY:self.eye.center.y];
        [self.contentView addSubview:self.star];
        
        self.moreView.top = self.articleImageView.bottom + 10;
        [self.contentView addSubview:self.moreView];
        
        self.height = self.moreView.bottom;
        
    } else if (self.type == XKRWDiscoverCellTypeTitleAndDetail) {
        
        [self.contentView addSubview:self.titleLabel];
        
        self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, self.timeLabel.height)];
        self.infoView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.infoView];
        
        self.timeLabel.left = 15.f;
        [self.infoView addSubview:self.timeLabel];
        
        self.readNumLabel.right = XKAppWidth - 15.f;
        [self.infoView addSubview:self.readNumLabel];
        
        self.eye.right = self.readNumLabel.left - 2;
        [self.eye setCenterY:self.readNumLabel.center.y];
        [self.infoView addSubview:self.eye];
        
        self.star.right = self.eye.left - 2;
        [self.star setCenterY:self.readNumLabel.center.y];
        [self.infoView addSubview:self.star];
        
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.moreView];
        
        [self resetSubviews];
    }
}

- (void)initPublicSubviews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    
    CGFloat height = [@"标题" boundingRectWithSize:CGSizeMake(100, 100)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]}
                                         context:nil].size.height;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, XKAppWidth - 30, height)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = XK_TITLE_COLOR;
    self.titleLabel.text = @"介是标题";
    self.titleLabel.backgroundColor = [UIColor black25PercentColor];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, XKAppWidth - 30, 20)];
    NSMutableAttributedString *string = [XKRWUtil createAttributeStringWithString:@"这里是内容区域，可以显示多行\n多行"
                                                                             font:[UIFont systemFontOfSize:14]
                                                                            color:XK_TEXT_COLOR lineSpacing:3.5
                                                                        alignment:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 0;
    
    self.detailLabel.height = [string boundingRectWithSize:CGSizeMake(self.detailLabel.width, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size.height;
    self.detailLabel.attributedText = string;
    self.detailLabel.backgroundColor = [UIColor black25PercentColor];
    
    self.star = [UIButton buttonWithType:UIButtonTypeCustom];
    self.star.userInteractionEnabled = NO;
    [self.star setBackgroundImage:[UIImage imageNamed:@"discover_star"] forState:UIControlStateNormal];
    [self.star setBackgroundImage:[UIImage imageNamed:@"discover_star_hightlighted"] forState:UIControlStateSelected];
    self.star.size = [UIImage imageNamed:@"discover_star"].size;
    
    self.eye = [UIButton buttonWithType:UIButtonTypeCustom];
    self.eye.userInteractionEnabled = NO;
    [self.eye setBackgroundImage:[UIImage imageNamed:@"discover_eye"] forState:UIControlStateNormal];
    self.eye.size = [UIImage imageNamed:@"discover_eye"].size;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth / 3, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
    self.timeLabel.text = @"2000-01-01";
    self.timeLabel.backgroundColor = [UIColor black25PercentColor];
    
    self.readNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
    self.readNumLabel.font = [UIFont systemFontOfSize:12];
    self.readNumLabel.textColor = XK_ASSIST_TEXT_COLOR;
    self.readNumLabel.textAlignment = NSTextAlignmentRight;
    self.readNumLabel.text = @"123456";
    self.readNumLabel.backgroundColor = [UIColor black25PercentColor];
    
    self.moreView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    self.moreView.backgroundColor = [UIColor whiteColor];
    [self.moreView addTarget:self action:@selector(handleClickMoreArticleAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.moduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, XKAppWidth / 2, 44)];
    self.moduleLabel.textColor = XK_TEXT_COLOR;
    self.moduleLabel.font = [UIFont systemFontOfSize:14];
    self.moduleLabel.text = @"模块名";
    
    [self.moreView addSubview:self.moduleLabel];
    
    UIImageView *enter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right5_3"]];
    enter.contentMode = UIViewContentModeScaleAspectFit;
    enter.right = XKAppWidth;
    enter.top = (self.frame.size.height - enter.frame.size.height)/2;
    [self.moreView addSubview:enter];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"更多";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = XK_TEXT_COLOR;
    label.font = [UIFont systemFontOfSize:14];
    
    label.right = enter.left + 5;
    
    [self.moreView addSubview:label];
    
    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    lineTop.backgroundColor = XK_ASSIST_LINE_COLOR;
    
    [self.contentView addSubview:lineTop];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, XKAppWidth, 0.5)];
    self.bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    
    UIView *lineSep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    lineSep.backgroundColor = XK_ASSIST_LINE_COLOR;
    
    [self.moreView addSubview:self.bottomLine];
    [self.moreView addSubview:lineSep];
}

#pragma mark - set content
- (void)setContent:(id)entity showMore:(BOOL)show {
    
    if (!show) {
        [self.moreView removeFromSuperview];
        [self resetSubviews];
    }
}

- (void)resetSubviews {
    
    if (self.type == XKRWDiscoverCellTypeOnlyImage) {
        
        if (_showMore) {
            self.height = self.moreView.bottom;
        } else {
            self.height = self.articleImageView.bottom;
            
            [self.bottomLine removeFromSuperview];
            self.bottomLine.bottom = self.height;
            [self.contentView addSubview:self.bottomLine];
        }
        
    } else if (self.type == XKRWDiscoverCellTypeDefault) {
    
        self.detailLabel.top = self.articleImageView.bottom + 8;
        
        self.moreView.top = self.detailLabel.bottom + 5;
        
        self.height = self.moreView.bottom;
        
    } else if (self.type == XKRWDiscoverCellTypeOnlyTitle) {
        
        self.infoView.top = self.titleLabel.bottom + 5;
        
        if (_showMore) {
            self.moreView.top = self.infoView.bottom + 5;
            self.height = self.moreView.bottom;
        } else {
            self.height = self.infoView.bottom + 5;
            
            [self.bottomLine removeFromSuperview];
            self.bottomLine.bottom = self.height;
            [self.contentView addSubview:self.bottomLine];
        }
        
    } else if (self.type == XKRWDiscoverCellTypeImageAndTitle) {
        
    } else if (self.type == XKRWDiscoverCellTypeTitleAndDetail) {
        
        self.infoView.top = self.titleLabel.bottom + 5;
        self.detailLabel.top = self.infoView.bottom + 5;
        
        if (_showMore) {
            self.moreView.top = self.detailLabel.bottom + 5;
            self.height = self.moreView.bottom;
        } else {
            self.height = self.detailLabel.bottom + 5;
            
            [self.bottomLine removeFromSuperview];
            self.bottomLine.bottom = self.height;
            [self.contentView addSubview:self.bottomLine];
        }
    }
}

- (NSMutableAttributedString *)createTitleAttributedStringWithString:(NSString *)title {
    
    return [XKRWUtil createAttributeStringWithString:title
                                                font:[UIFont systemFontOfSize:18]
                                               color:XK_TITLE_COLOR lineSpacing:3.5
                                           alignment:NSTextAlignmentLeft];
}

- (NSMutableAttributedString *)createDetailAttributedStringWithString:(NSString *)detail {
    
    return [XKRWUtil createAttributeStringWithString:detail
                                                font:[UIFont systemFontOfSize:14]
                                               color:XK_TEXT_COLOR lineSpacing:3.5
                                           alignment:NSTextAlignmentLeft];
}

#pragma mark - actions

- (void)handleClickMoreArticleAction {
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

NSString * getDiscoverCellTypeDescription(XKRWDiscoverCellType type) {
    
    switch (type) {
        case XKRWDiscoverCellTypeDefault:
            return @"XKRWDiscoverCellTypeDefault";
            break;
        case XKRWDiscoverCellTypeOnlyImage:
            return @"XKRWDiscoverCellTypeOnlyImage";
            break;
        case XKRWDiscoverCellTypeOnlyTitle:
            return @"XKRWDiscoverCellTypeOnlyTitle";
            break;
        case XKRWDiscoverCellTypeImageAndTitle:
            return @"XKRWDiscoverCellTypeImageAndTitle";
            break;
        case XKRWDiscoverCellTypeTitleAndDetail:
            return @"XKRWDiscoverCellTypeTitleAndDetail";
            break;
            
        default:
            return nil;
    }
}

@end
