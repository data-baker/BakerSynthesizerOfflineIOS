//
//  DBOfflineSynthesizerManager.h
//  DBTTSOfflineSDK
//
//  Created by linxi on 2020/2/13.
//  Copyright © 2020 biaobei. All rights reserved.
//
#import "DBSynthesizerDelegate.h"
#import <Foundation/Foundation.h>
#import "DBSynthesizerRequestParam.h"
#import "PCMDataPlayer.h"
#import "DBSynthesizerDelegate.h"
@class DBSynthesisPlayer;

NS_ASSUME_NONNULL_BEGIN

/// 失败的回调
typedef void (^DBFailureHandler)(DBFailureModel *error);

@interface DBOfflineSynthesizerManager : NSObject

@property(nonatomic,weak)id <DBSynthesizerDelegate> delegate;

///超时时间,默认30s
@property(nonatomic,assign)NSInteger  timeOut;

@property(nonatomic,strong)DBSynthesisPlayer * synthesisDataPlayer;

/// 1:打印日志 0：不打印日志,默认不打印日志
@property(nonatomic,assign,getter=islog)BOOL log;


+ (DBOfflineSynthesizerManager *)instance;


- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret successHandler:(dispatch_block_t)successHandler failureHander:(DBFailureHandler)failureHandler;


/**
 * @brief 设置SynthesizerRequestParam对象参数,返回值为0,表示设置参数成功
 */
-(NSInteger)setSynthesizerParams:(DBSynthesizerRequestParam *)requestParam;


/// 更改发音人
/// @param speakName 发音人名称
- (void)setSyntherSpeaker:(NSString *)speakName;

/// 开始合成
- (void)start;
///  停止合成
- (void)stop;

/// 每次进入页面的时候需要先刷新授权信息
- (void)refreshAuthoreInfoIfNeed;

@end

NS_ASSUME_NONNULL_END
