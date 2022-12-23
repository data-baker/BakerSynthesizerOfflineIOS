//
//  DBOfflineSynthesizerManager.h
//  DBTTSOfflineSDK
//
//  Created by linxi on 2020/2/13.
//  Copyright © 2020 biaobei. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DBSynthesizerDelegate.h"
#import "DBSynthesisPlayerDelegate.h"
#import "DBSynthesizerRequestParam.h"
#import "DBOfflineSpeechModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 消息的回调
typedef void (^DBMessagHandler)(NSInteger ret, NSString *message);

@interface DBMixSynthesizer : NSObject

/// 播放的代理回调，如果“startPlayISNeedSpeaker：” 设置为Yes，并设置回调对象才会回调
@property(nonatomic,weak)id <DBSynthesisPlayerDelegate> playerDelegate;

// 合成数据回调，仅回调合成的数据
@property(nonatomic,weak)id <DBSynthesizerDelegate> delegate;
///超时时间,默认5s
@property(nonatomic,assign)NSInteger  timeOut;

/// 1:打印日志 0：不打印日志,默认不打印日志
@property(nonatomic,assign,getter=islog)BOOL log;

/// 设置缓存数据的长度
@property(nonatomic,assign)NSInteger bufferDataLenght;

/// 网络的阈值
@property(nonatomic,assign)MODE_Threshold  networkThreshold;

@property (nonatomic, copy) NSString *audioSessionCategory;

/// 播放器当前的播放状态
@property(nonatomic,assign,readonly)BOOL isPlayerPlaying;

/// 是否需要合成info,默认为NO
@property(nonatomic,assign)BOOL isNeedSynInfo;

/// 获取合成器的唯一实例
+ (DBMixSynthesizer *)shareInstance;

// 释放合成器的唯一实例
+ (void)releaseInstance;

// sdk的版本号
+ (NSString *)sdkVersion;

/// 设置授权的相关信息
/// @param clientId apiKey
/// @param clientSecret apiSecret
/// @param messageHandler 回调的信息
- (void)onlineSetupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret messageHander:(DBMessagHandler)messageHandler;


/// 离线的授权信息
/// @param offClientId 离线授权的clientId
/// @param offClientSecret 离线授权的clientSecret
/// @param messageHandler 离线的信息回调
- (void)offlineSetupClientId:(NSString *)offClientId clientSecret:(NSString *)offClientSecret ttsModel:(tts_model)ttsModel messageHander:(DBMessagHandler)messageHandler;


/// 设置离线合成模型的路径，设置离线合成的参数之前需要先设置模型的dataPath, speechPath,和voiceArray,后端文件+模型文件可以进行合成
/// @param dataPath 前端文件的路径
/// @param voiceArray 声音模型的列表,后端文件+ 发音人文件
- (NSInteger)setDataPath:(NSString *)dataPath frontPath:(NSString *)frontPath voiceArray:(NSArray<DBOfflineSpeechModel*> *)voiceArray;

/// 设置合成的参数
/// @param param 参数
/// @param key 合成的key
-(NSError*)setSynthParam:(id)param forKey:(DBSynthesizerParamKey)key;

/// 获取合成设置的参数
/// @param key 参数设置的key
/// @param err 错误信息
-(id)getSynthParamforKey:(DBSynthesizerParamKey)key withError:(NSError**)err;

/// 设置在线合成的参数
/// @param param  设置合成参数的对象
/// @param error 错误
- (void)setOnlineSynthesisParams:(DBSynthesizerRequestParam *)param withError:(NSError **)error;
/// 合成并播放句子
/// @param sentence 合成的句子
/// @param err 错误提示
-(NSInteger)speakSentence:(NSArray *)sentence withError:(NSError**)err;

/// 仅仅合成句子
/// @param sentence 要合成的句子
/// @param err 错误提示
-(NSInteger)synthesizeSentence:(NSArray *)sentence withError:(NSError**)err;


///  停止合成和朗读
- (void)stop;

/// 继续朗读
- (int)resume;

/// 暂停朗读
- (int)pause;

// 清除本地的授权信息，仅测试的时候使用
+ (BOOL)clearUserAuthInfo;

@end

NS_ASSUME_NONNULL_END
