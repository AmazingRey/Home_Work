//
//  XKRWWeightPopView.m
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWWeightPopView.h"
@implementation XKRWWeightPopView{
    BOOL isInit;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWWeightPopView");
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _arrLabels = @[@"体重",@"胸围",@"腰围",@"臀围"];
        isInit = YES;
        
        _iCarouselView.type = 11;
//        _iCarouselView.bounceDistance = 150;
//        _iCarouselView.contentOffset = CGSizeMake(-110, 0);
        _iCarouselView.perspective = -0.008;
        _iCarouselView.delegate = self;
        _iCarouselView.dataSource = self;
        _iCarouselView.bounces = YES;
        _iCarouselView.clipsToBounds = YES;
        _iCarouselView.scrollEnabled = YES;
        _iCarouselView.centerItemWhenSelected = YES;
        _iCarouselView.scrollToItemBoundary = NO;
        _iCarouselView.decelerationRate = 0.7;
        _iCarouselView.scrollSpeed = .5;
        _iCarouselView.currentItemIndex = 0;
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void)awakeFromNib{
    
}

#pragma btnsure  &  btncancle

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    carousel.currentItemIndex = index;
//    [carousel scrollToItemAtIndex:index duration:10.0f];
    [carousel scrollToItemAtIndex:index animated:YES];
    NSLog(@"🐅%ld",(long)index);
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
}
- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    for (UIView *item in carousel.visibleItemViews) {
        for (UILabel *lab in item.subviews) {
            lab.layer.borderWidth = 0;
            lab.layer.borderColor = [UIColor clearColor].CGColor;
            lab.textColor = [UIColor blackColor];
        }
    }
    
    for (UIView *view in carousel.currentItemView.subviews) {
        if ([view isKindOfClass:[UILabel class]] ) {
            UILabel *lab = (UILabel *)view;
            lab.textColor = XKMainToneColor_29ccb1;
            lab.layer.borderWidth = 1;
            lab.layer.cornerRadius = 5;
            lab.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
            NSString *str= [lab.text isEqualToString: _arrLabels[0]]?@"kg":@"cm";
            _labInput.text = str;
        }
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _arrLabels.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 55;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSUInteger)index
         reusingView:(UIImageView *)view
{
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
        view.contentMode = UIViewContentModeScaleToFill; //图片拉伸模式
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 26)];
       
        lab.text = [NSString stringWithFormat:@"%@",_arrLabels[index]];
        lab.textAlignment = NSTextAlignmentCenter;
        
        if (isInit && index == 0) {
            lab.textColor = XKMainToneColor_29ccb1;
            lab.layer.borderWidth = 1;
            lab.layer.cornerRadius = 5;
            lab.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
            isInit = NO;
        }
        [view addSubview:lab];
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.10f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 1.3f;
            }
            return value;
        }
        case iCarouselOptionFadeMin:
        {
            if (_carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return -1.3f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}


- (IBAction)pressCancle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressPopViewCancle)]) {
        [self.delegate pressPopViewCancle];
    }
}

- (IBAction)pressSure:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressPopViewSure:)]) {
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        [self.delegate pressPopViewSure:[numFormatter numberFromString:[NSString stringWithFormat:@"%@",_textField.text]]];
    }
}

- (IBAction)actBefore:(id)sender {
    
}

- (IBAction)actLater:(id)sender {
}
@end
