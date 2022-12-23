//
//  DBTextSplitUtil.m
//  DBFlowTTS
//
//  Created by linxi on 2019/12/11.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import "DBTextSplitUtil.h"

static NSString *pattern = @"，|。。。。。。|。|！|；|？|,|;|\\?|、";

static NSUInteger kChunkLength = 200;

@interface DBTextSplitUtil ()

@property(nonatomic,assign)NSUInteger  chunkLength;

@end
@implementation DBTextSplitUtil


- (NSArray *)splitTextArrayWithAllText:(NSString *)allText chunkLength:(NSUInteger)chunkLength {
    self.chunkLength = chunkLength;
    return [self splitTextArrayWithAllText:allText];
}

- (NSArray *)splitTextArrayWithAllText:(NSString *)allText {
    NSUInteger chunkLength = self.chunkLength;
    if (!chunkLength) {
        chunkLength = kChunkLength;
    }
    NSMutableString *textString = [allText mutableCopy];
    NSMutableArray *textArray = [NSMutableArray array];
    while (textString.length >= 1) {
        if (textString.length < chunkLength) {
            // 如果最后一段，直接追加内容
            [textArray addObject:textString];
            break ;
        }
        NSInteger location = [self splitText:[textString substringToIndex:chunkLength]];
        NSString *subString = [textString substringToIndex:location];
        // 如果被切割的文本长度过长，强制截取
        if (location == 0) {
            subString = [textString substringToIndex:chunkLength];
            textString =  [[textString substringFromIndex:chunkLength] mutableCopy];
        }else {
            textString = [[textString substringFromIndex:location+1] mutableCopy];
        }
        [textArray addObject:subString];
    }
    return textArray;
}

- (NSInteger)splitText:(NSString *)textString {
    NSInteger textLength = textString.length;
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray <NSTextCheckingResult *> *results =  [regex matchesInString:textString
                                                                options:0
                                                                  range:NSMakeRange(0,textLength)];
    NSRange resultRange = results.lastObject.range;
    return resultRange.location;
}



@end
