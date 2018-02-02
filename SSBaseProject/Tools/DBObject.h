//
//  DBObject.h
//  单例+FMDB
//
//  Created by imac on 16/7/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
@interface DBObject : NSObject

@property (nonatomic,strong) FMDatabaseQueue *queue;

@property(nonatomic, assign) int TodaySignInCount;
@property(nonatomic, strong) UIView *currrentView;

@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *time1;
@property (nonatomic,copy) NSString *time2;

@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,strong) NSMutableArray *arr;


/**
 *  单例
 */
+(instancetype)sharedInstance;
/**
 *  新建数据库+新建表
 */
-(void)addDatabaseAndTableMethod;
/**
 *  新增
 */
-(void)insetDate:(NSString *)date time:(NSString *)addTime;
/**
 *  删除
 */
-(void)deleteWithDate:(NSString *)date;
/**
 *  更新数据
 */
-(void)updateWithTime1:(NSString *)time1 time2:(NSString *)time2 WithDate:(NSString *)date;
/**
 *  条件查询数据
 */
-(void)selectWithDate:(NSString *)date;
/**
 *  查询所有数据
 *
 */
-(void)selectAllMethod;
@end
