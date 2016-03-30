//
//  XKRWFocusCell.m
//  XKRW
//
//  Created by Shoushou on 15/11/16.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWFocusCell.h"
#import "UIImageView+WebCache.h"

#import "XKRWAdImageView.h"

#define SCALE (1.f/5)

#define CIRCULATE_CONSTANT 4

@implementation XKRWFocusCell
{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIPageControl *_pageCtl;
    NSInteger _dataArrayCount;
    
    NSMutableArray *_imageViewMutArray;
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _pageCtl.hidden = YES;
    
    if (dataArray) {
        _dataArray = dataArray;
        _dataArrayCount = dataArray.count;
        _imageViewMutArray = [NSMutableArray array];
        
        if (_scrollView.subviews.count) {
            for (id obj in _scrollView.subviews) {
                [obj removeFromSuperview];
            }
        }
        
        if (_dataArrayCount == 1) {
            _scrollView.contentSize = CGSizeMake(XKAppWidth, 0);
            _scrollView.contentOffset = CGPointMake(0, 0);
            _scrollView.delegate = self;
            _scrollView.scrollEnabled = NO;
            XKRWAdImageView *imageView = [[XKRWAdImageView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppWidth * SCALE)];
            imageView.tag = 0;
            imageView.url = [dataArray[0] imgUrl];
            imageView.title = [dataArray[0] title];
        
            [imageView setImageWithURL:[NSURL URLWithString:[dataArray[0] imgSrc]] placeholderImage:nil options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (self.isShowBlock) {
                    self.isShowBlock(YES);
                }
            }];
            
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adverBeClicked:)];
            [imageView addGestureRecognizer:tap];
            [_imageViewMutArray addObject:imageView];
            [_scrollView addSubview:imageView];
            return;
        }
        
        _scrollView.contentSize = CGSizeMake(XKAppWidth * (_dataArrayCount + CIRCULATE_CONSTANT), 0);
        _scrollView.contentOffset = CGPointMake(XKAppWidth * 2, 0);
        _scrollView.delegate = self;
        
        _pageCtl.numberOfPages = _dataArrayCount;
        _pageCtl.currentPage = 0;
        
        for (int i = 0; i < _dataArrayCount + CIRCULATE_CONSTANT; i++) {
            XKRWAdImageView *imageView = [[XKRWAdImageView alloc] initWithFrame:CGRectMake(i*XKAppWidth, 0, XKAppWidth, XKAppWidth * SCALE)];
            imageView.tag = i;
            
            NSString *imageUrlStr;
            NSString *linkUrlStr;
            NSString *navTitle;
            
            if (i == 0) {//循环拼接第一张，显示数组倒数第二张图
                imageUrlStr = [dataArray[_dataArrayCount - 2] imgSrc];
                linkUrlStr = [dataArray[_dataArrayCount - 2] imgUrl];
                navTitle = [dataArray[_dataArrayCount - 2] title];
                
            } else if (i == 1) {// 循环拼接第二张，显示数组第一张图
                imageUrlStr = [[dataArray lastObject] imgSrc];
                linkUrlStr = [[dataArray lastObject] imgUrl];
                navTitle = [[dataArray lastObject] title];
                
            } else if (i == _dataArrayCount + 3) { // 循环拼接倒数第一张，显示数组第二张图
                imageUrlStr = [dataArray[1] imgSrc];
                linkUrlStr = [dataArray[1] imgUrl];
                navTitle = [dataArray[1] title];

            } else if (i == _dataArrayCount + 2) { // 循环拼接倒数第二张，显示数组第一张图
                imageUrlStr = [dataArray[0] imgSrc];
                linkUrlStr = [dataArray[0] imgUrl];
                navTitle = [dataArray[0] title];

            }else {
                imageUrlStr = [dataArray[i - 2] imgSrc];
                linkUrlStr = [dataArray[i - 2] imgUrl];
                navTitle = [dataArray[i - 2] title];

            }
            
            imageView.url = linkUrlStr;
            imageView.title = navTitle;
            
            if (i == 2) {
                __weak __typeof(self)weakSelf = self;
                [imageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    if (weakSelf.isShowBlock) {
                        weakSelf.isShowBlock(YES);
                    }
                    _pageCtl.hidden = NO;
                    [weakSelf addTimer];
                }];
            }
            
            [imageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil options:SDWebImageContinueInBackground];

            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adverBeClicked:)];
            
            [imageView addGestureRecognizer:tap];
            [_scrollView addSubview:imageView];
            [_imageViewMutArray addObject:imageView];
        }
    }
}

- (IBAction)pageChange:(id)sender {
    _scrollView.contentOffset = CGPointMake((_pageCtl.currentPage + 2)*XKAppWidth, 0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x/XKAppWidth < 2) {
        _scrollView.contentOffset = CGPointMake((_pageCtl.numberOfPages + 2) * XKAppWidth, 0);
        
    }
    if (scrollView.contentOffset.x/XKAppWidth > (_pageCtl.numberOfPages + 2 )) {
        _scrollView.contentOffset = CGPointMake(XKAppWidth * 2, 0);
    }
    _pageCtl.currentPage = scrollView.contentOffset.x/XKAppWidth - 2;
}

- (void)pageCirculation {
    NSInteger page = _pageCtl.currentPage;
    page ++;
    
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake((page+2)*XKAppWidth, 0);
        
    }];
    
    if (page >= _pageCtl.numberOfPages) {
        page = 0;
        _scrollView.contentOffset = CGPointMake((page+2)*XKAppWidth, 0);
    }
    
    _pageCtl.currentPage = page;
}

#pragma mark -Action

- (void)adverBeClicked:(UITapGestureRecognizer *)sender {

    XKRWAdImageView *imageView = _imageViewMutArray[sender.view.tag];
    
    if (self.adverClickedBlock) {
        self.adverClickedBlock(imageView.url, imageView.title);
    }
}

- (void)addTimer {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(pageCirculation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    });
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
