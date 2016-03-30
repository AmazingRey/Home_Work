//
//  XKRWADView.m
//  XKRW
//
//  Created by Klein Mioke on 15/8/28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWADView.h"
#import "UIImageView+WebCache.h"
#import "XKRWAdEntity.h"

@implementation XKRWADView
{
    NSArray *_entities;
    int _currentIndex;
    
    void (^_clickAction)(int, XKRWAdEntity*);
    void (^_closeAction)();
}

- (id)initWithType:(XKRWADViewType)type adEntities:(NSArray *)entities {
    
    if (self = [super init]) {
        _entities = entities;
        _type = type;
        if (type == XKRWADViewTypeBanner) {
            [self initWithTypeBanner];
        }
    }
    return self;
}

- (void)setClickAction:(void (^)(int index, XKRWAdEntity *entity))action closeAction:(void (^)())closeAction {
    
    _clickAction = action;
    _closeAction = closeAction;
}

- (void)initWithTypeBanner {
    
    // The banner's ratio between height and width is 1:5 for now
    self.frame = CGRectMake(0, 0, XKAppWidth, XKAppWidth / 5);
    
    XKRWAdEntity *entity = _entities.firstObject;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    __unsafe_unretained __typeof__(imageView) weakImageView = imageView;
    
    [imageView setImageWithURL:[NSURL URLWithString:entity.imgsrc] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickAction:)];
        [weakImageView addGestureRecognizer:tapGesture];
        weakImageView.userInteractionEnabled = YES;
    }];
    
    [self addSubview:imageView];
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(XKAppWidth-50, 0, 50, self.frame.size.height)];
    [close addTarget:self action:@selector(handleCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    close.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [self addSubview:close];
}

- (void)handleClickAction:(UITapGestureRecognizer *)gesture {
    
    
    if (_clickAction) {
        
        if (_type == XKRWADViewTypeBanner) {
            _clickAction(0, _entities.firstObject);
            
        } else {
            // TODO: more types

        }
    }
}

- (void)handleCloseAction:(id)sender {
    
    if (_closeAction) {
        _closeAction();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
