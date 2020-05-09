//
//  DBSynthesizerDelegate.h
//  DBTTSOfflineSDK
//
//  Created by linxi on 2020/2/13.
//  Copyright © 2020 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTTSEnumerate.h"
#import "DBFailureModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DBSynthesizerDelegate <NSObject>
@required
/// 开始合成
- (void)onSynthesisStarted;

/// 流式持续返回数据的接口回调
/// @param data 合成的音频数据，已使用base64加密，客户端需进行base64解密。
/// @param audioType 音频类型，如audio/pcm，audio/mp3。
/// @param interval 音频interval信息。
/// @param endFlag 是否时最后一个数据块，0：否，1：是。
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag;

/// 当onBinaryReceived方法中endFlag参数=1，即最后一条消息返回后，会回调此方法。
- (void)onSynthesisCompleted;

@optional

/// 合成的第一帧的数据已经得到l，可以在此开启播放功能；
- (void)onPrepared;

/// 合成失败 返回msg内容格式为：{"code":40000,"message":"…","trace_id":" 1572234229176271"}
- (void)onTaskFailed:(DBFailureModel *)failreModel;

@end

NS_ASSUME_NONNULL_END
