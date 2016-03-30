//
//  XKRWComprehensiveAssResultVC.m
//  XKRW
//
//  Created by XiKang on 15-1-21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWComprehensiveAssResultVC.h"

@interface XKRWComprehensiveAssResultVC ()
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *mentalReasonLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainReasonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatFeatureHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *psychologicalFactorHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *genaralView;
@property (weak, nonatomic) IBOutlet UIView *mainReasonView;
@property (weak, nonatomic) IBOutlet UIView *fatFeatureView;
@property (weak, nonatomic) IBOutlet UIView *psychologicalFactorView;

@end

@implementation XKRWComprehensiveAssResultVC
{
    XKRWOtherFactorsModel *_model;
}

#pragma mark - System's Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize

- (void)initSubviews {
    self.title = @"综合情况";
    [self addNaviBarBackButton];
    
    /*
     *  图片标题
     */
    NSDictionary *titles = [_model getTitleStrings];
    
    _characterLabel.text = titles[@"character"];
    _fatReasonLabel.text = titles[@"main"];
    _mentalReasonLabel.text = titles[@"mind"];
    
    CGFloat _yPoint = 43.f;
    /*
     *  主要肥胖原因
     */
    if (!_model.reasonArray.count || !_model.reasonArray) {
        
        _mainReasonHeightConstraint.constant = 0.f;
    } else {
        
        for (XKRWDescribeModel *model in _model.reasonArray) {
            
            UIColor *color = [XKRWUtil getStatusColorWithFlag:(int)model.flag];
            
            NSAttributedString *title = [XKRWUtil createAttributeStringWithString:model.result font:XKDefaultFontWithSize(16.f) color:color lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth-30.f, 20.f)];
            titleLabel.attributedText = title;
            
            [_mainReasonView addSubview:titleLabel];
            _yPoint += 20.f + 10.f;
            
            NSAttributedString *content =
            [XKRWUtil createAttributeStringWithString:model.advise
                                                 font:XKDefaultNumEnFontWithSize(14.f)
                                                color:XK_TEXT_COLOR
                                          lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            CGRect rect = [content boundingRectWithSize:CGSizeMake(XKAppWidth - 30.f, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                context:nil];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth - 30.f, rect.size.height + 10.f)];
            contentLabel.attributedText = content;
            contentLabel.numberOfLines = 0.f;
            
            [_mainReasonView addSubview:contentLabel];
            _yPoint += contentLabel.height + 25.f;
            
        }
        _mainReasonHeightConstraint.constant = _yPoint;
    }
    
    /*
     *  心理因素
     */
    _yPoint = 43.f;
    if (_model.mindArray && _model.mindArray.count) {
        
        for (XKRWDescribeModel *model in _model.mindArray) {
            
            if (![model.result isEqualToString:@"无压力"]) {
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth - 30.f, 20.f)];
                titleLabel.textColor = [XKRWUtil getStatusColorWithFlag:(int)model.flag];
                titleLabel.font = XKDefaultFontWithSize(16.f);
                titleLabel.text = model.result;
                
                [_psychologicalFactorView addSubview:titleLabel];
                
                _yPoint += 20.f + 10.f;
            }
            
            if (model.advise.length) {
                
                NSAttributedString *advise = [XKRWUtil createAttributeStringWithString:model.advise font:XKDefaultNumEnFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];
                CGRect rect = [advise boundingRectWithSize:CGSizeMake(XKAppWidth - 30.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
          
                UILabel *adviseLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth - 30.f, rect.size.height + 10.f)];
                adviseLabel.attributedText = advise;
                adviseLabel.numberOfLines = 0.f;
                
                [_psychologicalFactorView addSubview:adviseLabel];
                _yPoint += adviseLabel.height + 25.f;
            }
        }
        
        _psychologicalFactorHeightConstraint.constant = _yPoint;
        
    } else {
        _psychologicalFactorHeightConstraint.constant = 0.f;
    }
    
    /*
     *  个人肥胖特点
     */
    _yPoint = 43.f;
    if (_model.characterModel) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth - 30.f, 20.f)];
        titleLabel.textColor = XKMainSchemeColor;
        titleLabel.font = XKDefaultFontWithSize(16.f);
        titleLabel.text = _model.characterModel.result;
        
        [_fatFeatureView addSubview:titleLabel];
        
        _yPoint += 20.f + 10.f;
        
        if (_model.characterModel.advise.length) {
            
            NSAttributedString *advise =
            [XKRWUtil createAttributeStringWithString:_model.characterModel.advise
                                                 font:XKDefaultNumEnFontWithSize(14.f)
                                                color:XK_TEXT_COLOR
                                          lineSpacing:3.5 alignment:NSTextAlignmentLeft];
            CGRect rect = [advise boundingRectWithSize:CGSizeMake(XKAppWidth - 30.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            UILabel *adviseLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth - 30.f, rect.size.height + 10.f)];
            
            adviseLabel.attributedText = advise;
            adviseLabel.numberOfLines = 0.f;
            
            [_fatFeatureView addSubview:adviseLabel];
            _yPoint += adviseLabel.height;
        }
        _fatFeatureHeightConstraint.constant = _yPoint + 25.f;
        
    } else {
        _fatFeatureHeightConstraint.constant = 0.f;
    }
    
    [self.view layoutIfNeeded];
}

- (void)initData {
    
    _model = _iSlimModel.otherFactorsModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
