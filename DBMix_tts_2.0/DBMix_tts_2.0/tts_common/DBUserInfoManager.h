//
//  DBUserInfoManager.h
//  DBAudioSDKDemo
//
//  Created by linxi on 2021/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBUserInfoManager : NSObject

@property(nonatomic,copy)NSString * onlineClientId;
@property(nonatomic,copy)NSString * onlineClientSecret;

@property(nonatomic,copy)NSString * offlineClientId;
@property(nonatomic,copy)NSString * offlineClientSecret;


+ (instancetype)shareManager;

/// 读取资源文件的路径
/// @param resourse 资源文件
/// @param type 类型
+ (NSString *)pathForResourse:(NSString *)resourse type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
