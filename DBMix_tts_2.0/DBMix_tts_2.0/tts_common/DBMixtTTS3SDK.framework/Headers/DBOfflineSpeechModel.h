//
//  DBVoiceModelArray.h
//  DBMixtTTS3Demo
//
//  Created by linxi on 2022/3/3.
//  Copyright © 2022 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBOfflineSpeechModel : NSObject

/// 发音人的后端模型路径
@property(nonatomic,copy)NSString * speechBackPath;

/// 发音人的模型路径
@property(nonatomic,copy)NSString * speakerPath;

+ (instancetype)speechModelWithBackpath:(NSString *)speechBackPath speakerPath:(NSString *)speakerPath;


@end

NS_ASSUME_NONNULL_END
