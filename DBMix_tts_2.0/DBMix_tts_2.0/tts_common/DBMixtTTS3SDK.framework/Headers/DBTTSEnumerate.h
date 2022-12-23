//
//  DBTTSEnumerate.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 newbike. All rights reserved.
//

#ifndef DBTTSEnumerate_h
#define DBTTSEnumerate_h

static NSString * const DBSynthesizerErrorDomain = @"DBSynthesizerErrorDomain";

typedef NS_ENUM(NSUInteger, DBTTSAudioType){
    DBTTSAudioTypePCM16K=4, // 返回16K采样率的pcm格式,默认16K
    DBTTSAudioTypePCM8K, // 返回8K采样率的pcm格式,离线仅支持8K
};

typedef NS_ENUM(NSUInteger, DBTTSRate) {
    DBTTSRate8k = 1,
    DBTTSRate16k,
};

typedef NS_ENUM(NSUInteger,DBlanguageType) {
    DBlanguageTypezh, // 支持中文和英文
    DBlanguageTypeEnglish // 英文
};

typedef NS_ENUM(NSUInteger,DBErrorFailedCode) {
    DBErrorFailedCodeSuccess = 0, // 请求成功
    DBErrorFailedCodeInitial = 23190001, // 合成SDK初始化失败
    DBErrorFailedCodeText = 23190002, // 合成文本内容为空
    DBErrorFailedCodeParameters = 23190003, // 参数格式错误
    DBErrorFailedCodeResultParse = 23190004, // 返回结果解析错误
    DBErrorFailedCodeSynthesis = 23190005, // 合成失败，失败信息相关错误
    DBErrorFailedCodeNOUID = 23190006, // 离线授权没有授权信息
    DBErrorFailedCodeDeviceInsufficient = 23190007, // 离线授权的设备ID不足
    DBErrorFailedCodeDeviceTooMuch = 23190008, // 离线授权设备的总数超过限制
    DBErrorFailedCodeNetworkRequestBad = 23190009, // 网络请求失败
    DBErrorFailedCodeNetworkGetTokenFailed = 23190010,// 获取token失败
    DBErrorFailedCodeNoAuthorState = 23190011, // 没有授权的相关信息
    DBErrorFailedCodeNoNoModel = 23190012, // 没有授权的模型文件
    DBErrorFailedCodeModelMatch = 23190013, // 授权的模型文件不匹配
    DBErrorFailedCodeOnlineError = 23190014 // 在线合成中途报错

};

typedef NS_ENUM(NSUInteger,DBSynthesizerError) {
    DBSynthesizerNotInitSynthesizerError = 23192001, // 合成引擎未初始化
    DBSynthesizerOnlineSudioDataTransferError = 23192002 // 在线合成音频数据转换错误
};

///// 离线语音合成的模型设计
typedef NS_ENUM(NSUInteger,DBSynthesizerParamKey) {
    DBSynthesizerParamKeyCallBack = 0,
    DBSynthesizerParamKeyVolume = 1, // 音量
    DBSynthesizerParamKeySpeed = 2, // 语速
    DBSynthesizerParamKeyLanguage = 3, // 语言
    DBSynthesizerParamKeyDataPath = 4, // 模型文件的路径
    DBSynthesizerParamKeyUserDict = 5, // 字典文件
    DBSynthesizerParamKeySpeakerId = 7, // 发音人
    DBSynthesizerParamKeyPitch = 9, //
    DBSynthesizerParamKeyAudioType = 10 // 音频类型
};
/**
 * @brief 合成器参数类型
 */


typedef NS_ENUM(NSUInteger,MODE_Threshold) {
    MODE_Threshold_ONLINE = 0, // 纯在线模式
    MODE_Threshold_OFFLINE,// 纯离线模式
    MODE_Threshold_MIX   // 有网走在线（连接成功） wifi启动在线合成
};

typedef NS_ENUM(NSUInteger,tts_model) { // 仅离线的授权时使用，在线的会自动判断
    tts_model_2 = 1, // tts的2.0
    tts_model_3 = 2  // tts的3.0
};

#endif /* DBTTSEnumerate_h */
