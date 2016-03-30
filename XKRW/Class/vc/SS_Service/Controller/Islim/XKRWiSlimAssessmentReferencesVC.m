//
//  XKRWiSlimAssessmentReferencesVC.m
//  XKRW
//
//  Created by XiKang on 15-1-15.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWiSlimAssessmentReferencesVC.h"
#import "XKRWiSlimAssessmentReferencesCell.h"
#import "XKRWUtil.h"

@interface XKRWiSlimAssessmentReferencesVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XKRWiSlimAssessmentReferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initialize

- (void)initSubviews {
    
    [MobClick event:@"in_iSlimDoc"];
    self.title = @"参考资料";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)
                                                  style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizesSubviews = YES;
    
    self.tableView.backgroundColor = XK_BACKGROUND_COLOR;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XKRWiSlimAssessmentReferencesCell" bundle:nil]
         forCellReuseIdentifier:@"XKRWiSlimAssessmentReferencesCell"];
    
    [self.view addSubview:self.tableView];
    
    [self addNaviBarBackButton];
}

#pragma mark - TableView's delegate & datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRWiSlimAssessmentReferencesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKRWiSlimAssessmentReferencesCell"];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    XKRWiSlimAssessmentReferencesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKRWiSlimAssessmentReferencesCell"];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
