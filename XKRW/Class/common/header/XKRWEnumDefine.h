//
//  XKRWEnumDefine.h
//  XKRW
//
//  Created by zhanaofan on 13-12-27.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#ifndef XKRW_XKRWEnumDefine_h
#define XKRW_XKRWEnumDefine_h


//性别
typedef enum{
    eSexMale = 0,
    eSexFemale = 1 //女
}XKSex;
//用户群体
typedef enum{
    eGroupUnsel = -100,
    eGroupDay = 2,
    eGroupStudent = 1,
    eGroupNight = 3,
    eGroupFreelance = 4,
    eGroupPuerperium = 5,
    eGroupOther = 0,
}XKGroup;

/*运营内容类别*/
typedef enum {
    eOperationKnowledge = 1,    ///< 减肥知识
    eOperationEncourage = 2,    ///< 励志
    eOperationSport = 3,        ///< 运动
    eOperationFamous = 4,       ///< 名人瘦瘦
    eOperationTalentShow =5,    ///< 达人秀
    eOperationPK = 6,           ///< pk
    eOperationOthers = 7        ///< 灵活运营


}XKOperation;

/*运营内容来源*/
typedef enum{
    eFromToday  = 1,            ///< 今天的运营内容
    eFromHistory,               ///< 来自历史
    eFromCollection,            ///< 来自收藏页面
    eFromMoreRecomandInWebView  ///< 来自网页内点击更多文章
}XKManagementSource;


/*瘦身目的*/
typedef enum {
    eWhole = 1,
    ePart,
}XKReducePart;

/*瘦身部位*/
typedef enum {
    eArm = 1,
    eChest,
    eThigh,
    eWaist,
    eCrus,
    eHip,
}XKReducePosition;

/*难易程度*/
typedef enum {
	eEasyCount = 1,         //容易
	eNormalCount,           //一般
    eHardCount,             //困难
    eVeryHardCount,         //艰巨
}XKDifficultyKindCount;


/*难易程度*/
typedef enum {
	eEasy = 1,         //容易
	eNormal,           //一般
    eHard,             //困难
    eVeryHard,         //艰巨
}XKDifficulty;

typedef enum {
	eLight = 1,         //轻体力
	eMiddle,            //中体力
    eHeavy,             //重体力
}XKPhysicalLabor; 

typedef enum {
    efoodCalories = 0,
    eSportCalories
}XKCaloriesType;



//方案列别
typedef enum  _SchemeType
{
    eSchemeFood    = 1, //饮食方案
    eSchemeSport        //运动方案
} SchemeType;

//方案餐次定义
typedef enum _MealType{
    eSport         = 0,      //运动
    eMealBreakfast ,     //早餐
    eMealLunch,             //午餐
    eMealDinner,             //晚餐
    eMealSnack,              //加餐
    
} MealType;

/*运动单位*/
typedef enum _SportUnit{
    eSportUnitTime = 1,     //记时运动
    eSportUnitNumber       //记次运动
} SportUnit;

//提醒类型定义
typedef enum _AlarmType{
    eAlarmRecord = 1,
    eAlarmBreakfast,
    eAlarmLunch,
    eAlarmDinner,
    eAlarmSnack,
    eAlarmExercise,
    eAlarmWalk,
    eAlarmHabit,
    eAlarmDrinkWater,
    eAlarmInsistDays
    
} AlarmType;

//提醒类型定义
typedef enum _searchType{
    eFoodType = 0,
    eSportType,
    eHabitType,
}ResultType;

/*曲线类型*/
typedef enum _DataType{
    eWeightType = 1,    //体重
    eBustType,          //胸围
    eArmType,           //臂围
    eWaistType,         //腰围
    eHipType,           //臀围
    eThighType,         //大腿围
    ecalfType,          //小腿围
    eSurrondType
} DataType;


typedef enum _tipType{
    eTipBreakfast = 1,
    eTipLunch,      //午餐
    eTipDinner,     //晚餐
    eTipSnack,      //加餐
    eTipSport,      //运动
    eTipScheme,     //方案
    eTipWeight,     //体重记录
    
} tipType;

/*星期*/
typedef enum _weekDay{
    eMonday   =  1 << 0,
    eTursday  =  1 << 1,
    eWednesday=  1 << 2,
    eThursday =  1 << 3,
    eFriday   =  1 << 4,
    eSaturday =  1 << 5,
    eSunday   =  1 << 6
} weekDay;

/*操作类型*/
typedef enum _OpType{
    eOpTypeAdd=1,
    eOpTypeEdit,
} OpType;
/*日期类型*/
typedef enum _DayType{
    eToday = 1,
    eTomorrow
} DayType;

/*适合等级*/
typedef enum  _FitLevel{
    eFitLevel1 = 1,
    eFitLevel2,
    eFitLevel3,
    eFitLevel4,
    eFitLevel5
} FitLevel;

typedef enum _MetricUnit{
    eUnitGram = 1,             //克
    eUnitKilojoules,           //千焦
    eUnitKiloCalories,         //千卡
    eUnitBox,                  //盒
    eUnitBlock,                //块
    eUnitMilliliter,           //毫升
    eUnitMinutes,               //分钟
    eUnitOne,                  //个
    eUnitHalf,                 //半个
    eUnitOnly                  //只
} MetricUnit;

inline NSString* getMetricUnitDescription(MetricUnit unit) {
    switch (unit) {
        case 1:
            return @"克";
            break;
        case 2:
            return @"千焦";
            break;
        case 3:
            return @"kcal";
            break;
        case 4:
            return @"盒";
            break;
        case 5:
            return @"块";
            break;
        case 6:
            return @"毫升";
            break;
        case 7:
            return @"分钟";
            break;
        default:
            return @"";
    }
}

struct foodMetric{
    float weight;
    float energy;
};
typedef struct foodMetric foodMetric;

typedef enum _RequestStatus{
    eRequestStart,  //请求开始
    eRequesting,    //请求中
    eRequestEnd
} RequestStatus;

/**
 *  能量环状态
 */
typedef NS_ENUM(NSInteger,XKRWEnergyCircleStyle){
    /**
     *  未开启
     */
    XKRWEnergyCircleStyleNotOpen = 1,
    /**
     *  开启并选中
     */
    XKRWEnergyCircleStyleSelected,
    /**
     *  已开启未选中
     */
    XKRWEnergyCircleStyleOpened,
    /**
     *  选中不显示闪烁对错标示状态
     */
    XKRWEnergyCircleStyleHideStateImage,
    /**
     *  完美状态
     */
    XKRWEnergyCircleStylePerfect
};

/**
 *  记录类型
 */
typedef NS_ENUM(NSInteger, RecordType) {
    /**
     *  运动
     */
    RecordTypeSport = 0,
    /**
     *  早餐
     */
    RecordTypeBreakfirst,
    /**
     *  午餐
     */
    RecordTypeLanch,
    /**
     *  晚餐
     */
    RecordTypeDinner,
    /**
     *  加餐
     */
    RecordTypeSnack,
    /**
     *  方案
     */
    RecordTypeScheme = 100
};

typedef  NS_ENUM(NSInteger,FromWhichVC) {
    RootVC = 1,          //
    ServiceVC,             //服务页
    FatReasonReviewVC,      //肥胖原因评测页
    BackToFatReasonReviewVC,   //从肥胖原因分析界面 到 肥胖原因界面 再返回肥胖原因评测
    FatAnalyseVC,         //肥胖原因分析页
    AssessmentReport,       //评估报告页
    LoginVC,
    RegisterVC,
    MyVC,
    SchemeInfoChangeVC,
    Appdelegate
};

typedef NS_ENUM(NSInteger, NavigationBarType) {
    NavigationBarTypeDefault =1,   //默认的
    NavigationBarTypeTransparency   //透明的
    
};

typedef NS_ENUM(NSInteger, BMIType) {
    eLowest = 1,
    eStandard,
    eHighest
};

typedef NS_ENUM(NSInteger, XKRWTopicCellType) {
    XKRWTopicCellTypeDiscover = 1,   //只含背景图，标题和“瘦身分享”黑色半透明标签
    XKRWTopicCellTypeDraft,        // 无话题，无头像，有“未发布，已推荐”等右下标
    XKRWTopicCellTypeMyShare,     // 有话题，无头像，有“未发布，已推荐”等右下标
    XKRWTopicCellTypePublished,   // 有话题，无头像，有“已推荐”右下标
    XKRWTopicCellTypeOriginal,   //没有话题，有头像，有“已推荐”右上标
    XKRWTopicCellTypeFitShare,     //有话题，有头像，无标签
    XKRWTopicCellTypeThump,      //有话题，有头像 ，有“已推荐”右上标
    XKRWTopicCellTypeDelete  //只包含背景图 标题
};


typedef NS_ENUM(NSInteger, XKRWArticleOwn) {
    MyArticle = 1,   //我自己的文章
    OtherArticle     //其他人的文章
};

typedef NS_ENUM(NSInteger, XKRWArticleState) {
    Normal = 1,   //正常
    Recommended ,    //推荐
    NoRelease       //未发布
};

typedef NS_ENUM(NSInteger,XKRWArticleType) {
    LikeArticle = 1,  //喜欢的文章
    ShareArticle,  //发布的文章
    postLikeArticle //喜欢的帖子
};

typedef NS_ENUM(NSInteger,XKRWNoticeType) {
    BePraiseNotice = 1,
    CommentNotice
};


/**
 * XKRWPlanTipsCell 文本的两种展现形式
 */
typedef NS_ENUM(NSInteger,TipsShowType) {
    /***  只展示文本*/
    TipsShowText = 0,
    /***  展示文本  并制定新计划*/
    TipsShowAndEnactNewPlan,
    /***  展示文本  并显示详情*/
    TipsShowAndShowDetail,
    /***  展示文本  进入设置页面*/
    TipsShowAndEnterSet
};

typedef NS_ENUM(NSInteger, PlanType) {
    Food = 0,
    Sport,
    Habit
};

typedef NS_ENUM(NSInteger,energyType) {
    energyTypeEat = 1,
    energyTypeSport,
    energyTypeHabit
};

typedef NS_ENUM(NSInteger, XKRWRecordType) {
    XKRWRecordTypeFood = 0,
    XKRWRecordTypeSport,
    XKRWRecordTypeCustom,
    XKRWRecordTypeWeight,
    XKRWRecordTypeCircumference,
    XKRWRecordTypeHabit,
    XKRWRecordTypeMenstruation,
    XKRWRecordTypeSleep,
    XKRWRecordTypeWater,
    XKRWRecordTypeMood,
    XKRWRecordTypeRemark,
    XKRWRecordTypeScheme = 100
};

/**
 *  查看每日分析枚举
 */
typedef NS_ENUM(NSInteger, AnalysizeType) {
    /**
     *  饮食摄入
     */
    analysizeEat = 1,
    /**
     *  运动消耗
     */
    analysizeSport
};
#endif
