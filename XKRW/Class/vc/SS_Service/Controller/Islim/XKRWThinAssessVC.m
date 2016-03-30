//
//  XKRWThinAssessVC.m
//  XKRW
//
//  Created by y on 15-1-22.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWThinAssessVC.h"
#import "XKRWStageOneTableViewCell.h"

#import "XKRWThinbodystageModel.h"
#import "XKRWCircleView.h"

#import "XKRW-Swift.h"

@interface XKRWThinAssessVC ()

@property (nonatomic ,strong) XKRWThinAssessCell *cell;

@end

@implementation XKRWThinAssessVC
@synthesize array;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addNaviBarBackButton];
    [self setTitle:@"指导方案"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.height = XKAppHeight - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT;
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = XK_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XKRWThinAssessCell" bundle:nil]
         forCellReuseIdentifier:@"ThinAssessCellIdentifier"];
    
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"ThinAssessCellIdentifier"];
    [self.cell loadText:_model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [XKRWUtil getViewSize:self.cell.contentView].height + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"ThinAssessCellIdentifier";
    if (!self.cell) {
        self.cell = [self.tableView dequeueReusableCellWithIdentifier:cellid];
        [self.cell loadText:_model];
    }
    return self.cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
