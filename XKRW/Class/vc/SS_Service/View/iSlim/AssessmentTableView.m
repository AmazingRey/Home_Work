//
//  AssessmentTableView.m
//  XKRW
//
//  Created by XiKang on 15-1-22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "AssessmentTableView.h"

@interface AssessmentTableView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) XKRWiSlimBaseCell *cell;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) UIView            *header;

@property (nonatomic, strong) UIImageView       *headArrow;
@property (nonatomic, strong) UIImageView       *footArrow;

@property (nonatomic, strong) UIView            *footerView;
@property (nonatomic, strong) UITextField       *textField;

@property (nonatomic, strong) NSArray           *colorArray;
@property (nonatomic, assign) CGFloat           originalYPoint;

@end

@implementation AssessmentTableView
{
    UILabel *_headLabel;
    UILabel *_footLabel;
    
    void(^_prior)(void);
    void(^_next)(void);
    
    BOOL _headArrowIsRotate;
    BOOL _footArrowIsRotate;
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                   customCell:(XKRWiSlimBaseCell *)cell
                        title:(NSString *)title {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;

        _cell = cell;
        _title = title;
        _originalYPoint = frame.origin.y;
        
        _colorArray = @[HEXCOLOR(@"#ff6b6b"), HEXCOLOR(@"#29ccb1"), HEXCOLOR(@"#83cc52"), HEXCOLOR(@"3ff884c")];
        
        [self initSubviews];
        
        _headArrowIsRotate = NO;
        _footArrowIsRotate = NO;
        
    }
    return self;
}

- (void)setGotoPriorQuestion:(void (^)(void))prior nextQuestion:(void (^)(void))next {
    _prior = prior;
    _next = next;
}

- (void)setCustomCell:(XKRWiSlimBaseCell *)cell title:(NSString *)title {
    _cell = cell;
    _title = title;
    
    _cell.page = _currentPageIndex;
    
    [self loadHeader];
    [self loadCell];
    [self reloadData];
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor whiteColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadHeader];
    [self loadCell];
}

- (void)loadHeader {
    
    if (!_header) {
        _header = [[UIView alloc] init];
        _header.backgroundColor = [UIColor whiteColor];
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(8.f, 12, 20, 20)];
        number.tag = 1;
        
        number.layer.cornerRadius = 9.9;
        number.layer.masksToBounds = YES;
        
        number.font = XKDefaultRudeFontWithSize(14.f);
        number.textAlignment = NSTextAlignmentCenter;
        
        number.textColor = [UIColor whiteColor];
        number.backgroundColor = XKMainSchemeColor;
        number.text = [NSString stringWithFormat:@"%ld", (long)_currentPageIndex + 1];
        
        [_header addSubview:number];
        
        UIFont *font = XKDefaultNumEnFontWithSize(16.f);
        
        CGSize size = [XKRWUtil sizeOfStringWithFont:_title width:XKAppWidth - 51.f font:font];
        
        UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(number.right + 8.f, 11.f, size.width, size.height)];
        question.tag = 2;
        
        question.text = _title;
        [question setFont:font];
        [question setTextColor:XKMainSchemeColor];
        question.numberOfLines = 0;
        
        _header.frame = CGRectMake(0, 0, XKAppWidth, 22.f + size.height);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
        line.tag = 3;
        
        line.backgroundColor = XK_ASSIST_LINE_COLOR;
        [_header addSubview:line];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, _header.height - 0.5, XKAppWidth, 0.5)];
        line.tag = 4;
        
        line.backgroundColor = XK_ASSIST_LINE_COLOR;
        [_header addSubview:line];
        
        [_header addSubview:question];
        
        [number setY:(_header.height - 20) / 2];
    } else {

        UILabel *number = (UILabel *)[_header viewWithTag:1];
        number.text = [NSString stringWithFormat:@"%ld", (long)_currentPageIndex + 1];
        
        UILabel *question = (UILabel *)[_header viewWithTag:2];
        question.text = _title;
        UIFont *font = XKDefaultNumEnFontWithSize(16.f);
        CGSize size = [XKRWUtil sizeOfStringWithFont:_title width:XKAppWidth - 51.f font:font];
        
        question.frame = CGRectMake(number.right + 8.f, 11.f, size.width, size.height);
        _header.frame = CGRectMake(0, 0, XKAppWidth, 22.f + size.height);
        
        UIView *line = (UIView *)[_header viewWithTag:4];
        [line setBottom:_header.height];
        [number setY:(_header.height - 20) / 2];
    }
}

- (void)loadCell {
    
    if (!_headLabel) {
        
        NSString *headString = @"回到上一题";
        CGSize size = [XKRWUtil sizeOfStringWithFont:headString width:XKAppWidth font:XKDefaultFontWithSize(16.f)];
        
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake((XKAppWidth - size.width) / 2 + 15.f, -44.f, size.width, 44.f)];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        
        _headLabel.font = XKDefaultFontWithSize(16.f);
        _headLabel.textColor = XK_ASSIST_LINE_COLOR;
        _headLabel.backgroundColor = [UIColor clearColor];
        _headLabel.text = headString;
        
        [self insertSubview:_headLabel atIndex:0];
        
        _headArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        _headArrow.size = CGSizeMake(20, 20);
        
        _headArrow.topRight = CGPointMake(_headLabel.left - 10, _headLabel.top + 12.f);
        [self insertSubview:_headArrow atIndex:1];
        
    }
    if (_cell.contenHeight < self.height - _header.height) {
        _cell.height = self.height - _header.height;
    } else {
        _cell.height = _cell.contenHeight;
    }
    
    if (!_footLabel) {
        
        NSString *footString = @"进入下一题";
        CGSize size = [XKRWUtil sizeOfStringWithFont:footString width:XKAppWidth font:XKDefaultFontWithSize(16.f)];
        
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake((XKAppWidth - size.width) / 2 + 15.f, _cell.height + _header.height, size.width, 44.f)];
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.font = XKDefaultFontWithSize(16.f);
        
        _footLabel.textColor = XK_ASSIST_LINE_COLOR;
        _footLabel.backgroundColor = [UIColor clearColor];
        _footLabel.text = footString;
        
        [self insertSubview:_footLabel atIndex:0];
        
        _footArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up"]];
        _footArrow.topRight = CGPointMake(_footLabel.left - 10, _footLabel.top + 12.f);
        _footArrow.size = CGSizeMake(20.f, 20.f);
        
        [self insertSubview:_footArrow atIndex:0];
        
    } else {
        
        [_footLabel setY:_cell.height + _header.height];
        _footArrow.topRight = CGPointMake(_footLabel.left - 10, _footLabel.top + 12.f);
    }
}

#pragma mark - Delegate of UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _header.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cell.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return _header;
}

#pragma mark - Delegate of UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat height = 0.f;
    if (self.tableFooterView != nil) {
        height = _cell.height - self.height + _header.height + _footerView.height;
    } else {
        height = _cell.height - self.height + _header.height;
    }
    if (scrollView.contentOffset.y - height > 60.f) {
        if (!_footArrowIsRotate) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                _footArrow.transform = CGAffineTransformMakeRotation(3.14);
            } completion:^(BOOL finished) {
                
                _footArrowIsRotate = YES;
            }];
            return;
        }
    } else if (scrollView.contentOffset.y - height <= 60.f && scrollView.contentOffset.y - height > 0.f) {
        if (_footArrowIsRotate) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                _footArrow.transform = CGAffineTransformMakeRotation(0.f);
            } completion:^(BOOL finished) {
                
                _footArrowIsRotate = NO;
            }];
            return;
        }
    } else if (scrollView.contentOffset.y <= -60.f) {
        
        if (!_headArrowIsRotate) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                _headArrow.transform = CGAffineTransformMakeRotation(3.14);
            } completion:^(BOOL finished) {
                
                _headArrowIsRotate = YES;
            }];
            return;
        }
    } else if (scrollView.contentOffset.y > -60.f && scrollView.contentOffset.y <= 0.f) {
        
        if (_headArrowIsRotate) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                _headArrow.transform = CGAffineTransformMakeRotation(0.f);
            } completion:^(BOOL finished) {
                
                _headArrowIsRotate = NO;
            }];
            return;
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView.contentOffset.y <= -60.f) {

        if (_prior) {
            _prior();
        }
        return;
    }
    CGFloat height = 0.f;
    if (self.tableFooterView != nil) {
        height = _cell.height - self.height + _header.height + _footerView.height;
    } else {
        height = _cell.height - self.height + _header.height;
    }
    if (scrollView.contentOffset.y - height > 60.f) {

        if (_next) {
            _next();
        }
        return;
    }
}

#pragma mark - UITextField's Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Other function's

- (CGFloat)getViewHeight:(UIView *)view {
    CGFloat height = 0.f;
    [view layoutIfNeeded];
    [view updateConstraintsIfNeeded];
    
    height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    _currentPageIndex = currentPageIndex;
    
    UILabel *num = (UILabel *)[_header viewWithTag:1];
    
    if (_currentPageIndex < 1) {
        num.backgroundColor = _colorArray[0];
    } else if (_currentPageIndex < 6) {
        num.backgroundColor = _colorArray[1];
    } else if (_currentPageIndex < 11) {
        num.backgroundColor = _colorArray[2];
    } else {
        num.backgroundColor = _colorArray[3];
    }
    
    if (!_currentPageIndex) {
        [_headLabel setHidden:YES];
        _headArrow.hidden = YES;
    } else {
        [_headLabel setHidden:NO];
        _headArrow.hidden = NO;
    }
    if (_currentPageIndex == 25) {
        [_footLabel setHidden:YES];
        _footArrow.hidden = YES;
        
        [self addFooterView];
    } else {
        [_footLabel setHidden:NO];
        _footArrow.hidden = NO;
        
        self.tableFooterView = nil;
    }
}

- (void)addFooterView {
    
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 150)];
        
        NSString *content = @"请留下你的联系方式，我们会针对个人情况给予更多的帮助。（必填）";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
        NSDictionary *attributtes = @{NSFontAttributeName : XKDefaultRegFontWithSize(16.f),
                                      NSForegroundColorAttributeName: [UIColor redColor]};
        NSRange range = NSMakeRange(string.length - 4, 4);
        [string setAttributes:attributtes range:range];
        
        range = NSMakeRange(0, string.length - 4);
        attributtes = @{NSFontAttributeName : XKDefaultRegFontWithSize(16.f),
                          NSForegroundColorAttributeName: XK_ASSIST_TEXT_COLOR};
        [string setAttributes:attributtes range:range];
        
        CGRect rect = [string boundingRectWithSize:CGSizeMake(XKAppWidth - 60, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 15.f, XKAppWidth - 60.f, rect.size.height)];
        [stateLabel setAttributedText:string];
        stateLabel.numberOfLines = 0;
        [_footerView addSubview:stateLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(35.f, stateLabel.bottom + 10.f, XKAppWidth - 70.f, 30)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"联系方式：手机号/邮箱";
        _textField.returnKeyType = UIReturnKeyDone;
        
        [_textField setFont:XKDefaultNumEnFontWithSize(16.f)];
        _textField.adjustsFontSizeToFitWidth = YES;
        _textField.delegate = self;
        
        [_footerView addSubview:_textField];
        
        UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth/2 - 35, _textField.bottom + 10.f, 70, 26)];
        [confirm setTitle:@"查看报告" forState:UIControlStateNormal];
        [confirm setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:14];
        confirm.layer.cornerRadius = 3.f;
        confirm.backgroundColor = [UIColor whiteColor];
        confirm.layer.borderWidth = 1;
        confirm.layer.borderColor = XKMainSchemeColor.CGColor;
        [confirm setBackgroundImage:[UIImage createImageWithColor:XKMainSchemeColor] forState:UIControlStateHighlighted];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [confirm addTarget:self action:@selector(clickFooterViewButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:confirm];
        
        _footerView.height = confirm.bottom + 35.f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    _footerView.backgroundColor = [UIColor whiteColor];
    self.tableFooterView = _footerView;
}

- (void)clickFooterViewButton {
    
    if ([_cell checkComplete] && ![_textField.text isEqualToString:@""]) {
        [_cell saveAnswer];
        [[XKRWServerPageService sharedService] saveAnswer:_textField.text step:26];
    } else {
        [XKRWCui showInformationHudWithText:@"请填写完整"];
        return;
    }
    if (self.AssessmentDelegate && [self.AssessmentDelegate respondsToSelector:@selector(AssessmentTableView:clickFooterViewButton:)]) {
        [self.AssessmentDelegate AssessmentTableView:self clickFooterViewButton:nil];
    }
}

- (BOOL)disappearToDirection:(XKDirection)direction {
    CGFloat destinyY = 0.f;
    BOOL flag = YES;
    
    if (direction == XKDirectionUp) {
        /*
         *  判断当前题目判断是否完成
         */
        if ([_cell checkComplete]) {
            /*
             *  保存后，跳到下一题
             */
            destinyY = -self.height;
            [_cell saveAnswer];
        } else {
            [XKRWCui showInformationHudWithText:@"请完成当前题目"];
            flag = NO;
        }
        
    } else if (direction == XKDirectionDown) {
        if (_currentPageIndex > 0) {
            destinyY = XKAppHeight;
        } else {
            [XKRWCui showInformationHudWithText:@"已经是第一题了"];
            flag = NO;
        }
    }
    if (flag) {
        
        [UIView animateWithDuration:0.25f animations:^{
            [self setY:destinyY];
        } completion:^(BOOL finished) {
            [self setContentOffset:CGPointMake(0, 0)];
        }];
        _isShow = NO;
    }
    return flag;
}

- (void)appearFromDirection:(XKDirection)direction {
    if (direction == XKDirectionUp) {
        [self setY:-self.height];
    } else {
        [self setY:self.height];
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self setY:_originalYPoint];
    }];
    _isShow = YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (!keyboardHeight) {
        keyboardHeight = 252.f;
    }
    [self setContentOffset:CGPointMake(0, self.contentSize.height - self.height + _header.height + keyboardHeight) animated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
