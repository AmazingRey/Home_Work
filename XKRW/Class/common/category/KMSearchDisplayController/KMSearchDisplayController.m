//
//  KMSearchDisplayController.m
//  XKRW
//
//  Created by Klein Mioke on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "KMSearchDisplayController.h"

@interface KMSearchDisplayController ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITextField *textfield;

@property (nonatomic, weak) UIViewController *contentsController;
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, weak) UIView *searchBarSuperview;

@property (nonatomic) BOOL needHideTabbar;

@end

@implementation KMSearchDisplayController


- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
    
    if (self = [super init]) {
        self.searchBar = searchBar;
        self.contentsController = viewController;
        
        self.navigationController = viewController.navigationController;
        
        if (self.searchBar.frame.size.width == 0) {
            
            CGPoint origin = self.searchBar.frame.origin;
            self.searchBar.frame = CGRectMake(origin.x, origin.y, XKAppWidth, 44.f);
        }
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, XKAppWidth, XKAppHeight - 64)];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        self.backgroundContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)];
        self.backgroundContentView.backgroundColor = [UIColor clearColor];
        
        self.searchResultTableView = [[UITableView alloc] initWithFrame:self.backgroundView.bounds
                                                                  style:UITableViewStylePlain];
        self.searchResultTableView.backgroundColor = [UIColor clearColor];
        self.searchResultTableView.tableFooterView = [UIView new];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearchResultView)];
        
        if (IOS_8_OR_LATER) {
            UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            blurView.frame = CGRectMake(0, 0, XKAppWidth, self.backgroundView.height);
            [self.backgroundView addSubview:blurView];
            
            [blurView addGestureRecognizer:gesture];
            
        } else {
            UIView *transationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, self.backgroundView.height)];
            transationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            [transationView addGestureRecognizer:gesture];
            
            [self.backgroundView addSubview:transationView];
        }
        [self.backgroundContentView addGestureRecognizer:gesture];
        [self.backgroundView addSubview:self.backgroundContentView];
    }
    return self;
}

- (void)showSearchResultView {
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
 //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self.contentsController.view addSubview:self.backgroundView];
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    if (self.navigationController ) {
 
        if (!self.navigationController.tabBarController.tabBar.isHidden) {
            self.needHideTabbar = YES;
            self.navigationController.tabBarController.tabBar.hidden = YES;
                        
            self.contentsController.view.height += 49;
        }
    }
    
    UIView *superview = self.searchBar.superview;
    
    while (superview) {
        if ([superview isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)superview).scrollEnabled = NO;
        }
        superview = superview.superview;
    }
}

- (void)hideSearchResultView {
    
    // TODO: check this
 //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self hideSearchResultTableView];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
        self.backgroundView.alpha = 1;
    }];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    if (self.navigationController) {
        if (self.needHideTabbar) {
            self.navigationController.tabBarController.tabBar.hidden = NO;
            self.needHideTabbar = NO;
            self.contentsController.view.height -= 49;
        }
        
    }
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    
    UIView *superview = self.searchBar.superview;
    
    while (superview) {
        if ([superview isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)superview).scrollEnabled = YES;
        }
        superview = superview.superview;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(KMSearchDisplayHideSearchResult)]) {
        [_delegate KMSearchDisplayHideSearchResult];
    }
}

- (void)showSearchResultTableView {
    
    [self.backgroundView addSubview:self.searchResultTableView];
    self.isShowSearchResultTableView = YES;
    self.backgroundContentView.hidden = YES;
}

- (void)hideSearchResultTableView {
    
    [self.searchResultTableView removeFromSuperview];
    self.isShowSearchResultTableView = NO;
    self.backgroundContentView.hidden = NO;
}

- (void)reloadSearchResultTableView {
    [self.searchResultTableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"text"]) {
        
    }
}

- (void)setSearchResultDataSource:(id<UITableViewDataSource>)searchResultDataSource {
    
    _searchResultDataSource = searchResultDataSource;
    self.searchResultTableView.dataSource = searchResultDataSource;
}

- (void)setSearchResultDelegate:(id<UITableViewDelegate>)searchResultDelegate {
    _searchResultDelegate = searchResultDelegate;\
    self.searchResultTableView.delegate = searchResultDelegate;
}
@end
