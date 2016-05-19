//
//  XKRWStatisticAnalysisView.m
//  XKRW
//
//  Created by ss on 16/5/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//
#import "XKRWStatisticDetailView.h"
#import "Masonry.h"
#import "XKRWAlgolHelper.h"
#import "XKRWRecordService4_0.h"

@implementation XKRWStatisticDetailView

- (instancetype)initWithFrame:(CGRect)frame type:(AnalysizeType)type statisType:(StatisticType)statisType withBussiness:(XKRWStatiscBussiness5_3 *)bussiness
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _statisticType = statisType;
        _bussiness = bussiness;
        if (_statisticType == 1) {
            _dataDic = _bussiness.dicEntities;
            _currentIndex = _bussiness.totalNum - 1;
            
            _currentEntity = [_dataDic objectForKey:[NSNumber numberWithInteger:_currentIndex]];
        }else {
            _currentEntity = _bussiness.statiscEntity;
        }
        
        //每日正常饮食摄入
        _dailyNormal = [XKRWAlgolHelper dailyIntakEnergy];
        //饮食消耗
        _dailyFoodDecrease = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:efoodCalories andDate:[NSDate date]];
        //运动消耗
        _dailySportDecrease = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:eSportCalories andDate:[NSDate date]];
        [self makeViewAutoLayout];
    }
    return self;
}

-(XKRWStatiscEntity5_3 *)currentEntity{
    if (!_currentEntity) {
        if (_statisticType == 1) {
            _currentEntity = [_dataDic objectForKey:[NSNumber numberWithInteger:_currentIndex]];
        }else{
            _currentEntity = _bussiness.statiscEntity;
        }
    }
    return _currentEntity;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        _currentEntity = nil;
        [self makeViewAutoLayout];
    }
}

-(void)makeViewAutoLayout{
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(@25);
    }];
    
    [self.labCal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.equalTo(@25);
        make.top.mas_equalTo(self.labTitle.mas_bottom).offset(2);
    }];
    
    [self.labTarget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.labCal.mas_bottom);
    }];
    if (_statisticType == 2) {
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.left.equalTo(@32);
            make.width.mas_equalTo(XKAppWidth - 64);
            make.height.mas_greaterThanOrEqualTo(_imgView.mas_height);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.labCal.mas_bottom);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-37);
        }];
        
        if (_type == 1) {
            [self.labEatLeft1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_left).offset(21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(-8);
            }];
            [self.labEatLeft2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_left).offset(21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(15);
            }];
            [self.labEatRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_imgView.mas_right).offset(-21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(-8);
            }];
            [self.labEatRight2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_imgView.mas_right).offset(-21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(15);
            }];
        }else{
            [self.labSportLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_left).offset(21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(3);
            }];
            [self.labSportRight mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_imgView.mas_right).offset(-21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(3);
            }];
        }
    }else{
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.left.equalTo(@32);
            make.width.mas_equalTo(XKAppWidth - 64);
            make.height.mas_greaterThanOrEqualTo(_imgView.mas_height);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.labTarget.mas_bottom).offset(14);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-23);
        }];
        
        if (_type == 1) {
            [self.labEatLeft1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_left).offset(21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(-8);
            }];
            [self.labEatLeft2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_left).offset(21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(15);
            }];
            [self.labEatRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_imgView.mas_right).offset(-21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(-8);
            }];
            [self.labEatRight2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_imgView.mas_right).offset(-21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(15);
            }];
        }else{
            [self.labSportLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_left).offset(21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(3);
            }];
            [self.labSportRight mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_imgView.mas_right).offset(-21);
                make.centerY.mas_equalTo(_imgView.mas_centerY).offset(3);
            }];
        }
    }
}

#pragma mark getter Method
-(UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.textColor = colorSecondary_333333;
        _labTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:_labTitle];
    }
    _labTitle.text = _type == 1? @"饮食减少摄入总计" : @"运动消耗总计";
    return _labTitle;
}

-(UILabel *)labCal{
    if (!_labCal) {
        _labCal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        
        _labCal.textAlignment = NSTextAlignmentCenter;
        _labCal.textColor = XKMainToneColor_29ccb1;
        _labCal.font = [UIFont systemFontOfSize:27];
        [self addSubview:_labCal];
    }
    _labCal.text = _type == 1? [NSString stringWithFormat:@"%.0fkcal",self.currentEntity.decreaseIntake.floatValue]: [NSString stringWithFormat:@"%.0fkcal",self.currentEntity.decreaseSport.floatValue];
    if (_statisticType == 1) {
        if (_type == 1) {
            _labCal.textColor = self.currentEntity.isAchieveIntakeTarget?XKMainToneColor_29ccb1:XKWarningColor;
        }else{
            _labCal.textColor = self.currentEntity.isAchieveSportTarget?XKMainToneColor_29ccb1:XKWarningColor;
        }
    }
    return _labCal;
}

-(UILabel *)labTarget{
    if (!_labTarget) {
        _labTarget = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labTarget.font = [UIFont systemFontOfSize:12];
        _labTarget.textColor = colorSecondary_333333;
        _labTarget.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labTarget];
    }
    _labTarget.text = _type == 1? [NSString stringWithFormat:@"目标%.0fkcal",self.currentEntity.targetIntake.floatValue]: [NSString stringWithFormat:@"目标%.0fkcal",self.currentEntity.targetSport.floatValue];
    
    if (_statisticType == 2) {
        _labTarget.text = @"";
    }
    return _labTarget;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        
        NSString *imgName = @"";
        if (_type == 2) {
            if (XKAppWidth == 320) {
                imgName = @"date_indicator320_Small";
            }else{
                imgName = @"date_indicator_Small";
            }
        }else{
            if (XKAppWidth == 320) {
                imgName = @"date_indicator320_Big";
            }else{
                imgName = @"date_indicator_Big";
            }
        }
        UIImage *img = [UIImage imageNamed:imgName];
        _imgView = [[UIImageView alloc] initWithImage:img];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
//        _imgView.image = img;
        [self addSubview:_imgView];
    }
    return _imgView;
}

-(UILabel *)labEatLeft1{
    if (!_labEatLeft1) {
        _labEatLeft1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labEatLeft1.text = @"正常所需(不减肥时需摄入)";
        _labEatLeft1.textColor = colorSecondary_333333;
        _labEatLeft1.font = [UIFont systemFontOfSize:12];
        _labEatLeft1.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labEatLeft1];
    }
    return _labEatLeft1;
}

-(UILabel *)labEatLeft2{
    if (!_labEatLeft2) {
        _labEatLeft2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labEatLeft2.text = @"实际摄入";
        _labEatLeft2.textColor = colorSecondary_333333;
        _labEatLeft2.font = [UIFont systemFontOfSize:12];
        _labEatLeft2.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labEatLeft2];
    }
    return _labEatLeft2;
}

-(UILabel *)labEatRight1{
    if (!_labEatRight1) {
        _labEatRight1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labEatRight1.textColor = colorSecondary_333333;
        _labEatRight1.font = [UIFont systemFontOfSize:12];
        _labEatRight1.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labEatRight1];
    }
    _labEatRight1.text = [NSString stringWithFormat:@"%.0fkcal",self.currentEntity.normalIntake.floatValue];
    return _labEatRight1;
}

-(UILabel *)labEatRight2{
    if (!_labEatRight2) {
        _labEatRight2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labEatRight2.textColor = colorSecondary_333333;
        _labEatRight2.font = [UIFont systemFontOfSize:12];
        _labEatRight2.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labEatRight2];
    }
    _labEatRight2.text = [NSString stringWithFormat:@"%.0fkcal",self.currentEntity.actualIntake.floatValue];
    return _labEatRight2;
}

-(UILabel *)labSportLeft{
    if (!_labSportLeft) {
        _labSportLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labSportLeft.text = @"运动时长总计";
        _labSportLeft.textColor = colorSecondary_333333;
        _labSportLeft.font = [UIFont systemFontOfSize:12];
        _labSportLeft.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labSportLeft];
    }
    return _labSportLeft;
}

-(UILabel *)labSportRight{
    if (!_labSportRight) {
        _labSportRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _labSportRight.textColor = colorSecondary_333333;
        _labSportRight.font = [UIFont systemFontOfSize:12];
        _labSportRight.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labSportRight];
    }
    _labSportRight.text = [NSString stringWithFormat:@"%.0f分钟",self.currentEntity.timeSport.floatValue];
    return _labSportRight;
}
@end