//
//  XKRWExcerciseAssResultVC.m
//  XKRW
//
//  Created by XiKang on 15-1-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWExcerciseAssResultVC.h"

@interface XKRWExcerciseAssResultVC ()
@property (weak, nonatomic) IBOutlet UILabel *sportType;

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *hlLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;

@property (weak, nonatomic) IBOutlet UILabel *frequencyDesc;
@property (weak, nonatomic) IBOutlet UILabel *timeDesc;
@property (weak, nonatomic) IBOutlet UILabel *intensityDesc;
@property (weak, nonatomic) IBOutlet UILabel *typeDesc;

@property (weak, nonatomic) IBOutlet UILabel *sportProblemTitle;
@property (weak, nonatomic) IBOutlet UILabel *fatProblemTitle;
@property (weak, nonatomic) IBOutlet UILabel *powerProblemTitle;
@property (weak, nonatomic) IBOutlet UILabel *hlProblemTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sportProblemWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatProblemWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hlProblemWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerProblemWidth;

@property (weak, nonatomic) IBOutlet UILabel *sportProblemDes;
@property (weak, nonatomic) IBOutlet UILabel *fatProblemDes;
@property (weak, nonatomic) IBOutlet UILabel *powerProblemDes;
@property (weak, nonatomic) IBOutlet UILabel *hlProblemDes;

@property (weak, nonatomic) IBOutlet UIView *sportRecommendView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sportRecommendViewHeightConstraint;
@end

@implementation XKRWExcerciseAssResultVC
{
    XKRWIslimSportModel *_model;
}

#pragma mark - System's functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /**
     *  初始化数据
     */
    [self initData];
    /**
     *  初始化视图
     */
    [self initSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize

- (void)initSubviews {
    
    self.title = @"运动情况";
    [self addNaviBarBackButton];
    /*
     *  图片注释文字
     */
    NSArray *titleArray = [_model.resultModel getDescriptionInTitle];
    _powerLabel.text = titleArray[0];
    _powerLabel.textColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.pFlag];
    
    _sportLabel.text = titleArray[1];
    _sportLabel.textColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.stFlag];
    
    _hlLabel.text = titleArray[2];
    _hlLabel.textColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.hlFlag];
    
    _fatLabel.text = titleArray[3];
    _fatLabel.textColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.fpFlag];
    
    /*
     *  运动问题
     */
    _powerProblemTitle.text = _model.resultModel.power;
    CGSize size = [XKRWUtil sizeOfStringWithFont:_model.resultModel.power
                                           width:XKAppWidth
                                            font:XKDefaultFontWithSize(14.f)];
    _powerProblemTitle.backgroundColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.pFlag];
    _powerProblemWidth.constant = size.width + 20;
    
    _sportProblemTitle.text = _model.resultModel.status;
    _sportProblemTitle.backgroundColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.stFlag];
    size = [XKRWUtil sizeOfStringWithFont:_model.resultModel.status
                                    width:XKAppWidth
                                     font:XKDefaultFontWithSize(14.f)];
    _sportProblemWidth.constant = size.width + 20;
    
    _hlProblemTitle.text = _model.resultModel.heart_lung;
    _hlProblemTitle.backgroundColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.hlFlag];
    size = [XKRWUtil sizeOfStringWithFont:_model.resultModel.heart_lung
                                    width:XKAppWidth
                                     font:XKDefaultFontWithSize(14.f)];
    _hlProblemWidth.constant = size.width + 20;
    
    _fatProblemTitle.text = _model.resultModel.fp;
    _fatProblemTitle.backgroundColor = [XKRWUtil getStatusColorWithFlag:_model.resultModel.fpFlag];
    size = [XKRWUtil sizeOfStringWithFont:_model.resultModel.fp
                                    width:XKAppWidth
                                     font:XKDefaultFontWithSize(14.f)];
    _fatProblemWidth.constant = size.width + 20;
    
    CGFloat height = _powerProblemTitle.height / 2;
    _powerProblemTitle.layer.cornerRadius = height;
    _powerProblemTitle.layer.masksToBounds = YES;
    
    _sportProblemTitle.layer.cornerRadius = height;
    _sportProblemTitle.layer.masksToBounds = YES;

    _hlProblemTitle.layer.cornerRadius = height;
    _hlProblemTitle.layer.masksToBounds = YES;

    _fatProblemTitle.layer.cornerRadius = height;
    _fatProblemTitle.layer.masksToBounds = YES;
    
    NSArray *desLabelArray = @[_powerProblemDes, _sportProblemDes, _hlProblemDes, _fatProblemDes];
    NSArray *desTextArray = @[_model.resultModel.pDes, _model.resultModel.stDes, _model.resultModel.hlDes, _model.resultModel.fpDes];
    
    NSInteger index = 0;
    for (NSString *text in desTextArray) {
        UILabel *label = desLabelArray[index++];
        
        NSAttributedString *attributeString =
        [XKRWUtil createAttributeStringWithString:text
                                             font:XKDefaultNumEnFontWithSize(14.f)
                                            color:XK_TEXT_COLOR
                                      lineSpacing:3.5 alignment:NSTextAlignmentLeft];
        label.attributedText = attributeString;
    }
    
    /*
     *  运动原则
     */
    _frequencyDesc.text = _model.regulateModel.period;
    _timeDesc.text = _model.regulateModel.time;
    _intensityDesc.text = _model.regulateModel.level;
    _typeDesc.text = _model.regulateModel.type;
    
    /*
     *  运动推荐
     */
    CGFloat _yPoint = 60.f;
    
    for (XKRWSportIntroductionModel *model in _model.introductionArray) {
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, 80.f, 20.f)];
        title.text = model.name;
        title.font = XKDefaultNumEnFontWithSize(16.f);
        title.textColor = XK_TEXT_COLOR;
        
        [_sportRecommendView addSubview:title];
        
        NSString *contentString = [model getSportRecommendString];
        CGSize size = [XKRWUtil sizeOfStringWithFont:contentString
                                               width:XKAppWidth - 100 - 15
                                                font:XKDefaultNumEnFontWithSize(16.f)];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(100.f, _yPoint, XKAppWidth - 100 - 15, size.height)];
        content.text = contentString;
        content.font = XKDefaultNumEnFontWithSize(16.f);
        content.textColor = XKMainSchemeColor;
        content.numberOfLines = 0.f;

        [_sportRecommendView addSubview:content];
        
        _yPoint += size.height + 20.f;
    }
    
    _sportRecommendViewHeightConstraint.constant = _yPoint;
    
    /*
     *  运动建议
     */
    _yPoint = 55.f;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.5;
    
    NSDictionary *attributes =
  @{NSFontAttributeName: XKDefaultNumEnFontWithSize(14.f),
    NSParagraphStyleAttributeName: style,
    NSForegroundColorAttributeName: XK_TEXT_COLOR};
    
    for (NSString *text in [_model.adviseModel getAdviseArray]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
        
        CGRect rect = [string boundingRectWithSize:CGSizeMake(XKAppWidth - 30.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, _yPoint, XKAppWidth - 30.f, rect.size.height + 10.f)];
        label.attributedText = string;
        label.numberOfLines = 0;
        
        [_sportAdviseView addSubview:label];
        _yPoint += label.height + 15.f;
    }
    _sportAdviseViewHeightConstraint.constant = _yPoint;
}

- (void)initData {
    _model = _iSlimModel.sportmodel;
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
