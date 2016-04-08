//
//  XKRWWeightPopView.m
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWWeightPopView.h"

@implementation XKRWWeightPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWWeightPopView");
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        _iCarouselView.type = 11;
        _iCarouselView.contentOffset = CGSizeMake(50, 0);
        _iCarouselView.delegate = self;
        _iCarouselView.dataSource = self;
        _iCarouselView.clipsToBounds = YES;
        _iCarouselView.decelerationRate = 0.7;
        _iCarouselView.scrollSpeed = 1;
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
   
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 50;
}

//焦点改变时
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSUInteger)index
         reusingView:(UIImageView *)view
{
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(50 * (index-1), 10, 30, 20)];
        view.backgroundColor = [UIColor greenColor];
        
        view.contentMode = UIViewContentModeScaleToFill; //图片拉伸模式
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 20, 20)];
        lab.backgroundColor = [UIColor redColor];
        lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)index];
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
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.00f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
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
@end
