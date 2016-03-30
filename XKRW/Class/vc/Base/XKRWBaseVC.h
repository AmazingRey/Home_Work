//
//  XKRWBaseVC.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-11.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//



#import "XKViewController.h"
#import "XKTextField.h"
#import "UIViewController+XKVc.h"
#import "XKSilentDispatcher.h"
#import "MobClick.h"

@interface XKRWBaseVC : XKViewController
@property (nonatomic,assign) BOOL needPop;
@property (nonatomic) BOOL forbidAutoAddCloseButton;
@property (nonatomic) BOOL forbidAutoAddPopButton;

@property (nonatomic) BOOL isNeedHideNaviBarWhenPoped;

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

// 添加的Navi Bar的左Button，所添加的Button的点击动作为调用doClickNaviBarLeftButton:方法。
- (void)addNaviBarLeftButtonWithNormalImageName:(NSString *)normalImageName
                           highlightedImageName:(NSString *)highlightedImageName
                                       selector:(SEL)action;
// 添加的Navi Bar的右Button，所添加的Button的点击动作为调用doClickNaviBarRightButton:方法。
- (void)addNaviBarRightButtonWithNormalImageName:(NSString *)normalImageName
                            highlightedImageName:(NSString *)highlightedImageName
                                        selector:(SEL)action;



-(void)pressRight:(UIButton*)sender;
-(void)pressLeft:(UIButton*)sender;


//添加Navi Bar 左侧返回按钮
- (void)addNaviBarBackButton;
/**
 *  添加naviBar右侧按钮
 *
 *  @param text   按钮标题
 *  @param action 点击事件
 */
- (void)addNaviBarRightButtonWithText:(NSString *)text action:(SEL)action;

/// 添加右导航栏删除按钮
- (void)addNaviBarRightDeleteButton;
//添加右上角阶段标志
-(void)addStageButton:(int32_t)stage;
//添加右上角阶段label
-(void)addStageLabel:(NSString*)text;
//添加问卷界面下一个问题按钮
-(void)addQuestionNextButtonWithTitle:(NSString *)title;

- (void)closeView;
- (void)closeViewAnimated:(BOOL)animate;
- (void)popView;
- (void)popViewWithCheckNeedHideNaviBarWhenPoped;
- (void)checkNeedHideNaviBarWhenPoped;
/**
 *  左Item事件处理
 *
 *  @param button
 */
- (void)leftItemAction:(UIButton *)button;
/**
 *  右Item事件处理
 *
 *  @param button
 */
- (void)rightItemAction:(UIButton *)button;


- (void)pop2Views;
- (void)pop3Views;
- (BOOL)checkRequiredForTextField:(XKTextField *)textField
                    withInputName:(NSString *)inputName;
- (BOOL)checkFormatForTextField:(XKTextField *)textField
                      withRegex:(NSString *)regex
                      ngMessage:(NSString *)ngMessage;
- (BOOL)checkCharacterForTextField:(XKTextField *)textField
                     withInputName:(NSString *)inputName;
- (BOOL)checkDigitForTextField:(XKTextField *)textField
                  withMinDigit:(NSUInteger)minDigit
                      maxDigit:(NSUInteger)maxDigit
                     ngMessage:(NSString *)ngMessage;
- (BOOL)checkTextField:(XKTextField *)textField
        notEqualToText:(NSString *)equalText
         withNGMessage:(NSString *)ngMessage;

- (void)downloadWithTask:(XKDispatcherTask)task;

//使用非阻塞式的
- (void)uploadWithTask:(XKDispatcherTask)task;
- (void)uploadWithTask:(XKDispatcherTask)task message:(NSString *)message;
//使用阻塞式的
- (void)uploadBlockingWithTask:(XKDispatcherTask)task;

- (void)uploadBlockingWithTask:(XKDispatcherTask)task inView:(UIView *)view;
- (void)uploadBlockingWithTask:(XKDispatcherTask)task message:(NSString *)message;


- (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task message:(NSString *)message;

// 子类可覆盖实现：收到满足shouldRespondForNotication:条件的下载成功的通知后会被调用
// 缺省实现为:在主线程调用下面的loadDataToView方法
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID;
// 子类可覆盖实现：收到满足shouldRespondForNotication:条件的上传成功的通知后会被调用
// 缺省实现为:在主线程中关闭处理中的Hud，然后调用下面的didUpload方法
- (void)didUploadWithResult:(id)result taskID:(NSString *)taskID;

// 子类可覆盖实现：收到满足shouldRespondForNotication:条件的下载失败的通知后会被调用
// 缺省实现为:亲情关爱应用的通用下载失败处理，详见代码
- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID;
// 子类可覆盖实现：收到满足shouldRespondForNotication:条件的上传失败的通知后会被调用
// 缺省实现为:亲情关爱应用的通用上传失败处理，详见代码
- (void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID;

// 用以子类覆盖实现：用以实现用addNaviBarLeftButtonWithImageName:添加的按钮的点击动作，缺省为无动作，供子类覆盖扩展
- (void)doClickNaviBarLeftButton:(id)sender;
// 用以子类覆盖实现：用以实现用addNaviBarRightButtonWithImageName:添加的按钮的点击动作，缺省为无动作，供子类覆盖扩展
- (void)doClickNaviBarRightButton:(id)sender;

// 用以子类覆盖实现：收到满足shouldRespondForNotication:条件的下载成功的通知后会被调用，缺省实现为无处理
- (void)loadDataToView;
// 用以子类覆盖实现：收到满足shouldRespondForNotication:条件的上传成功的通知后会被调用，缺省实现为无处理
- (void)didUpload;
// 用以子类覆盖实现：上传失败时对UI或数据进行处理
- (void)finallyJobWhenUploadFail;


/**
 *  设置NavigationBar 左右Item
 *
 *  @param leftItemTitle    左边Item标题  为nil的时候 表示不创建左Item
 *  @param rightItemTitle   右边Item标题  为nil的时候 表示不创建右Item
 *  @param color            Item颜色
 *  @param leftShow         是否显示左边的小红点
 *  @param rightShow        是否显示右边的小红点
 *  @param leftShowNum         是否显示左边的数字
 *  @param rightShowNum        是否显示右边的数字
 */
- (void)setNavifationItemWithLeftItemTitle:(NSString *) leftItemTitle AndRightItemTitle:(NSString *)rightItemTitle AndItemColor:(UIColor *)color andShowLeftRedDot:(BOOL) leftShow AndShowRightRedDot:(BOOL)rightShow AndLeftRedDotShowNum:(BOOL)leftShowNum AndRightRedDotShowNum:(BOOL)rightShowNum AndLeftItemIcon:(NSString *)leftItemIcon AndRightItemIcon:(NSString *)rightItemIcon;
/**
 *  处理文章网络加载失败后的显示
 */
- (void)showRequestArticleNetworkFailedWarningShow;

- (void)hiddenRequestArticleNetworkFailedWarningShow;

/**
 *  清除 navigationItem 上的小红点
 *
 *  @param leftItemRedDotNeedHide   左边Item 上的小红点是否需要清除
 *  @param rightItemRedDotNeedHide  右边Item 上的小红点是否需要清除
 */
- (void)hideNavigationLeftItemRedDot:(BOOL)leftItemRedDotNeedHide andRightItemRedDotNeedHide:(BOOL)rightItemRedDotNeedHide;
/**
 *  <#Description#>
 *
 *  @param leftNum <#leftNum description#>
 */
- (void)setNavigationLeftRedNum:(NSString *)leftNum;
/**
 *  <#Description#>
 *
 *  @param rightNum <#rightNum description#>
 */
- (void)setNavigationRightRedNum:(NSString *)rightNum;
/**
 *  重新加载页面的网络请求
 *
 *  @param button <#button description#>
 */
- (void)reLoadDataFromNetwork:(UIButton *)button;



/**
 *  在window 上显示图片
 *
 *  @param window       window
 *  @param imageView    imageView
 *  @param time         显示time
 *  @param timeEndBlock timeEndBlock
 */
- (void)popUpTheTipViewOnWindowAsUserFirstTimeEntryVC:(UIWindow *)window andImageView:(UIImageView *)imageView andShowTipViewTime:(NSTimeInterval) time andTimeEndBlock:(void (^)(UIView *backgroundView,UIImageView *imageView))timeEndBlock;

@end
