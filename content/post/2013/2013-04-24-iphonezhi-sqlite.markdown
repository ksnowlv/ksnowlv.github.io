---
title: "iPhone之SQLite"
date: 2013-04-24
lastmod: 2013-04-24
categories:
  - "iOS"
tags:
  - "数据库"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

## iPhone SQLite

### 1.工程引用SQLite

iPhone系统自带`SQLite`

首先工程中，引入头文件`#import <sqlite3.h>`和`libsqlite3.dylib LIB`库。

### 2.创建数据库

现在要使用SQLite创建一个数据库文件（ 路径:/Users/lvwei/Library/Application Support/iPhone Simulator/4.3.2/Applications/C6B78C3D-8DD5-47B9-B0EE-160B009EA485/Documents/myDbFile/dbFile.db；

注意文件名，不要把dbFile.db中的.db去掉，不然，给你创建个目录).
  
### 3.创建数据库表,并执行相关数据库操作

  创建关于学生的表，有SVID（学生学号),name(姓名),sex（性别）,age（年龄）属性，对数据库有增删查改的操作。特别注意SQL语句的写法.
  

```objective-c
//
//  dbTest_sqliteViewController.m
//  dbTest_sqlite
//
//  Created by lv wei on 13-4-23.
//  Copyright (c) 2013年 kAir. All rights reserved.
//

#import "dbTest_sqliteViewController.h"
#import <sqlite3.h>

static NSString* const KDBFileName = @"dbFile.db";

@interface QStudent : NSObject

@property(nonatomic, retain)NSString* svid;
@property(nonatomic, retain)NSString* name;
@property(nonatomic, retain)NSString* sex;
@property(nonatomic, assign)NSUInteger age;

@end

@implementation QStudent
@synthesize svid = _svid;
@synthesize name = _name;
@synthesize sex = _sex;
@synthesize age = _age;

- (void)dealloc
{
    [_svid release];
    [_name release];
    [_sex release];
    [super dealloc];
}

@end

@interface dbTest_sqliteViewController ()
{
      sqlite3* _database;
}

@property(nonatomic, retain)NSString* dbFileFullPath;

@end

@implementation dbTest_sqliteViewController
@synthesize dbFileFullPath = _dbFileFullPath;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self dbFileCreate];
    [self dbFileOpen];
    [self createStudentTable];
    [self insertRecords1];
    [self showCurAllRecord];
    [self insertRecords2];
    [self showCurAllRecord];
    [self deleteRecordBySvid:@"030341311"];
    [self showCurAllRecord];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_dbFileFullPath release];
    if (_database) {
        sqlite3_close(_database);
        _database = NULL;
    }
    [super dealloc];
}

- (void)dbFileCreate
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myDbFile"];
        
        NSFileManager* fm = [NSFileManager defaultManager];
        
        if (![fm fileExistsAtPath:path]) {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.dbFileFullPath = [path stringByAppendingFormat:@"/%@",KDBFileName];
        
        if (![fm fileExistsAtPath:_dbFileFullPath]) {
            [fm createFileAtPath:_dbFileFullPath contents:nil attributes:nil];
        }
        
        NSLog(@"filePath = %@",_dbFileFullPath);
    }
}

- (void)dbFileOpen
{
    int res = sqlite3_open([_dbFileFullPath UTF8String], &_database);
    
    if (res != SQLITE_OK) {
        sqlite3_close(_database);
        _database = NULL;
    }
}

- (BOOL) createStudentTable{
    char *sql = "CREATE TABLE  student(id integer primary key, \
    svid text,\
    name text, \
    sex text, \
    age integer)";
    char *errorMsg;
    int success = sqlite3_exec(_database, sql, NULL,NULL,&errorMsg);
    
    if (success == SQLITE_OK) {
        NSLog(@"create table student ok!");
        return YES;
    }
    else
    {
        NSLog(@"create table student fail!");
        return NO;
    }
}

//插入学生记录1
- (void)insertRecords1
{
    const int KArrayLen = 4;
    NSArray* svidList = [NSArray arrayWithObjects:@"030341318",@"030341311",@"030341309",@"030341120", nil];
    NSArray* nameList = [NSArray arrayWithObjects:@"ksnow", @"ksnowlv",@"kAir",@"ksnowk",nil];
    NSArray* sexList = [NSArray arrayWithObjects:@"女", @"男",@"男",@"女",nil];
    int ageList[KArrayLen] = {28,25,32,12};
    
    for (int i = 0; i < KArrayLen; ++i) {
        QStudent* student = [[QStudent alloc] init];
        student.svid = [svidList objectAtIndex:i];
        student.name = [nameList objectAtIndex:i];
        student.sex = [sexList objectAtIndex:i];
        student.age = ageList[i];
        
        if (![self findRecordBySVid:student.svid]) {
            [self createStudentRecord:student];  
        }
        else
        {
            [self updateRecord:student];
        }
        
        [student release];
    }
}

//插入学生记录2
- (void)insertRecords2
{
    const int KArrayLen = 4;
    NSArray* svidList = [NSArray arrayWithObjects:@"030341318",@"030341300",@"030341301",@"030341302", nil];
    NSArray* nameList = [NSArray arrayWithObjects:@"ksnowlv", @"学生1",@"学生2",@"学生3",nil];
    NSArray* sexList = [NSArray arrayWithObjects:@"男", @"男",@"男",@"女",nil];
    int ageList[KArrayLen] = {29,25,32,12};
    
    for (int i = 0; i < KArrayLen; ++i) {
        QStudent* student = [[QStudent alloc] init];
        student.svid = [svidList objectAtIndex:i];
        student.name = [nameList objectAtIndex:i];
        student.sex = [sexList objectAtIndex:i];
        student.age = ageList[i];
        
        if (![self findRecordBySVid:student.svid]) {
            [self createStudentRecord:student];
        }
        else
        {
            [self updateRecord:student];
        }
        
        [student release];
    }
}

//创建学生的记录
- (BOOL)createStudentRecord:(QStudent*)student{
   
    sqlite3_stmt *statement;
    static char *sql = "INSERT INTO student (svid,name,sex,age)\
    VALUES(?,?,?,?)";
    
    //问号的个数要和(svid,name,sex,age)里面字段的个数匹配，代表未知的值，将在下面将值和字段关联。
    int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert:channels");
        return NO;
    }
    
    //这里的数字1，2，3，4代表第几个问号
    sqlite3_bind_text(statement, 1,student.svid.UTF8String, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, student.name.UTF8String, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, student.sex.UTF8String, -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 4, student.age);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database with message.");
        return NO;
    }
    
    NSLog(@"insert student svid = %@, name = %@,sex = %@,age=%d",
          student.svid,student.name,student.sex,student.age);
    return YES;
}

//显示所有学生的记录
- (void)showCurAllRecord
{
    NSLog(@"start showAllRecord");
    
    NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM student"];
    
    sqlite3_stmt *statement = nil;
    
    int res = sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &statement, NULL);

    if ( res != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message:get student.");
    }
    
    //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char* svid       = (char*)sqlite3_column_text(statement, 1);
        char* name     = (char*)sqlite3_column_text(statement, 2);
        char* sex     = (char*)sqlite3_column_text(statement, 3);
        int age    = sqlite3_column_int(statement, 4);
        NSString* studentSvid = [[NSString alloc] initWithCString:svid encoding:NSUTF8StringEncoding];
        NSString* studentName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        NSString* studentSex = [[NSString alloc] initWithCString:sex encoding:NSUTF8StringEncoding];
        NSLog(@"student svid = %@, name = %@,sex = %@,age=%d",
              studentSvid,studentName,studentSex,age);
        [studentSvid release];
        [studentName release];
        [studentSex release];
    }
    sqlite3_finalize(statement);
    
     NSLog(@"complete showAllRecord");
}

//查询是否存在该SVID的记录？
- (BOOL) findRecordBySVid:(NSString*)svid{
        
    NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM student where svid == \"%@\";",svid];
    
    sqlite3_stmt *statement = nil;
 
    int res = sqlite3_prepare_v2(_database, [sqlString UTF8String], -1, &statement, NULL);
    if ( res != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message:get student.");
    }
    
    BOOL isExistRecord = NO;
    //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (YES) {
        res = sqlite3_step(statement);
        if (res == SQLITE_ROW) {
            char* svid       = (char*)sqlite3_column_text(statement, 1);
            char* name     = (char*)sqlite3_column_text(statement, 2);
            char* sex     = (char*)sqlite3_column_text(statement, 3);
            int age    = sqlite3_column_int(statement, 4);
            NSString* studentSvid = [[NSString alloc] initWithCString:svid encoding:NSUTF8StringEncoding];
            NSString* studentName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
            NSString* studentSex = [[NSString alloc] initWithCString:sex encoding:NSUTF8StringEncoding];
            NSLog(@"query student svid = %@, name = %@,sex = %@,age=%d",
                  studentSvid,studentName,studentSex,age);
            [studentSvid release];
            [studentName release];
            [studentSex release];
            
            isExistRecord = YES;
            break;
        }
        else
        {
            break;
        }
    }
    sqlite3_finalize(statement);
    
    return isExistRecord;
}

//在查询存在该SVID的记录时，更新记录
- (BOOL)updateRecord:(QStudent*)student
{
    NSString*   updateSQLString =[NSString stringWithFormat:@"update student set name= \"%@\", sex=\"%@\",age=%d where svid=\"%@\"",student.name,student.sex,student.age,student.svid];
    
    char *errMsg = NULL;
    int res = sqlite3_exec(_database, [updateSQLString UTF8String], NULL, NULL, &errMsg);
    
    if(res ==SQLITE_OK){
        
        NSLog(@"更新成功!");
        return YES;
    }
    else
    {
        NSLog(@"更新失败!");
        return NO;
    }
}

//在查询存在该SVID的记录时，更新记录
- (BOOL)deleteRecordBySvid:(NSString*)svid
{
    NSString*   updateSQLString =[NSString stringWithFormat:@"delete from student where svid=\"%@\"",svid];
    
    char *errMsg = NULL;
    int res = sqlite3_exec(_database, [updateSQLString UTF8String], NULL, NULL, &errMsg);
    
    if(res ==SQLITE_OK){
        
        NSLog(@"删除成功!");
        return YES;
    }
    else
    {
        NSLog(@"删除失败!");
        return NO;
    }
}

@end

```

### 4.执行情况

```terminal
	2013-04-24 17:53:49.170 dbTest_sqlite[26700:c303] filePath = /Users/lvwei/Library/Application Support/iPhone Simulator/4.3.2/Applications/C6B78C3D-8DD5-47B9-B0EE-160B009EA485/Documents/myDbFile/dbFile.db
	2013-04-24 17:53:49.222 dbTest_sqlite[26700:c303] create table student ok!
	2013-04-24 17:53:49.228 dbTest_sqlite[26700:c303] insert student svid = 030341318, name = ksnow,sex = 女,age=28
	2013-04-24 17:53:49.251 dbTest_sqlite[26700:c303] insert student svid = 030341311, name = ksnowlv,sex = 男,age=25
	2013-04-24 17:53:49.253 dbTest_sqlite[26700:c303] insert student svid = 030341309, name = kAir,sex = 男,age=32
	2013-04-24 17:53:49.258 dbTest_sqlite[26700:c303] insert student svid = 030341120, name = ksnowk,sex = 女,age=12
	2013-04-24 17:53:49.258 dbTest_sqlite[26700:c303] start showAllRecord
	2013-04-24 17:53:49.259 dbTest_sqlite[26700:c303] student svid = 030341318, name = ksnow,sex = 女,age=28
	2013-04-24 17:53:49.259 dbTest_sqlite[26700:c303] student svid = 030341311, name = ksnowlv,sex = 男,age=25
	2013-04-24 17:53:49.259 dbTest_sqlite[26700:c303] student svid = 030341309, name = kAir,sex = 男,age=32
	2013-04-24 17:53:49.260 dbTest_sqlite[26700:c303] student svid = 030341120, name = ksnowk,sex = 女,age=12
	2013-04-24 17:53:49.260 dbTest_sqlite[26700:c303] complete showAllRecord
	2013-04-24 17:53:49.261 dbTest_sqlite[26700:c303] query student svid = 030341318, name = ksnow,sex = 女,age=28
	2013-04-24 17:53:49.333 dbTest_sqlite[26700:c303] 更新成功!
	2013-04-24 17:53:49.336 dbTest_sqlite[26700:c303] insert student svid = 030341300, name = 学生1,sex = 男,age=25
	2013-04-24 17:53:49.338 dbTest_sqlite[26700:c303] insert student svid = 030341301, name = 学生2,sex = 男,age=32
	2013-04-24 17:53:49.341 dbTest_sqlite[26700:c303] insert student svid = 030341302, name = 学生3,sex = 女,age=12
	2013-04-24 17:53:49.342 dbTest_sqlite[26700:c303] start showAllRecord
	2013-04-24 17:53:49.342 dbTest_sqlite[26700:c303] student svid = 030341318, name = ksnowlv,sex = 男,age=29
	2013-04-24 17:53:49.342 dbTest_sqlite[26700:c303] student svid = 030341311, name = ksnowlv,sex = 男,age=25
	2013-04-24 17:53:49.343 dbTest_sqlite[26700:c303] student svid = 030341309, name = kAir,sex = 男,age=32
	2013-04-24 17:53:49.343 dbTest_sqlite[26700:c303] student svid = 030341120, name = ksnowk,sex = 女,age=12
	2013-04-24 17:53:49.344 dbTest_sqlite[26700:c303] student svid = 030341300, name = 学生1,sex = 男,age=25
	2013-04-24 17:53:49.344 dbTest_sqlite[26700:c303] student svid = 030341301, name = 学生2,sex = 男,age=32
	2013-04-24 17:53:49.366 dbTest_sqlite[26700:c303] student svid = 030341302, name = 学生3,sex = 女,age=12

```