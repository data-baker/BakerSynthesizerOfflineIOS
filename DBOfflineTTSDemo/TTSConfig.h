//
//  TTSConfig.h
//  SpeechSynthesizer
//
//  Created by linxi on 2019/5/11.
//  Copyright © 2019年 biaobei. All rights reserved.
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
