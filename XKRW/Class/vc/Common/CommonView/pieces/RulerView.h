//
//  RulerView.h
//  RulerPart
//
//  Created by Leng on 14-3-31.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PointerLocation{
    PointerLocationCenter   = 0 ,//default is center
    PointerLocationLetf     = 1 ,
    PointerLocationRight    = 2
}PointerLocation;

typedef enum RulerKind{
    RulerKind_Integer = 0,//default
    RulerKind_MinHalf = 1
    
}RulerKind;

@interface RulerView : UIView<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView * table;//默认显示视图
    
    NSInteger  scaleStartCorrection;//0单位起始位置

    NSInteger  maxDefault ;//默认为10 个单位
    
    BOOL       autoGrow;//自动增长 默认为NO
    
    PointerLocation locationRecord;//游标位置
    
    RulerKind   rulerKindRecord;
    
    NSInteger   multipleUnit;//默认 5
}
@property (nonatomic,copy) void(^ScaleValue)(int integerValue,int decimal);
@property (nonatomic,assign) NSInteger currentValue;
//-(void) setRulerKind:(RulerKind )kindChoss;


-(void) setMaxInterValue:(NSInteger )maxValue; //设置最大值
-(void) setPointerLocation:(PointerLocation)location;//游标位置  头 中 尾
-(void) setAutoGrow:(BOOL ) autoGrowTheMaxValue;//自动增长开关
-(void) setCurrentValue:(NSInteger) current;//设置当前 游标值

@end
