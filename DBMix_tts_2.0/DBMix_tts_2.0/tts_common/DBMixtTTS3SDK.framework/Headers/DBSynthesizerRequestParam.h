//
//  DBSynthesizerRequestParam.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTTSEnumerate.h"

NS_ASSUME_NONNULL_BEGIN


// 在线合成设置的参数
@interface DBSynthesizerRequestParam : NSObject

/// 根据接口获取到的token
@property(nonatomic,copy)NSString * token;

/// 设置发音人声音名称，对应于开放平台的voice_name
@property(nonatomic,copy)NSString * speaker;

/// 合成请求文本的语言，目前支持ZH(中文和中英混)和ENG(纯英文，中文部分不会合成),默认：ZH,更多音色参考官网
@property(nonatomic,copy)NSString * language;

/// 设置播放的语速，在0～9之间（支持浮点值），不传时默认为5
@property(nonatomic,copy)NSString * speed;

/// 设置语音的音量，在0～9之间（只支持整型值），不传时默认值为5
@property(nonatomic,copy)NSString * volume;

/// 设置语音的音调，取值0-9，不传时默认为5中语调
@property(nonatomic,copy)NSString * pitch;

// 码率：可不填，不填时默认为2，取值范围1-8，配合audioType 使用
@property(nonatomic,assign)DBTTSRate rate;

///  采样率: 支持8K 和16K 的采样率
@property(nonatomic,assign)DBTTSAudioType audioType;


@end

NS_ASSUME_NONNULL_END
