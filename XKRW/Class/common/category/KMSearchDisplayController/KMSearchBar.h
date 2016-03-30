//
//  KMSearchBar.h
//  XKRW
//
//  Created by Klein Mioke on 15/7/9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class KMSearchBar;
//
//@protocol KMSearchBarDelegate <NSObject>
//
//- (void)KMSearchBarClickCancelButton:(KMSearchBar *)searchBar;
//
//@end

@interface KMSearchBar : UISearchBar

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setCancelButtonEnable:(BOOL)enable;

@end
