//
//  DBSpeechSynthesizerDelegate.h
//  DBSpeechSynthesizer
//
//  Created by 标贝 on 16-08-10.
//  Copyright (c) 2016年 标贝. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBSpeechSynthesizer;

@protocol DBSpeechSynthesizerDelegate <NSObject>

@optional
/**
 * @brief 合成器开始工作
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerStartWorking:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 合成器完成工作
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerEndWorking:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 合成器开始朗读
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerSpeechStart:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 新的语音数据已经合成
 *
 * @param speechSynthesizer 合成器对象
 * @param newData 语音数据
 * @param lastDataFlag 是否是最后一段数据
 */
- (void)synthesizerNewDataArrived:(DBSpeechSynthesizer *)speechSynthesizer data:(NSData *)newData isLastData:(BOOL)lastDataFlag;

/**
 * @brief 缓冲进度已更新
 *
 * @param speechSynthesizer 合成器对象
 * @param newProgress 已缓冲的进度，取值范围[0.0, 1.0]
 */
- (void)synthesizerBufferProgressChanged:(DBSpeechSynthesizer *)speechSynthesizer progress:(float)newProgress;

/**
 * @brief 播放进度已更新
 *
 * @param speechSynthesizer 合成器对象
 * @param newProgress 已播放进度，取值范围[0.0, 1.0]
 */
- (void)synthesizerSpeechProgressChanged:(DBSpeechSynthesizer *)speechSynthesizer progress:(float)newProgress;

/**
 * @brief 当前已缓冲到的文本长度已更新
 *
 * @param speechSynthesizer 合成器对象
 * @param newLength 以缓冲到的文本偏移量，取值范围[0, [text length]]
 */
- (void)synthesizerTextBufferedLengthChanged:(DBSpeechSynthesizer *)speechSynthesizer length:(int)newLength;

/**
 * @brief Gives an estimation about how many characters have been spoken so far.
 *
 * @param speechSynthesizer 合成器对象
 * @param newLength 以缓冲到的文本偏移量，取值范围[0, [text length]]
 */
- (void)synthesizerTextSpeakLengthChanged:(DBSpeechSynthesizer *)speechSynthesizer length:(int)newLength;

/**
 * @brief 朗读已暂停
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerSpeechDidPaused:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 朗读已继续
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerSpeechDidResumed:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 已取消
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerDidCanceled:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 朗读完成
 *
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerSpeechDidFinished:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 合成器发生错误
 *
 * @param speechSynthesizer 合成器对象
 * @param error 错误对象
 */
- (void)synthesizerErrorOccurred:(DBSpeechSynthesizer *)speechSynthesizer error:(NSError *)error;


/**
 * @brief 合成器固定时长内合成次数
 *
 * @param synthCount 合成次数
 * @param speechSynthesizer 合成器对象
 */
- (void)synthesizerSynthCount:(NSUInteger)synthCount speechSynthesizer:(DBSpeechSynthesizer *)speechSynthesizer;

/**
 * @brief 有新的语音库可以更新
 *
 * @param speechSynthesizer 合成器对象
 * @param fileID 文件ID
 * @param fileName 文件名
 * @param fileSize 文件大小
 */
- (void)synthesizerNewSpeechDatabase:(DBSpeechSynthesizer *)speechSynthesizer fileID:(NSString *)fileID fileName:(NSString *)fileName fileSize:(int)fileSize;

@end
