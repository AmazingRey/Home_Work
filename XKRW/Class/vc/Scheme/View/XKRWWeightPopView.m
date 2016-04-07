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
        
        _iCarouselView.type = iCarouselTypeLinear;
        _iCarouselView.delegate = self;
        _iCarouselView.dataSource = self;
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
    return 5;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 20;
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
        view = [[UIImageView alloc] initWithFrame:self.frame];
        view.contentMode = UIViewContentModeScaleToFill; //图片拉伸模式
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

void displayDetailPage(NSString * link,NSString * title)
{
    
    //    ADWebViewController * vc = [[ADWebViewController alloc] init];
    //    vc.linkerUrl = link;
    //    vc.title = title;
    //    [[DataCenter getCurrentVC] presentViewController:vc animated:YES completion:^{
    //        
    //    }];
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
