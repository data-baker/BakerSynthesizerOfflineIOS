//
//  DBTTSEnumerate.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 newbike. All rights reserved.
//

#ifndef DBTTSEnumerate_h
#define DBTTSEnumerate_h

typedef NS_ENUM(NSUInteger, DBTTSAudioType){
    DBTTSAudioTypePCM16K=4, // 返回16K采样率的pcm格式
    DBTTSAudioTypePCM8K, // 返回8K采样率的pcm格式
};

typedef NS_ENUM(NSUInteger, DBTTSRate) {
    DBTTSRate8k = 1,
    DBTTSRate16k,
};

typedef NS_ENUM(NSUInteger,DBlanguageType) {
    DBlanguageTypeChinese, // 中文
    DBlanguageTypeEnglish // 英文
};

typedef NS_ENUM(NSUInteger,DBErrorFailedCode) {
    DBErrorFailedCodeInitial = 90001, // 合成SDK初始化失败
    DBErrorFailedCodeText = 90002, // 合成文本内容为空
    DBErrorFailedCodeParameters = 90003, // 参数格式错误
    DBErrorFailedCodeResultParse = 90004, // 返回结果解析错误
    DBErrorFailedCodeSynthesis = 90005, // 合成失败，失败信息相关错误
    DBPlayerError = 90006, // 播放器相关错误
    DBErrorFailedCodeNOUID = 50000, // 离线授权没有授权信息
    DBErrorFailedCodeDeviceInsufficient = 50001, // 离线授权的设备ID不足
    DBErrorFailedCodeDeviceTooMuch = 50002, // 离线授权设备的总数超过限制
    DBErrorFailedCodeNetworkRequestBad = 50003, // 网络请求失败
};

/// 离线语音合成的模型设计
typedef NS_ENUM(NSUInteger,DBOfflineSpeakType){
    DBOfflineSpeakTypeCallBack = 0,
    DBOfflineSpeakTypeVolume,//音量
    DBOfflineSpeakTypeSpeed,//语速
    DBOfflineSpeakTypeDataPath, //模型文件相对mainBundle的路径
    DBOfflineSpeakTypeUserdict,//字典文件
    DBOfflineSpeakTypeSpeaker//发音人（唯一关联语言、性别、音色）
};



#endif /* DBTTSEnumerate_h */
