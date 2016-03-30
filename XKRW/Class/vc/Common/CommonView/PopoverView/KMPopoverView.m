//
//  KMPopoverView.m
//  XKRW
//
//  Created by XiKang on 15-4-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "KMPopoverView.h"

@interface KMPopoverView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *upArrow;

@end

@implementation KMPopoverView {
 
    NSArray *_titles;
    NSArray *_images;
    
    KMPopoverCellType _cellType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
               arrowDirection:(KMDirection)direction
                positionratio:(CGFloat)ratio
                 withCellType:(KMPopoverCellType)type
                    andTitles:(NSArray *)titles
                       images:(NSArray *)images {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = XKMainSchemeColor;
        self.tableView.scrollEnabled = NO;
        
        self.tableView.tableFooterView = [[UIView alloc] init];
        
        [self addSubview:self.tableView];
        
        _upArrow = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * ratio, -6.5, 11.f, 6.5)];
        _upArrow.image = [UIImage imageNamed:@"up_arrow"];
        [self addSubview:_upArrow];
        
        _cellType = type;
        
        _titles = titles;
        _images = images;
        
        self.height = _titles.count * 44.f;
        _tableView.height = self.height - 1;
        
        [self.tableView reloadData];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    self.tableView.backgroundColor = backgroundColor;
}

- (void)setSeparatorColor:(UIColor *)color {
    self.tableView.separatorColor = color;
}

#pragma mark - UITableView's delegate & datasource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popoverCell"];
    if (!cell) {
        cell = [[KMPopoverCell alloc] initWithType:_cellType width:self.width reuseIdentifier:@"popoverCell"];
    }
    [cell setTitle:_titles[indexPath.row]];
    if (_cellType == KMPopoverCellTypeImageAndText) {

        [cell setheadImage:_images[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KMPopoverView:clickButtonAtIndex:)]) {
        [self.delegate KMPopoverView:self clickButtonAtIndex:indexPath.row];
    }
    [self hideButton:nil];
}

#pragma mark - Initialization

#pragma mark - Other functions

- (void)addToWindow {
    
}

- (void)addUnderOfNavigationBarRightItem:(UIViewController *)vc {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGFloat navigationBarHeight = vc.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat screenWidth = keyWindow.frame.size.width;
    
    CGRect rect = self.frame;
    rect.origin = CGPointMake(screenWidth - rect.size.width - 8.f, 7.5 + statusBarHeight + navigationBarHeight);
    self.frame = rect;
    
    [self addTransparentButton];
    
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0.1;
    
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addTransparentButton {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIButton *button = [[UIButton alloc] initWithFrame:keyWindow.bounds];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1010203;
    
    [keyWindow addSubview:button];
}

- (void)hideButton:(id)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        [button removeFromSuperview];
        
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 0.001;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    } else {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIButton *button = (UIButton *)[keyWindow viewWithTag:1010203];
        [button removeFromSuperview];
        
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 0.001;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
