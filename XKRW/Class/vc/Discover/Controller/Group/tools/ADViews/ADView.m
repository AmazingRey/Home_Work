//
//  ADView.m
//  Yoohoo
//
//  Created by Seth Chen on 14-9-18.
//  Copyright (c) 2014年 ideacp. All rights reserved.
//

#import "ADView.h"
#import "iCarousel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation ADModel
-(void)dealloc
{
    self.banner_id = nil;
    self.banner_name = nil;
    self.banner_bdate = nil;
    self.banner_edate = nil;
    self.banner_picture = nil;
    self.banner_tp = nil;
}
@end

@interface ADView()<iCarouselDataSource,iCarouselDelegate>
@property(nonatomic,retain) iCarousel           *gallery;
@property(nonatomic,retain) UIPageControl       *pageCtrl;
@property(nonatomic,retain) UILabel             *tittleLabel;
@property(nonatomic,retain) NSMutableArray      *imageViews;
@end
@implementation ADView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _gallery = [[iCarousel alloc] initWithFrame:self.bounds];
        _gallery.autoresizingMask = UIViewAutoresizingFlexibleWidth
        |UIViewAutoresizingFlexibleHeight;
        _gallery.type = iCarouselTypeLinear;
        _gallery.delegate = (id)self;
        _gallery.dataSource = (id)self;
        _gallery.decelerationRate = 0.7;
        _gallery.scrollSpeed = 1;
        [self addSubview:_gallery];
        
        
//        _tittleLabel = [[UILabel alloc]initWithFrame:(CGRect){0,self.frame.size.height - 20,self.width,20}];
//        _tittleLabel.textColor = [UIColor whiteColor];
//        _tittleLabel.backgroundColor = [UIColor darkGrayColor];
//        _tittleLabel.font = DEFAULT_DETAIL_FONT;
//        _tittleLabel.alpha = 0.5;
//        [self addSubview:_tittleLabel];
       
        
        _pageCtrl = [[UIPageControl alloc] init];
        _pageCtrl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageCtrl.hidesForSinglePage = YES;
        [self addSubview:_pageCtrl];
        
        
        [_gallery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.width.equalTo(self);
        }];
        _imageViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reloadData
{
    [_gallery reloadData];
}

-(void)setAdlist:(NSArray *)adlist
{
    _adlist = adlist;
    [_imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_gallery reloadData];

    [XKDispatcher syncExecuteTask:^{
        _gallery.period = 3000;
        _gallery.autoPlay = YES;
    } afterSeconds:.2];

    _pageCtrl.frame = CGRectMake(0, self.height - 20, self.width, 20);
    _pageCtrl.numberOfPages = adlist.count;
}

#pragma mark ----------------  icarousel delegate ----------------

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    ADModel* model = [_adlist safeObjectAtIndex:index];
    if (self.noticeDelegate && [self.noticeDelegate respondsToSelector:@selector(adItemClick:)]) {
        [self.noticeDelegate adItemClick:model];
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _adlist.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.width;
}

//焦点改变时
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    _pageCtrl.currentPage = carousel.currentItemIndex;
//    ADModel* model = [_adlist objectAtIndex:carousel.currentItemIndex];
//    _tittleLabel.text = OCSTR(@"  %d. %@",carousel.currentItemIndex+1,model.banner_name);

}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSUInteger)index
         reusingView:(UIImageView *)view
{
    if (view == nil) {
        view = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        view.contentMode = UIViewContentModeScaleToFill; //图片拉伸模式
    }
    
    ADModel* model = [_adlist objectAtIndex:index];
    [view setImageWithURL:[NSURL URLWithString:model.banner_picture] placeholderImage:[UIImage imageNamed:@"me_bg"] options:SDWebImageRetryFailed];
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

//void displayDetailPage(NSString * link,NSString * title)
//{

//    ADWebViewController * vc = [[ADWebViewController alloc] init];
//    vc.linkerUrl = link;
//    vc.title = title;
//    [[DataCenter getCurrentVC] presentViewController:vc animated:YES completion:^{
//        
//    }];
//}

@end


@implementation NSArray(safe)

-(id)safeObjectAtIndex:(NSUInteger)index
{
    return index >= self.count ? nil : [self objectAtIndex:index];
}

-(id)firstObject
{
    return [self safeObjectAtIndex:0];
}

-(id)lastbutone
{
    return [self safeObjectAtIndex:self.count-2];
}

@end
