//
//  DBSynthesisPlayerDelegate.h
//  WebSocketDemo
//
//  Created by linxi on 2020/11/24.
//  Copyright © 2020 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DBSynthesisPlayerDelegate <NSObject>

@optional

/// 准备好了，可以开始播放的回调
- (void)readlyToPlay;

/// 播放完成回调
- (void)playFinished;

/// 播放开始回调-- 暂时没用
- (void)playResumeIfNeed;

/// 播放暂停回调 -- 暂时没用
- (void)playPausedIfNeed;

/// 播放失败的回调
- (void)playerCallBackFaiure:(NSError *)failureModel;

/// 回调当前合成文本的长度和播放器可以播放的buffer长度；
- (void)playerNeedSynthesizerText:(NSInteger)textCount playerCanBuffer:(NSInteger)bufferLength;

@end

NS_ASSUME_NONNULL_END
