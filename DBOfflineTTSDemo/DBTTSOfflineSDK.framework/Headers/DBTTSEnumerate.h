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

// ret:0 成功，其他值为失败，Mess:为信息
typedef void (^DBMessagHandler)(NSInteger ret, NSString *message);


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
    DBErrorFailedCodeInitial = 18190001, // 合成SDK初始化失败
    DBErrorFailedCodeText = 18190002, // 合成文本内容为空
    DBErrorFailedCodeParameters = 18190003, // 参数格式错误
    DBErrorFailedCodeResultParse = 18190004, // 返回结果解析错误
    DBErrorFailedCodeSynthesis = 18190005, // 合成失败，失败信息相关错误
    DBErrorFailedCodeNOUID = 18150000, // 离线授权没有授权信息
    DBErrorFailedCodeDeviceInsufficient = 18150001, // 离线授权的设备ID不足
    DBErrorFailedCodeDeviceTooMuch = 18150002, // 离线授权设备的总数超过限制
    DBErrorFailedCodeNetworkRequestBad = 18150003, // 网络请求失败
    DBErrorFailedCodeNetworkGetTokenFailed = 18150004, // 获取token失败
    DBErrorFailedCodeDeviceInfoInvalid = 18150005 // 设备信息


};

typedef NS_ENUM(NSUInteger,DBPlayer) {
    DBPlayerNotInitPlayError = 18191001 , // 播放器未初始化播放错误
    DBPlayerWorkingError = 18190006, // 播放器相关错误

};

typedef NS_ENUM(NSUInteger,DBSynthesizer) {
    DBSynthesizerNotInitSynthesizerError = 18192001, // 合成引擎未初始化
 DBSynthesizerOnlineSudioDataTransferError = 18192002 // 在线合成音频数据转换错误
};




/// 离线语音合成的模型设计
typedef NS_ENUM(NSUInteger,DBOfflineSpeakType) {
    DBOfflineSpeakTypeCallBack = 0,
    DBOfflineSpeakTypeVolume,//音量
    DBOfflineSpeakTypeSpeed,//语速
    DBOfflineSpeakTypeDataPath, //模型文件相对mainBundle的路径
    DBOfflineSpeakTypeUserdict,//字典文件
    DBOfflineSpeakTypeSpeaker,//发音人（唯一关联语言、性别、音色）
    DBOfflineSpeakTypeAudioType  // audioType;
};





typedef NS_ENUM(NSUInteger,MODE_Threshold) {
    MODE_Threshold_OFFLINE// 纯离线模式
};


//typedef NS_ENUM(NSUInteger,DBAuthorState) {
//    DBAuthorStateSuccess = 1, // 授权信息成功，离在线均可使用
//    DBAuthorStateOnlyOnline =2,   // 仅支持在线
//    DBAuthorStateFailed = 3 // 均不支持
//};



#endif /* DBTTSEnumerate_h */
