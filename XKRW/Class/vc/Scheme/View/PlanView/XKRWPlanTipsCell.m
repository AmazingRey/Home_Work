//
//  XKRWPlanTipsCell.m
//  XKRW
//
//  Created by 忘、 on 16/4/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanTipsCell.h"
#import "Masonry.h"
#import "XKRWUtil.h"
#import "XKRWPlanTipsEntity.h"

@interface XKRWPlanTipsCell ()

@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *downLineView;

@property (nonatomic, strong) UIView *lineView;
@end


@implementation XKRWPlanTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView {
    self.contentView.backgroundColor = XK_BACKGROUND_COLOR ;
    
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@16);
        make.height.equalTo(@16);
        make.width.equalTo(@16);

    }];
    
    [self.upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.mas_equalTo(0.5);
        make.left.equalTo(@23);
        make.bottom.equalTo(self.circleImageView.mas_top);
    }];
    
    [self.downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.mas_equalTo(0.5);
        make.left.equalTo(@23);
        make.top.equalTo(self.circleImageView.mas_bottom);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(self.circleImageView.mas_right).offset(5);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(0));
    }];
    
   CGFloat twoLinesHeight = [XKRWUtil createAttributeStringWithString:@" \n" font:XKDefaultFontWithSize(15) color:XK_ASSIST_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft].size.height;
    [self.TipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.height.mas_greaterThanOrEqualTo(@(twoLinesHeight));
        make.bottom.equalTo(@(-10));
        make.right.equalTo(@(-10));
    }];
}


- (void)updateHeightCell:(XKRWPlanTipsEntity *)entity {
    UIImage *boxImage =  [UIImage imageNamed:@"bubble box"];
    UIImage *stretchImage = [ boxImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 5, 10, 10)];
    _backgroundImageView.image = stretchImage;
    _circleImageView.image = [UIImage imageNamed:_imageName];

    _TipLabel.attributedText = [XKRWUtil createAttributeStringWithString:entity.tipsText font:XKDefaultFontWithSize(15) color:XK_ASSIST_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
    _TipLabel.textColor = _TipLabelColor;
    if(entity.showType == TipsShowText){
        [self.TipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-5));
        }];
        self.lineView.hidden = YES;
        self.actionButton.hidden = YES;
    }else{
        [self.TipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-95));
        }];
        
        self.lineView.hidden = NO;
        self.actionButton.hidden = NO;
        CGFloat blankHeight = ([XKRWUtil createAttributeStringWithString:entity.tipsText font:XKDefaultFontWithSize(15) color:XK_ASSIST_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft].size.height + 20) / 4.0;
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(- blankHeight));
            make.top.equalTo(@(blankHeight));
            make.right.equalTo(@(-90));
            make.width.equalTo(@0.5);
        }];
        
        
        [self.actionButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
             make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(@89);
        }];
        
        if (entity.showType == TipsShowAndEnactNewPlan) {
            [self.actionButton setTitle:@"制定计划" forState:UIControlStateNormal];
            self.actionButton.tag = 1001;
        }else if (entity.showType == TipsShowAndShowDetail){
            [self.actionButton setTitle:@"马上查看" forState:UIControlStateNormal];
            self.actionButton.tag = 1002;
        
        }else if(entity.showType == TipsShowAndEnterSet){
            [self.actionButton setTitle:@"设置" forState:UIControlStateNormal];
            self.actionButton.tag = 1003;
        }else if (entity.showType == TipsShowSchemeFood){
            [self.actionButton setTitle:@"查看食谱" forState:UIControlStateNormal];
            self.actionButton.tag = 1004;
        }
    }
}

- (UIImageView *)circleImageView{
    if(_circleImageView == nil){
        _circleImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_circleImageView];
    }
    return _circleImageView;
}

- (UIView *)upLineView {
    if (_upLineView == nil) {
        _upLineView = [[UIView alloc] init];
        _upLineView.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self.contentView addSubview:_upLineView];
    }
    return _upLineView;
}


- (UIView *)downLineView {
    if (_downLineView == nil) {
        _downLineView = [[UIView alloc] init];
        _downLineView.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self.contentView addSubview:_downLineView];
    }
    return _downLineView;
}

- (UIImageView *)backgroundImageView {
    if(_backgroundImageView == nil){
        _backgroundImageView =  [[UIImageView alloc] init];
        [self.contentView addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (UIView *)lineView {
    if(_lineView == nil){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XK_ASSIST_LINE_COLOR;
        [_backgroundImageView addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)actionButton
{
    if (_actionButton == nil){
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        [_actionButton.titleLabel setFont:XKDefaultFontWithSize(14)];
        _backgroundImageView.userInteractionEnabled = YES;
         [_backgroundImageView addSubview:_actionButton];
    }
    return _actionButton;
}

- (UILabel *)TipLabel{
    if (_TipLabel == nil) {
        _TipLabel = [[UILabel alloc] init];
        _TipLabel.numberOfLines = 0;
        [_backgroundImageView addSubview:_TipLabel];
    }
    return _TipLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
