//
//  DBTextSplitUtil.h
//  DBFlowTTS
//
//  Created by linxi on 2019/12/11.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBTextSplitUtil : NSObject

/// 采用默认的切割长度200
/// @param allText 总文本
- (NSArray *)splitTextArrayWithAllText:(NSString *)allText;

/// 切割文本
/// @param allText 文本的总长度
/// @param chunkLength chunk的长度
- (NSArray *)splitTextArrayWithAllText:(NSString *)allText chunkLength:(NSUInteger)chunkLength;
@end

NS_ASSUME_NONNULL_END
