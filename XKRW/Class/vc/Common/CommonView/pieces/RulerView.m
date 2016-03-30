//
//  RulerView.m
//  RulerPart
//
//  Created by Leng on 14-3-31.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

#import "RulerView.h"
#define Correction 0
#define rowHeightDefine 50

@implementation RulerView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        maxDefault = 1000;
        rulerKindRecord = RulerKind_Integer;
        CGSize size =CGSizeMake(self.frame.size.height, self.frame.size.width);
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
        table.backgroundColor = XKMainToneColor_29ccb1;
        table.layer.cornerRadius = 5;
        table.layer.masksToBounds  = YES;
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = rowHeightDefine;
        table.showsHorizontalScrollIndicator = NO;
        table.showsVerticalScrollIndicator = NO;
        table.transform	= CGAffineTransformMakeRotation(-M_PI/2);
        table.center  = CGPointMake(size.height/2, size.width/2);
        table.separatorColor =[UIColor clearColor];
        multipleUnit = 5;
        [self addSubview:table];
        [self setPointerLocation:PointerLocationCenter];
    }
    return self;
}



#pragma mark 改变度量单位 调整视图显示
-(void) setRulerKind:(RulerKind )kindChose{
    rulerKindRecord = kindChose;

    [table reloadData];
}

//游标位置
#pragma mark 游标位置
-(void) setPointerLocation:(PointerLocation)location{
    locationRecord = location;
    switch (location) {
        case 0:
        {
            //center
            [self setScaleStartLocation:self.frame.size.width/2];
        }
            break;
        case 1:
        {
            //left
            [self setScaleStartLocation:0];
        }
            break;
        case 2:
        {
            //right
            [self setScaleStartLocation:self.frame.size.width];
        }
            break;
            
        default:
            break;
    }
}
//内部方法
-(void)setScaleStartLocation:(NSInteger ) startLocation{
    scaleStartCorrection =Correction + startLocation - rowHeightDefine/2;
    NSInteger tPox = scaleStartCorrection + ((locationRecord == PointerLocationRight)? 0:0) ;
    NSInteger bPox =table.frame.size.width/2 + Correction -2 + ((locationRecord==PointerLocationLetf)? table.frame.size.width/2  :0) + ((locationRecord==PointerLocationRight)? (-table.frame.size.width/2 ) : 0) - rowHeightDefine/2;
        // UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
     table.contentInset = UIEdgeInsetsMake(tPox, 0, bPox , 0);
}

#pragma mark 是否自动增长
-(void) setAutoGrow:(BOOL ) autoGrowTheMaxValue{
    autoGrow = autoGrowTheMaxValue;
}
#pragma mark 不自动增长的情况下，最大值设定
-(void) setMaxInterValue:(NSInteger)maxValue{
    int CorrectTemp = rowHeightDefine/5;
    if (rulerKindRecord == RulerKind_MinHalf) {
        CorrectTemp = rowHeightDefine/2;
    }
    
    
    if (rulerKindRecord == RulerKind_Integer) {
        maxDefault = maxValue * CorrectTemp/rowHeightDefine+1 ;
    }
    
    [table reloadData];
}
#pragma mark 设置当前示数
//设置当前 游标值
-(void) setCurrentValue:(NSInteger) current{
    int CorrectTemp = rowHeightDefine/5;
    if (rulerKindRecord == RulerKind_MinHalf) {
        CorrectTemp = rowHeightDefine/2;
    }
    _currentValue = current;
    [UIView animateWithDuration:.5 animations:^{
        table.contentOffset = CGPointMake(0,current * CorrectTemp - scaleStartCorrection);
    }];

}

#pragma mark 修正格尺的位置， 返回当前读数
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

//    XKLog(@"滑动中 %d" ,decelerate);
    if (decelerate) {
        return;
    }
    [self correctTheRulerLocation:scrollView];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self correctTheRulerLocation:scrollView];
}

-(void) correctTheRulerLocation:(UIScrollView *)scrollView{
    int CorrectTemp = rowHeightDefine/5;
    if (rulerKindRecord == RulerKind_MinHalf) {
        CorrectTemp = rowHeightDefine/2;
    }
    
    float deviation = abs((int)(scrollView.contentOffset.y + scaleStartCorrection ) % CorrectTemp);
    
    //    XKLog(@"%f",scrollView.contentOffset.y + scaleStartCorrection);
    
    if ((!(deviation < 0.0000001) && (deviation > -0.0000001)) && (scrollView.contentOffset.y + scaleStartCorrection >= 0)) {
        
        int location = ((deviation > CorrectTemp/2 ) ? (scrollView.contentOffset.y + CorrectTemp - deviation) : (scrollView.contentOffset.y - deviation)) ;
        
        CGPoint point = CGPointMake(scrollView.contentOffset.x, location);
        [UIView animateWithDuration:.5 animations:^{
            scrollView.contentOffset = point;
        }];

        return;
    }

}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{

    int CorrectTemp = rowHeightDefine/5;
    if (rulerKindRecord == RulerKind_MinHalf) {
        CorrectTemp = rowHeightDefine/2;
    }
    int integerTemp =((scrollView.contentOffset.y +1 + scaleStartCorrection ) )/CorrectTemp ;

    if ((integerTemp >= 0 )) {
        _currentValue = integerTemp;
        if (self.ScaleValue) {
            self.ScaleValue(integerTemp,0);
        }
    }


}

#pragma mark tableview datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeightDefine;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XKLog(@"%ld",(long)maxDefault);
    return maxDefault;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndety = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIndety];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndety];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = XKMainToneColor_29ccb1;
        for (int i = 0; i<5; i++) {
            
            float xPox = cell.contentView.frame.size.height - (((i == 2) ? 10 : 5));
            float yPox = i*10 + 5;
            float width =((i == 2) ? 10 : 5);
            float height = 1;
            UIView * viewSperte = [[UIView alloc] initWithFrame:CGRectMake(xPox,
                                                                           yPox,
                                                                           width,
                                                                           height)];
            viewSperte.backgroundColor = [UIColor whiteColor];
//            viewSperte.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:viewSperte];
        }
        
        UILabel * lableSwot =[[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 10 , cell.contentView.frame.size.height/2 - 15, 40 , 40 )];
        lableSwot.tag = 3366;
        lableSwot.backgroundColor = [UIColor clearColor];
        lableSwot.font = [UIFont systemFontOfSize:10];
        lableSwot.textAlignment = NSTextAlignmentCenter;
        lableSwot.transform = CGAffineTransformMakeRotation(M_PI/2);
        lableSwot.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        lableSwot.adjustsFontSizeToFitWidth = YES;
        lableSwot.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:lableSwot];
    }
    if (autoGrow && (indexPath.row >( maxDefault - 20))) {
        maxDefault += 50;
        [table reloadData];
    }
    
    if (rulerKindRecord == RulerKind_Integer) {
        
        
    }else if (rulerKindRecord == RulerKind_MinHalf){
        
    }
    
    
    if ([[cell.contentView viewWithTag:3366] isKindOfClass:[UILabel class]]) {
        ((UILabel *)[cell.contentView viewWithTag:3366]).text =[NSString stringWithFormat:@"%ld",(long)indexPath.row * multipleUnit];
    }
    
    return cell;
}
@end
