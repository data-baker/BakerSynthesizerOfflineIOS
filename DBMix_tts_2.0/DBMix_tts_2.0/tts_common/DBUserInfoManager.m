//
//  DBUserInfoManager.m
//  DBAudioSDKDemo
//
//  Created by linxi on 2021/8/5.
//

#import "DBUserInfoManager.h"

@implementation DBUserInfoManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static DBUserInfoManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[DBUserInfoManager alloc]init];
    });
    return manager;
}

+ (NSString *)pathForResourse:(NSString *)resourse type:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:resourse    ofType:type];
    return path;
}

@end
