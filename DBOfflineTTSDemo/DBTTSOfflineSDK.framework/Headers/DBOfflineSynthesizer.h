//
//  DBOfflineSynthesizerManager.h
//  DBTTSOfflineSDK
//
//  Created by linxi on 2020/2/13.
//  Copyright © 2020 biaobei. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DBSynthesizerRequestParam.h"
#import "DBSynthesizerDelegate.h"
#import "DBSynthesisPlayerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 消息的回调


@interface DBOfflineSynthesizer : NSObject

// 合成数据回调，仅回调合成的数据
@property(nonatomic,weak)id <DBSynthesizerDelegate> delegate;

/// 播放的代理回调，如果“startPlayISNeedSpeaker：” 设置为Yes，并设置回调对象才会回调
@property(nonatomic,weak)id <DBSynthesisPlayerDelegate> playerDelegate;

/// 1:打印日志 0：不打印日志,默认不打印日志
@property(nonatomic,assign,getter=islog)BOOL log;

/// 设置缓存数据的长度,最小200KB,默认2*1024KB 即2M
@property(nonatomic,assign)NSInteger bufferDataLenght;

@property (nonatomic, copy) NSString *audioSessionCategory;

/// 播放器当前的播放状态
@property(nonatomic,assign,readonly)BOOL isPlayerPlaying;

/// 是否需要合成info,默认为NO
@property(nonatomic,assign)BOOL isNeedSynInfo;


+ (DBOfflineSynthesizer *)instance;


- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret messageHander:(DBMessagHandler)messageHandler;


/// 设置离线合成模型的路径
/// @param dataPath 前端文件的路径
/// @param speechPath 后端文件的路径
- (NSInteger)setDataPath:(NSString *)dataPath speechPath:(NSString *)speechPath;

/**
 * @brief 设置SynthesizerRequestParam对象参数,返回值为0,表示设置参数成功
 */
-(NSInteger)setSynthesizerParams:(DBSynthesizerRequestParam *)requestParam;


///开始合成  Yes: 需要播放，NO:不需要播放
- (void)startPlayISNeedSpeaker:(BOOL)needSpeaker;

///  停止合成和朗读
- (void)stop;

/// 继续朗读
- (int)resume;

/// 暂停朗读
- (int)pause;


@end

NS_ASSUME_NONNULL_END
