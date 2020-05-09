//
//  TTSConfig.h
//  SpeechSynthesizer
//
//  Created by jiazhaoyang on 2017/5/11.
//  Copyright © 2017年 DiDi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSConfig : NSObject

extern  NSString * VERSION;

extern  NSString  * TEXT_DAT_FILE_PATH;

// 后端文件,默认的文件
/// 磁性男声
extern NSString  * tts_back_ch_magnetic_male_voice;

/// 标准男声
extern NSString  * tts_back_ch_standard_male_voice;

/// 小君儿童画
extern NSString  * tts_back_ch_xiaojun;

/// 甜美女声
extern NSString  * tts_back_ch_hts_sweet;

/// 标准女声
extern NSString  * tts_back_ch_standard ;

@end
