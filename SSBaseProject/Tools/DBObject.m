//
//  DBObject.m
//  单例+FMDB
//
//  Created by imac on 16/7/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "DBObject.h"


@implementation DBObject

+(instancetype)sharedInstance{
    
    static DBObject *sql = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sql = [[DBObject alloc]init];
    });
    return sql;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _time1 = @"";
        _time2 = @"";
        _TodaySignInCount = 0;
    }
    return self;
}


/**
 *  初始化字典
 *
 *  @return <#return value description#>
 */
-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

/**
 *  初始化数组(查找全部)
 *
 *  @return <#return value description#>
 */
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr= [NSMutableArray array];
    }
    return _arr;
}


#pragma mark - 建库
-(void)addDatabaseAndTableMethod{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //拼接文件名
    NSString *filePath = [cachePath stringByAppendingString:@"note.sqlite"];
    NSLog(@"数据库路径:%@",filePath);
    //创建数据库,并加入到队列中,此时已经默认打开了数据库,无须手动打开,只需要从队列中去除数据库即可
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    //取出数据库,这里的db就是数据库,在数据库中建表
    [self.queue inDatabase:^(FMDatabase *db) {
        
        BOOL createTable = [db executeUpdate:@"create table if not exists t_note (id integer primary key autoincrement,date text,time1 text,time2 text)"];
        if (createTable) {
            NSLog(@"创建表成功");
        }
        else{
            NSLog(@"创建表失败");
        }
    }];
}

#pragma mark - 增
-(void)insetDate:(NSString *)date time:(NSString *)addTime{
    
    if ([UserDefaults_ReadObj(date) intValue] == 0) {
        //如果没有,添加一条
        [self.queue inDatabase:^(FMDatabase *db) {
            
            BOOL flag = [db executeUpdate:@"insert into t_note (date,time1) values (?,?)",date,addTime];
            if (flag) {
                NSLog(@"增success");
                UserDefaults_WriteObj([NSNumber numberWithInt:1], date);
            }
            else{
                NSLog(@"增fail");
            }
        }];
    }
    else if ([UserDefaults_ReadObj(date) intValue] == 1) {
        [self.queue inDatabase:^(FMDatabase *db) {
            //如果有1条,就添加第2条
            BOOL flag = [db executeUpdate:@"update t_note set time2 = ? where date = ?",addTime,date];
            if (flag) {
                NSLog(@"改success");
                UserDefaults_WriteObj([NSNumber numberWithInt:2], date);
            }
            else{
                NSLog(@"改fail");
            }
        }];
    }
    else if ([UserDefaults_ReadObj(date) intValue] == 2) {
        [self.currrentView.parentController presentViewController:[Tool showAlertTitle:@"今日已记录2次,不可添加" btnMsg:@"知道了"] animated:YES completion:nil];
    }
}

#pragma mark - 删
-(void)deleteWithDate:(NSString *)date{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        BOOL flag = [db executeUpdate:@"delete from t_note where date = ?",date];
        if (flag) {
            NSLog(@"删除数据成功");
        }
        else{
            NSLog(@"删除数据失败");
        }
    }];
}

#pragma mark - 改
-(void)updateWithTime1:(NSString *)time1 time2:(NSString *)time2 WithDate:(NSString *)date {

    [self.queue inDatabase:^(FMDatabase *db) {
        
        BOOL flag = [db executeUpdate:@"update t_note set time1 = ?, time2 = ? where date = ?",time1,time2,date];
        if (flag) {
            NSLog(@"更新数据成功");
        }
        else{
            NSLog(@"更新数据失败");
        }
    }];
}

#pragma mark - 条件查
-(void)selectWithDate:(NSString *)date{

    [self.queue inDatabase:^(FMDatabase *db) {
        int count = 0;
        //获取结果集,返回参数就是查询结果
        FMResultSet *rs = [db executeQuery:@"select *from t_note where date = ?",date];
        while ([rs next]) {
            
            self.date = [rs stringForColumn:@"date"];
            self.time1 = [rs stringForColumn:@"time1"];
            self.time2 = [rs stringForColumn:@"time2"];
            NSLog(@"平台:%@---用户名:%@----密码:%@",self.date,self.time1,self.time2);

            //先将数据存放到字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[Tool replaceNull:self.date] forKey:@"dictDate"];
            [dic setObject:[Tool replaceNull:self.time1] forKey:@"dictTime1"];
            [dic setObject:[Tool replaceNull:self.time2] forKey:@"dictTime2"];

            //然后将字典存放到数组
            [self.arr addObject:dic];
            count ++;
        }
        if (count == 0) {
            UserDefaults_WriteObj([NSNumber numberWithInt:0], date);
        }
        
        

    }];
}

#pragma mark - 查all
-(void)selectAllMethod{
    
    //每次进来查询的时候,先清除上次缓存数据
    [self.arr removeAllObjects];
    self.dic = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        //获取结果集,返回参数就是查询结果
        FMResultSet *rs = [db executeQuery:@"select *from t_note"];
        while ([rs next]) {
            
            self.date = [rs stringForColumn:@"date"];
            self.time1 = [rs stringForColumn:@"time1"];
            self.time2 = [rs stringForColumn:@"time2"];
            NSLog(@"平台:%@---用户名:%@----密码:%@",self.date,self.time1,self.time2);
            
            //先将数据存放到字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[Tool replaceNull:self.date] forKey:@"dictDate"];
            [dic setObject:[Tool replaceNull:self.time1] forKey:@"dictTime1"];
            [dic setObject:[Tool replaceNull:self.time2] forKey:@"dictTime2"];
            
            
             //然后将字典存放到数组
            [self.arr addObject:dic];
            
        }
        NSLog(@"存放的数组:%@==%ld",self.arr,self.arr.count);
    }];
    
   
    
}


# if 0
/**
 *  事务回滚写法1: (如果要保证多个操作同时成功或者同时失败，用事务，即把多个操作放在同一个事务中。)
 */
-(void)updateFailure:(id)sender{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db beginTransaction];
        [db executeUpdate:@"update t_note set name = 'jack' where password = ?",@"12"];
        [db executeUpdate:@"update t_note set name = 'tony' where password = ?",@"13"];
        //发现情况不对,主动回滚用下面语句.否则是根据commit结果,如成功就成功，如不成功才回滚
        [db rollback];
        [db executeUpdate:@"update t_note set name = '回滚' where password = ?",@"13"];
        [db commit];
    }];
}


/**
 *  事务回滚写法2:(直接利用队列进行事务操作,队列中的打开、关闭、回滚事务等都已经被封装好了)
 */
-(void)updateFailure02:(id)sender{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [db executeUpdate:@"update t_note set name = 'jack' where password = ?",@"12"];
            [db executeUpdate:@"update t_note set name = 'tony' where password = ?",@"13"];
            //发现情况不对,主动回滚用下面语句
            *rollback = YES;
            [db executeUpdate:@"update t_note set name = '回滚' where password = ?",@"13"];
            
        }];
    }];
}


/**
 *  回滚的原生代码:
 [db executeUpdate:@"BEGIN TRANSACTION"];
 [db executeUpdate:@"ROLLBACK TRANSACTION"];
 [db executeUpdate:@"COMMIT TRANSACTION"];
 */


#endif



@end
