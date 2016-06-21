//
//  XKRWDBControlService.m
//  XKRW
//
//  Created by XiKang on 14-6-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWDBControlService.h"

static XKRWDBControlService *shareInstance;

@implementation XKRWDBControlService
//单例
+(instancetype)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWDBControlService alloc]init];
    });
    return shareInstance;
}

- (void) updateDBTable{
    
    /*
     *******************************
     3.1.0 升级操作， 增加新表 签到表 (day:txt,uid:int)
     *******************************
     */
    [self addDayRecordTable];
    /*
     *******************************
     3.1.0 升级操作， 表修改 新增字段 (signature:)
     *******************************
     */
    [self updateUserTable];
    
    /*
     *******************************
     3.2.0 升级操作， 新增签到表
     date   TEXT        DEFAULT NULL,
     year   TEXT        DEFAULT NULL,
     month  TEXT        DEFAULT NULL,
     day    TEXT        DEFAULT NULL,
     uid    integer     DEFAULT NULL
     *******************************
     */
    [self addregLogsTable];
    
    // to be continue...
    
    
    /*
     ****************************************
     *  4.0升级操作 增加记录页的表，共五张
     ****************************************
     */
    [self addRecordTables];
    /**
     *  提醒表更新
     */
    [self updateAlarmTable];
    
    /**
     *  4.1升级操作
     */
    [self addFoodDetailTable];
    
    
    //4.1 新加订单表
    [self addOrderTable];
    
    /**
     *  4.2 新增 收藏表
     */
    [self addCollectionTable];
    
    /*
     *  5.0 新增
     */
    [self addFoodCategoryTable];
    [self addNewSchemeTable];
    [self addRecordSchemeTable];
    
    // 5.0 update
    [self v5_0_update];
    
    // 5.0.1 update
    [self v5_0_1Upadate];
    
    [self v5_1_0UpData];
    
    [self v5_1_2UpData];
    
    [self v5_2UpData];
    
    [self v5_3UpData];
}

//4.1新增
//购买记录 表  待修改字段
-(void)addOrderTable
{
    NSString * sqlCreate = @"CREATE TABLE  IF NOT EXISTS OrderTable (orderNo TEXT  DEFAULT NULL,orderProductName TEXT  DEFAULT NULL,recordId integer default NULL,uid integer default NULL ,money text default NULL,orderDate text default NULL,evaluateScore text default NULL,evaluateDate text default NULL,orderCount text default NULL,content text default NULL,Primary Key(recordId))";
    @try {
        [self executeSql:sqlCreate];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}


//4.2新增

- (void)addCollectionTable
{
    NSString *sqlString = @"\
    CREATE TABLE IF NOT EXISTS CollectionTable (\
    cid     integer Primary Key AUTOINCREMENT DEFAULT 1,\
    uid         integer DEFAULT 0,\
    collect_type integer default NULL,\
    original_id integer DEFAULT NULL,\
    collect_name   TEXT NOT NULL,\
    content_url   TEXT DEFAULT NULL,\
    category_type integer DEFAULT 0,\
    image_url   TEXT DEFAULT NULL,\
    food_energy integer DEFAULT NULL,\
    date        TEXT DEFAULT NULL,\
    sync        integer DEFAULT 0)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"收藏表创建失败：%@",exception);
    }

}

- (void)addCollectionTable_5
{
    NSString *sqlString = @"\
    CREATE TABLE IF NOT EXISTS CollectionTable_5 (\
    original_id     integer Primary Key  NULL,\
    uid         integer DEFAULT 0,\
    collect_type integer default NULL,\
    collect_name   TEXT NOT NULL,\
    content_url   TEXT DEFAULT NULL,\
    category_type integer DEFAULT 0,\
    image_url   TEXT DEFAULT NULL,\
    food_energy integer DEFAULT NULL,\
    date        TEXT DEFAULT NULL)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"收藏表创建失败：%@",exception);
    }

}

- (void)deleteCollectionTable
{
    NSString *sql = @" DROP TABLE CollectionTable";
    
    [self executeSql:sql];
}


- (void)addRecordTables
{
    NSString *sqlString = @"\
    CREATE TABLE IF NOT EXISTS food_record (\
    server_id   integer NOT NULL DEFAULT 0,\
    rid         integer Primary Key AUTOINCREMENT DEFAULT 1,\
    uid         integer DEFAULT 0,\
    food_id     integer DEFAULT 0,\
    food_name   TEXT NOT NULL,\
    record_type integer DEFAULT 1,\
    calorie     integer DEFAULT 0,\
    number      integer DEFAULT 0,\
    unit        integer,\
    image_url   TEXT DEFAULT NULL,\
    food_energy integer,\
    date        TEXT DEFAULT NULL,\
    sync        integer DEFAULT 0,\
    number_new  integer,\
    unit_new    TEXT DEFAULT NULL)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"记录食物表创建失败： %@",exception);
    }
    
    sqlString = @"\
    CREATE TABLE IF NOT EXISTS sport_record (\
    server_id    integer NOT NULL DEFAULT 0,\
    rid          integer Primary Key AUTOINCREMENT DEFAULT 1,\
    uid          integer DEFAULT 0,\
    sport_id     integer DEFAULT 0,\
    sport_name   TEXT NOT NULL,\
    record_type  integer NOT NULL DEFAULT 0,\
    calorie      integer NOT NULL DEFAULT 0,\
    number       integer DEFAULT 0,\
    unit         integer,\
    image_url    TEXT DEFAULT NULL,\
    sport_METS   float,\
    date         TEXT DEFAULT NULL,\
    sync         integer DEFAULT 0)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"记录运动表创建失败： %@",exception);
    }
    sqlString = @"\
    CREATE TABLE IF NOT EXISTS custom_food_record (\
    server_id   integer NOT NULL DEFAULT 0,\
    rid         integer Primary Key AUTOINCREMENT DEFAULT 1,\
    uid         integer DEFAULT 0,\
    food_id     integer DEFAULT NULL,\
    food_name   TEXT DEFAULT NULL,\
    number      integer,\
    unit        TEXT DEFAULT NULL,\
    calorie     integer,\
    type        integer DEFAULT 1,\
    date        TEXT DEFAULT NULL,\
    sync        integer DEFAULT 0)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"记录自定义食物表创建失败： %@",exception);
    }
    sqlString = @"\
    CREATE TABLE IF NOT EXISTS custom_sport_record (\
    server_id   integer NOT NULL DEFAULT 0,\
    rid         integer Primary Key AUTOINCREMENT DEFAULT 1,\
    uid         integer DEFAULT 0,\
    sport_id    integer DEFAULT NULL,\
    sport_name  TEXT DEFAULT NULL,\
    number      integer,\
    unit        TEXT DEFAULT NULL,\
    calorie     integer,\
    type        integer DEFAULT 0,\
    date        TEXT DEFAULT NULL,\
    sync        integer DEFAULT 0)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"记录自定义运动表创建失败： %@",exception);
    }
    sqlString = @"\
    CREATE TABLE IF NOT EXISTS record_4_0 (\
    rid             integer  PRIMARY KEY AUTOINCREMENT DEFAULT 1,\
    uid             integer DEFAULT 0,\
    weight          Float DEFAULT NULL,\
    habit           TEXT DEFAULT NULL,\
    menstruation    integer,\
    sleep_time      Float DEFAULT NULL,\
    get_up_time     Time DEFAULT NULL,\
    water integer   DEFAULT NULL,\
    mood integer    DEFAULT NULL,\
    remark TEXT     DEFAULT NULL,\
    waistline       Float DEFAULT NULL,\
    bust            Float DEFAULT NULL,\
    hipline         Float DEFAULT NULL,\
    arm             Float DEFAULT NULL,\
    thigh           Float DEFAULT NULL,\
    shank           Float DEFAULT NULL,\
    date            TEXT DEFAULT NULL,\
    sync            integer DEFAULT 0)";
    
    @try {
        [self executeSql:sqlString];
    }
    @catch (NSException *exception) {
        NSLog(@"记录表创建失败： %@",exception);
    }
}
//
-(void)addregLogsTable{
    
    NSString * sqlCreate =@"CREATE TABLE  IF NOT EXISTS registerLogs (date TEXT  DEFAULT NULL,year TEXT  DEFAULT NULL,month TEXT  DEFAULT NULL,day TEXT  DEFAULT NULL,uid integer  DEFAULT NULL,Primary Key(date,uid))";
    @try {
        [self executeSql:sqlCreate];
    }
    @catch (NSException *exception) {
        NSLog(@"签到表创建失败%@",exception);
    }
    @finally {
        
    }
}
//
-(void) addDayRecordTable
{
    //3.1.0 升级操作， 增加新表 签到表 (day:txt,uid:int)
    NSString * sqlCreate = @"CREATE TABLE  IF NOT EXISTS registerRecord (day TEXT  DEFAULT NULL,uid integer  DEFAULT NULL,Primary Key(day,uid))";
    @try {
        [self executeSql:sqlCreate];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}
//3.1.0升级操作
-(void) updateUserTable{
    NSString * sqlUpdateTable = @"alter table account add manifesto TEXT default null;";
    NSString * sqlUpdateTable_slimParts = @"alter table account add slimParts TEXT default null;";
    @try {
        [self executeSql:sqlUpdateTable];
        [self executeSql:sqlUpdateTable_slimParts];
    }
    @catch (NSException *exception) {
        NSLog(@"exception%@",exception );
    }
    @finally {
        
    }
}


//4.0升级操作
-(void) updateManagerTable
{
    NSString * sqlUpdateTable = @"alter table management add iconSelectUrl TEXT default null;";
    NSString * sqlUpdateTable_slimParts = @"alter table management add iconUnSelectUrl TEXT default null;";
    NSString * sqlUpdateTable_pv = @"alter table management add pv TEXT default null;";
    @try {
        [self executeSql:sqlUpdateTable];
        [self executeSql:sqlUpdateTable_slimParts];
        [self executeSql:sqlUpdateTable_pv];
    }
    @catch (NSException *exception) {
        NSLog(@"update management table exception%@",exception );
    }
    @finally {
        
    }
}
//5.0升级操作

-(void)updateDataBaseTable{
    [self updateManagementTable];
    [self updateManagementHistoryTable];
}


//删除运营数据表里面的数据
- (void)deleteManagementDataFromDB {
    NSString *deleteManagementTable = @"delete  from management";
    NSString *deleteManagementHistoryTable = @"delete from management_history";
    NSString *deleteManageHistoryRecordTable = @"delete  from manage_history_record";
    
    [self executeSql:deleteManagementTable];
    [self executeSql:deleteManagementHistoryTable];
    [self executeSql:deleteManageHistoryRecordTable];
}

- (void)updateManagementTable {
    //5.0 是否阅读
    NSString * sqlUpdateTable_read = @"alter table management add read integer DEFAULT 0;";
    NSString * updateTable_readNum = @"alter table management add readNum TEXT default null;";
    NSString * updateTable_b_image = @"alter table management add bigImage TEXT default null;";
    NSString * updateTable_s_image = @"alter table management add smallImage TEXT default null;";
    NSString * updateTable_show_type = @"alter table management add showType integer DEFAULT 5;";
    NSString * updateTable_subtitle = @"alter table management add subtitle TEXT default null;";
    
    @try {
        [self executeSql:sqlUpdateTable_read];
        [self executeSql:updateTable_readNum];
        [self executeSql:updateTable_b_image];
        [self executeSql:updateTable_s_image];
        [self executeSql:updateTable_show_type];
        [self executeSql:updateTable_subtitle];
    }
    @catch (NSException *exception) {
        NSLog(@"update management table exception%@",exception );
    }
    @finally {
        
    }
}

- (void)updateManagementHistoryTable {
    
    NSString * updateTable_beishu = @"alter table manage_history_record add beishu TEXT default null;";
    NSString * updateTable_date = @"alter table manage_history_record add date TEXT default null;";
    NSString * updateTable_readNum = @"alter table manage_history_record add readNum TEXT default null;";
    NSString * updateTable_title = @"alter table manage_history_record add title TEXT default null;";
    NSString * updateTable_url = @"alter table manage_history_record add url TEXT default null;";
    NSString * updateTable_read = @"alter table manage_history_record add read integer DEFAULT 0;";
    NSString * updateTable_leastrecord = @"alter table manage_history_record add leastrecord TEXT default null;";
    @try {
        [self executeSql:updateTable_beishu];
        [self executeSql:updateTable_date];
        [self executeSql:updateTable_readNum];
        [self executeSql:updateTable_title];
        [self executeSql:updateTable_url];
        [self executeSql:updateTable_read];
        [self executeSql:updateTable_leastrecord];
    }
    @catch (NSException *exception) {
        NSLog(@"update management table exception%@",exception );
    }
    @finally {
        
    }
}

- (void)updateAlarmTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS alarm_4_0 (\
    aid         integer  PRIMARY KEY AUTOINCREMENT DEFAULT 1,\
    uid         integer,\
    type        integer,\
    hour        integer,\
    minutes     integer,\
    daysofweek  integer,\
    enabled     integer DEFAULT NULL,\
    vibrate     integer,\
    label       TEXT DEFAULT NULL,\
    message     TEXT DEFAULT NULL,\
    alert       TEXT DEFAULT NULL,\
    sync        integer DEFAULT 0,\
    serverid    INTEGER DEFAULT 0)";
    
    @try {
        [self executeSql:sql];
    }
    @catch (NSException *exception) {
        NSLog(@"update table exception:\n%@", exception);
    }
}

- (void)addFoodDetailTable {
    
    NSString *sql = @"\
    CREATE TABLE IF NOT EXISTS food_detail (\
    food_id integer PRIMARY KEY DEFAULT NULL,\
    data    BLOB DEFAULT NULL)";
    
    @try {
        [self executeSql:sql];
    }
    @catch (NSException *exception) {
        NSLog(@"add food_detail table error: %@", exception);
    }
}

- (void)addFoodCategoryTable {
    
    NSString *sql = @"\
    CREATE TABLE IF NOT EXISTS food_category (\
    category_id         integer PRIMARY KEY DEFAULT NULL,\
    category_name       TEXT DEFAULT NULL,\
    calorie             integer,\
    weight              integer,\
    ban_foods_string    TEXT DEFAULT NULL,\
    ban_foods_ids       TEXT DEFAULT NULL,\
    type TEXT           DEFAULT NULL,\
    img_url             BLOB DEFAULT NULL,\
    detail              TEXT DEFAULT NULL,\
    insert_date         Timestamp DEFAULT 0)";
    
    @try {
        [self executeSql:sql];
    }
    @catch (NSException *exception) {
        NSLog(@"add food_category table error: %@", exception);
    }
}

- (void)addNewSchemeTable {
    
    NSString *addMealSchemeTable = @"\
    CREATE TABLE IF NOT EXISTS scheme_5_0 (\
    sid             integer  DEFAULT NULL,\
    type            integer  DEFAULT NULL,\
    name            TEXT,\
    size            integer,\
    total_calorie   integer,\
    detail          TEXT,\
    content         TEXT,\
    insert_date     Timestamp DEFAULT 0,\
    Primary Key(sid,\
    type))";
    
    @try {
        [self executeSql:addMealSchemeTable];
    }
    @catch (NSException *exception) {
        NSLog(@"add scheme_5_0 table error: %@", exception);
    }
}

- (void)addRecordUniversalTable {
    
    NSString *addRecordUniversalTable = @"\
    CREATE TABLE record_universal (\
    rid         integer  PRIMARY KEY AUTOINCREMENT DEFAULT 1,\
    uid         integer,\
    create_time Timestamp DEFAULT NULL,\
    type        integer,\
    value       BLOB  DEFAULT NULL,\
    sync        integer)";
    
    NSString *addIndex = @"CREATE INDEX record_universal_index ON record_universal (uid, type, create_time)";
    
    @try {
        [self executeSql:addRecordUniversalTable];
        [self executeSql:addIndex];
    }
    @catch (NSException *exception) {
        NSLog(@"add scheme_5_0 table error: %@", exception);
    }
}
- (void)addRecordSchemeTable {
    
    NSString *addRecordSchemeTable = @"\
    CREATE TABLE record_scheme (\
    rid             integer  PRIMARY KEY AUTOINCREMENT DEFAULT 1,\
    create_time     integer,\
    uid             integer,\
    sid             integer,\
    type            integer,\
    calorie         integer,\
    record_value    integer,\
    sync            integer,\
    date            TEXT)";
    
    NSString *addIndex = @"CREATE INDEX record_scheme_index ON record_scheme (uid, type, record_value)";
    NSString *addUniqueIndex = @"CREATE UNIQUE INDEX record_scheme_unique ON record_scheme (uid, type, date)";
    
    @try {
        [self executeSql:addRecordSchemeTable];
        [self executeSql:addIndex];
        [self executeSql:addUniqueIndex];
    }
    @catch (NSException *exception) {
        NSLog(@"add scheme_5_0 table error: %@", exception);
    }
}

#pragma mark - 5.0.0 update

- (void)v5_0_update {
    
    /*
     *  5.0 更新原运营表 By Zigen
     */
    [self updateManagementTable];
    [self updateManagementHistoryTable];
    
    // update food_record table
    [self updateRecordFoodTableOnV5_0];
    
    // update record 4.0 table
    [self updateRecord_4_0TableOnV5_0];
    
    // delete management data
    [self deleteManagementDataFromDB];
    
    // update account table: set accountname be unique index
    [self updateAccountTable];
    
   
}

- (void)updateRecordFoodTableOnV5_0 {
    
    NSString *new_number = @"ALTER TABLE food_record ADD number_new integer";
    NSString *new_unit = @"ALTER TABLE food_record ADD unit_new TEXT";
    @try {
        [self executeSql:new_number];
        [self executeSql:new_unit];
    }
    @catch (NSException *exception) {
        NSLog(@"ALTER food_record error: %@", exception);
    }
}

- (void)updateRecord_4_0TableOnV5_0 {
    
    NSString *addIndex = @"CREATE UNIQUE INDEX record_4_0_index ON record_4_0 (uid, date)";
    
    @try {
        [self executeSql:addIndex];
    }
    @catch (NSException *exception) {
        NSLog(@"UPDATE record4.0 table error: %@", exception);
    }
}

- (void)updateAccountTable {
    
    NSString *sql = @"CREATE UNIQUE INDEX account_name_index ON account (accountname)";
    @try {
        [self executeSql:sql];
    }
    @catch (NSException *exception) {
        NSLog(@"UPDATE accounttable error: %@", exception);
    }
}

#pragma mark - 5.0.1 update

- (void)v5_0_1Upadate {
    // 删除广告表
    [self deleteADTable];
    // 修改record_4_0表
    [self updateRecord_4_0TableOnV5_0_1];
    //重新重建收藏新表
    [self addCollectionTable_5];
    //删除 收藏旧表
    [self deleteCollectionTable];
}

- (void)deleteADTable
{
    NSString *sql = @"drop table if exists ADtable";
    [self executeSql:sql];
}

- (void)updateRecord_4_0TableOnV5_0_1 {
    
    NSString *sql = @"alter table record_4_0 rename to record_4_0_temp";
    // 如果有旧版本升级，则重命名record_4_0表
    if ([self executeSql:sql]) {
        sql = @"\
        CREATE TABLE IF NOT EXISTS record_4_0 (\
        rid             integer  PRIMARY KEY AUTOINCREMENT DEFAULT 1,\
        uid             integer DEFAULT 0,\
        weight          Float DEFAULT NULL,\
        habit           TEXT DEFAULT NULL,\
        menstruation    integer,\
        sleep_time      Float DEFAULT NULL,\
        get_up_time     Time DEFAULT NULL,\
        water integer   DEFAULT NULL,\
        mood integer    DEFAULT NULL,\
        remark TEXT     DEFAULT NULL,\
        waistline       Float DEFAULT NULL,\
        bust            Float DEFAULT NULL,\
        hipline         Float DEFAULT NULL,\
        arm             Float DEFAULT NULL,\
        thigh           Float DEFAULT NULL,\
        shank           Float DEFAULT NULL,\
        date            TEXT DEFAULT NULL,\
        sync            integer DEFAULT 0)";
        // 创建新表
        if ([self executeSql:sql]) {
            // 加索引
            [self updateRecord_4_0TableOnV5_0];
            // 从旧表中导入数据
            sql = @"replace into record_4_0 select * from record_4_0_temp";
            [self executeSql:sql];
            // 更新自增键最大值
            sql = @"select rid from record_4_0 order by rid desc limit 1";
            
            NSArray *rst = [self query:sql];
            if (rst && rst.count) {
                int seq = 0;
                if ([rst.firstObject isKindOfClass:[NSDictionary class]]) {
                    seq = [rst.firstObject[@"rid"] intValue];
                } else if ([rst.firstObject isKindOfClass:[NSNumber class]]) {
                    seq = [rst.firstObject intValue];
                }
                sql = [NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq = %d WHERE name = 'record_4_0'", seq];
                [self executeSql:sql];
            }
            // 删除旧表
            sql = @"drop table if exists record_4_0_temp";
            [self executeSql:sql];
        }
    }
}

#pragma mark - 5.1.0 update

- (void)v5_1_0UpData{
    [self accountTableAddField];
    
    /**
     *  新建用户文章表
     */
    [self createUserArticleTable];
    
    [self createNoticeTable];
}


#pragma mark -5.1.3 Update
- (void)v5_1_2UpData{
    [self noticeTableAddField];
}

#pragma mark -5.2 Update
- (void)v5_2UpData{
    [self accountTableAddFieldisAddGroup];
}

#pragma mark -5.3 Update
- (void)v5_3UpData{
    [self reocrd_4_0TableAddField];
}

//  用户信息表添加字段
- (void)accountTableAddField
{
    NSString *addUserBackgroundImageUrlSql = @"ALTER TABLE account ADD userBackgroundImageUrl Text";
    NSString *addUserNickNameEnableSql = @"ALTER TABLE account ADD userNickNameEnable integer";
    
    @try {
       BOOL  addSuccess =   [self executeSql:addUserBackgroundImageUrlSql];
       addSuccess =  [self executeSql:addUserNickNameEnableSql];
    }
    @catch (NSException *exception) {
        NSLog(@"ALTER food_record error: %@", exception);
    }

    
}

//  用户信息表添加字段 是否已加入过小组
- (void)accountTableAddFieldisAddGroup
{
    NSString *addUserBackgroundImageUrlSql = @"ALTER TABLE account ADD isAddGroup BLOB";
    NSString *addUserNickNameEnableSql = @"ALTER TABLE account ADD isAddGroup BLOB";
    
    @try {
        BOOL  addSuccess =   [self executeSql:addUserBackgroundImageUrlSql];
        addSuccess =  [self executeSql:addUserNickNameEnableSql];
    }
    @catch (NSException *exception) {
        NSLog(@"ALTER food_record error: %@", exception);
    }
    
    
}



//创建消息列表
- (void)createNoticeTable
{
    NSString *sql = @"CREATE TABLE  IF NOT EXISTS user_notice (\
    nid            integer  PRIMARY KEY AUTOINCREMENT DEFAULT 1,\
    uid         integer,\
    comment_id  integer    ,\
    avater Varchar DEFAULT NULL,\
    honor Varchar DEFAULT NULL,\
    nickname Varchar DEFAULT NULL,\
    blogId Varchar DEFAULT NULL,\
    text Varchar DEFAULT NULL,\
    time integer,\
    type integer,\
    read integer)";
    @try {
        BOOL success = [self executeSql:sql];
        
        NSLog(@"%d",success);
    }
    @catch (NSException *exception) {
        NSLog(@"create user_article failed");
    }
    
}

- (void)createUserArticleTable {
    
    NSString *sql = @"CREATE TABLE user_article (\
    user_id integer DEFAULT NULL,\
    user_account    Varchar DEFAULT NULL,\
    user_nickname   Varchar DEFAULT NULL,\
    user_manifesto  integer,\
    user_avatar     integer,\
    user_level      Varchar DEFAULT NULL,\
    aid             Varchar DEFAULT NULL,\
    article_title   Varchar DEFAULT NULL,\
    cover_image_url Varchar DEFAULT NULL,\
    topic_id        integer,\
    topic_name      Varchar DEFAULT NULL,\
    read_num        integer,\
    like_num        integer,\
    content         BLOB DEFAULT NULL,\
    image_paths     BLOB DEFAULT NULL,\
    status          integer,\
    timestamp       Timestamp DEFAULT NULL,\
    date            Varchar DEFAULT NULL)";
    
    @try {
        if ([self executeSql:sql]) {
            sql = @"CREATE UNIQUE INDEX user_article_unique_index ON user_article (user_account, timestamp)";
            [self executeSql:sql];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"create user_article failed");
    }
}


//  用户信息表添加字段
- (void)noticeTableAddField
{
    NSString *addMD5IDUrlSql = @"ALTER TABLE user_notice ADD md5_id Text ";
    NSString *addGroupIDEnableSql = @"CREATE UNIQUE INDEX md5id_time ON user_notice (md5_id, time)";
    
    @try {
        BOOL  addSuccess =   [self executeSql:addMD5IDUrlSql];
        addSuccess =  [self executeSql:addGroupIDEnableSql];
    }
    @catch (NSException *exception) {
        NSLog(@"ALTER food_record error: %@", exception);
    }
}

- (void)delete_V5_1_2DirtyData{
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOCAL_VERSION_KEY"];
    if([oldVersion compare:@"5.1.3"] == NSOrderedAscending){
        NSString *sql = @"delete  from record_4_0 where date < '2017-01-01' and date > '2016-12-26' " ;
        BOOL  addSuccess =   [self executeSql:sql];
        if(addSuccess){
            NSLog(@"脏数据删除成功");
        }
    }
}

// record4_0 新增体脂率栏位
- (void)reocrd_4_0TableAddField
{
    NSString *addMD5IDUrlSql = @"ALTER TABLE record_4_0 ADD fatpercent Float DEFAULT 0";
    @try {
        [self executeSql:addMD5IDUrlSql];
    }
    @catch (NSException *exception) {
        NSLog(@"ALTER food_record error: %@", exception);
    }
}
@end
