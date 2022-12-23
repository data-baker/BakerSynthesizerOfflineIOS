//
//  TTSConfig.m
//  SpeechSynthesizer
//
//  Created by linxi on 2019/5/11.
//  Copyright © 2019年 biaobei. All rights reserved.
//

#import "TTSConfig.h"

@implementation TTSConfig

 NSString * VERSION = @"1.0.0";
/// 前端文件
 NSString  * TEXT_DAT_FILE_PATH = @"tts_entry_1.0.0_release_front_chn_eng_arm_18121801.dat";

// NSString  * SPEECH_DAT_FILE_PATH = @"tts_back_ch_tongxingzhe_5k_190523.dat";

/// 后端文件,默认的文件

/// 磁性男声
 NSString  * tts_back_ch_magnetic_male_voice = @"tts_back_ch_magnetic_male_voice.dat";

/// 标准男声
NSString  * tts_back_ch_standard_male_voice = @"tts_back_ch_standard_male_voice.dat";

/// 小君儿童画
NSString  * tts_back_ch_xiaojun = @"tts_back_ch_xiaojun.dat";

/// 甜美女声
NSString  * tts_back_ch_hts_sweet = @"tts_back_ch_hts_sweet.dat";

/// 标准女声
NSString  * tts_back_ch_standard = @"tts_back_ch_standard.dat";

@end
