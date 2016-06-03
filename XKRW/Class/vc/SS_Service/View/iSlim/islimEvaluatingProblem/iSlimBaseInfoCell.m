//
//  iSlimBaseInfoCell.m
//  XKRW
//
//  Created by XiKang on 15-1-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "iSlimBaseInfoCell.h"
#import "XKRWUserService.h"
#import "XKRWWeightService.h"
#import "DatePickerView.h"
#import "XKRWWeightService.h"
#import "XKRWRecordCircumferenceEntity.h"

@interface iSlimBaseInfoCell () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DatePickerViewDelegate>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation iSlimBaseInfoCell
{
    NSArray *_placeholder;
    void (^_setGender)(XKSex);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 1.f)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        /**
         *  TableView's footerView
         */
        NSString *attentionText = @"注：体脂率即身体脂肪含量百分比，可通过体脂仪、体脂称等设备进行测量，如无法测量可不填。";
        CGSize textSize = [XKRWUtil sizeOfStringWithFont:attentionText width:XKAppWidth - 45.f font:XKDefaultNumEnFontWithSize(14.f)];
        UILabel *attention = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 8.f, XKAppWidth - 45.f, textSize.height)];
        attention.text = attentionText;
        attention.textColor = XK_ASSIST_TEXT_COLOR;
        attention.font = XKDefaultNumEnFontWithSize(14.f);
        attention.numberOfLines = 0;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, attention.height + 56.f)];
        [footerView addSubview:attention];
        
        if ([[XKRWServerPageService sharedService] isShowPullUpImageView]) {
            _upDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake((XKAppWidth-36)/2, XKAppHeight - 20.f, 36, 20)];
            _upDownImageView.image = [UIImage imageNamed:@"upglide_"];
            [[UIApplication sharedApplication].keyWindow addSubview:_upDownImageView];
        }
        
        
        _tableView.tableFooterView = footerView;
        /**
         *  初始化数据
         */
        [self initData];
        [_tableView reloadData];
        _tableView.height = _tableView.contentSize.height;
        [self.contentView addSubview:_tableView];
        
        self.height = XKAppHeight;
        
        self.contenHeight = 44.f * 8 + footerView.height;
//        UIView *colorBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15.f, self.height)];
//        colorBanner.backgroundColor = [UIColor colorWithRed:255/255.f green:105/255.f blue:110/255.f alpha:.3f];
//        
//        [self addSubview:colorBanner];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initData {
    _titleArray = @[@"人群/职业", @"性别", @"出生", @"身高", @"体重", @"腰围（必填）", @"臀围（必填）", @"体脂率"];
    NSString *group = [[XKRWUserService sharedService] getUserGroupDescription];
    NSString *gendar = [[XKRWUserService sharedService] getSexDescription];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];

    formatter.dateFormat = @"yyyy年";
    NSString *birthday = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[XKRWUserService sharedService] getBirthday]]];
    
    NSString *height = [NSString stringWithFormat:@"%ldcm", (long)[[XKRWUserService sharedService] getUserHeight]];
    NSString *weight = [NSString stringWithFormat:@"%.1fkg", [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]];
    _dataSource = [NSMutableArray arrayWithObjects:group, gendar, birthday, height, weight, @"", @"", @"", nil];
    
    _placeholder = @[@"40~110cm", @"40~110cm", @"0~50%"];
}

#pragma mark - UITableView's delegate 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseInfoCellIdentifier"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"baseInfoCellIdentifier"];
        cell.height = 44.f;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
//        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, XKAppWidth, 0.5)];
//        topLine.backgroundColor = XK_ASSIST_LINE_COLOR;
//        [cell addSubview:topLine];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, cell.height - 0.5, XKAppWidth, 0.5)];
        bottomLine.backgroundColor = XK_ASSIST_LINE_COLOR;
        [cell addSubview:bottomLine];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38.f, 0.f, 120.f, 44.f)];
    [titleLabel setFont:XKDefaultFontWithSize(16.f)];
    titleLabel.textColor = XK_TITLE_COLOR;
    titleLabel.text = _titleArray[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
        UIImage *arrowImage = [UIImage imageNamed:@"arrow_right5_3"];
    
        UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImage];
        arrow.topRight = CGPointMake(XKAppWidth -15, (44 - arrowImage.size.height)/2 );
        
        [cell.contentView addSubview:arrow];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 44.f)];
        detail.right = arrow.left - 10;
        [detail setFont:XKDefaultNumEnFontWithSize(16.f)];
        detail.textColor = XKMainSchemeColor;
        
        detail.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:detail];
        
    if (indexPath.row < 5) {
        detail.text = _dataSource[indexPath.row];
    } else {
        NSString *text = _dataSource[indexPath.row];
        if ([text isEqualToString:@""]) {
            detail.text = _placeholder[indexPath.row - 5];
            detail.textColor = XK_ASSIST_TEXT_COLOR;
        } else {
            detail.text = text;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            NSArray *group = @[@"学生", @"白班族", @"夜班族", @"自由职业", @"产后女性", @"其他"];
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            [picker initSubviewsWithStyle:DatePickerStyleSinglePicker
                            andDatasource:group
                                   andObj:_dataSource[indexPath.row]];
            picker.delegate   = self;
            picker.identifier = @"人群/职业";
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 1: {
            NSArray *group = @[@"男", @"女"];
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            [picker initSubviewsWithStyle:DatePickerStyleSinglePicker
                            andDatasource:group
                                   andObj:_dataSource[indexPath.row]];
            picker.delegate   = self;
            picker.identifier = @"性别";
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 2: {
            NSDate *date = [NSDate date];
            int dateNum = [[date stringWithFormat:@"yyyy"] intValue];;
            
            NSMutableArray *group = [NSMutableArray array];
            for (int i = dateNum - 70; i < dateNum - 12; i ++) {
                [group addObject:[NSString stringWithFormat:@"%d年", i]];
            }
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            [picker initSubviewsWithStyle:DatePickerStyleSinglePicker
                            andDatasource:group
                                   andObj:_dataSource[indexPath.row]];
            picker.delegate   = self;
            picker.identifier = @"出生";
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 3: {
            NSMutableArray *group = [NSMutableArray array];
            for (int i = 140; i <= 220; i ++) {
                [group addObject:[NSString stringWithFormat:@"%dcm", i]];
            }
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            [picker initSubviewsWithStyle:DatePickerStyleSinglePicker
                            andDatasource:group
                                   andObj:_dataSource[indexPath.row]];
            picker.delegate   = self;
            picker.identifier = @"身高";
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 4: {

            NSString *str = [_dataSource[indexPath.row] componentsSeparatedByString:@"kg"][0];
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            [picker initSubviewsWithStyle:DatePickerStyleWeightReocrd andObj:str];
            picker.delegate   = self;
            picker.identifier = @"体重";
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 5: {
            XKRWRecordCircumferenceEntity *entity = [[XKRWRecordCircumferenceEntity alloc] init];
            NSString *waistline = _dataSource[indexPath.row];
            if ([waistline isEqualToString:@""]) {
                entity.waistline = 0;
            } else {
                NSArray *array = [waistline componentsSeparatedByString:@"cm"];
                entity.waistline = [array[0] floatValue] * 10;
            }
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            picker.identifier = @"腰围";
            [picker initSubviewsWithStyle:DatePickerStyleCircumferenceRecord andObj:entity];
            picker.delegate   = self;
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 6: {
            XKRWRecordCircumferenceEntity *entity = [[XKRWRecordCircumferenceEntity alloc] init];
            NSString *hipline = _dataSource[indexPath.row];
            if ([hipline isEqualToString:@""]) {
                entity.hipline = 0;
            } else {
                NSArray *array = [hipline componentsSeparatedByString:@"cm"];
                entity.hipline = [array[0] floatValue] * 10;
            }
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            picker.identifier = @"臀围";
            [picker initSubviewsWithStyle:DatePickerStyleCircumferenceRecord andObj:entity];
            picker.delegate   = self;
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        case 7: {
            NSMutableArray *group = [NSMutableArray array];
            [group addObject:@"我不清楚"];
            
            for (int i = 1; i <= 50; i ++) {
                [group addObject:[NSString stringWithFormat:@"%d%%", i]];
            }
            
            DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
            [picker initSubviewsWithStyle:DatePickerStyleSinglePicker
                            andDatasource:group
                                   andObj:_dataSource[indexPath.row]];
            picker.delegate   = self;
            picker.identifier = @"体脂率";
            picker.tag = indexPath.row;
            
            [picker addToWindow];
        }
            break;
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - DatePicker's Delegate

- (void)clickConfirmButton:(DatePickerView *)picker postSelected:(NSString *)string {
    
    if ([picker.identifier isEqualToString:@"腰围"] ||
        [picker.identifier isEqualToString:@"臀围"]) {
        
        _dataSource[picker.tag] = [NSString stringWithFormat:@"%@cm", string];
    } else if ([picker.identifier isEqualToString:@"体重"]) {
        
        _dataSource[picker.tag] = [NSString stringWithFormat:@"%@kg", string];
    } else {
        _dataSource[picker.tag] = string;
    }
    [_tableView reloadData];
}

- (void)clickCancelButton:(DatePickerView *)picker {
    
}

#pragma mark - 重写父类方法

- (void)saveAnswer {
    NSMutableDictionary *answer = [NSMutableDictionary dictionary];
    
    [answer setValue:_dataSource[0] forKey:@"occupation"];
    
    XKSex gendar;
    if ([_dataSource[1] isEqualToString:@"男"]) {
        gendar = eSexMale;
    } else {
        gendar = eSexFemale;
    }
    
    if (_setGender) {
        _setGender(gendar);
    }
    [answer setValue:[NSNumber numberWithInt:gendar] forKey:@"gender"];
    
    int year = [[_dataSource[2] componentsSeparatedByString:@"年"][0] intValue];
    [answer setValue:[NSNumber numberWithInt:year] forKey:@"birthday"];
    
    int stature = [[_dataSource[3] componentsSeparatedByString:@"cm"][0] intValue];
    [answer setValue:[NSNumber numberWithInt:stature] forKey:@"stature"];
    
    float weight = [[_dataSource[4] componentsSeparatedByString:@"kg"][0] floatValue];
    [answer setValue:[NSNumber numberWithFloat:weight] forKey:@"weight"];
    
    float waist = [[_dataSource[5] componentsSeparatedByString:@"cm"][0] floatValue];
    [answer setValue:[NSNumber numberWithFloat:waist] forKey:@"waist"];
    
    float hipline = [[_dataSource[6] componentsSeparatedByString:@"cm"][0] floatValue];
    [answer setValue:[NSNumber numberWithFloat:hipline] forKey:@"hipline"];
    
    if (![_dataSource[7] isEqualToString:@"我不清楚"]) {
        
        [answer setValue:_dataSource[7] forKey:@"bodyFatPercentage"];
    } else {
        [answer setValue:@"" forKey:@"bodyFatPercentage"];
    }
    
    self.answer = answer;
    
    [super saveAnswer];
    
    if (_upDownImageView.superview) {
        [_upDownImageView removeFromSuperview];
    }
}

- (BOOL)checkComplete {
    
    for (int i = 4; i < 7; i ++) {
        if ([_dataSource[i] isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Other functions

- (void)setEvaluateGender:(void (^)(XKSex))gender {
    
    _setGender = gender;
}
@end
