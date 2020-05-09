//
//  DBNetworkHelper.m
//  DBFlowTTS
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import "DBNetworkHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DBNetworkHelper

+ (instancetype)shareInstance {
    static DBNetworkHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBNetworkHelper alloc]init];
    });
    return instance;
}


//GET请求
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(DBSuccessBlock)successBlock failure:(DBFailureBlock)failureBlock
{
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:url];
    if ([parameters allKeys]) {
        [mutableUrl appendString:@"?"];
        for (id key in parameters) {
            NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEnCode]];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failureBlock(error);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];
}

//POST请求 使用NSMutableURLRequest可以加入请求头
- (void)postWithUrlString:(NSString *)url headerDict:(NSDictionary *)headerParameters parameters:(id)parameters success:(DBSuccessBlock)successBlock failure:(DBFailureBlock)failureBlock
{
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];    
    //设置请求类型
    request.HTTPMethod = @"POST";
    
    // 固定参数
    [request setValue:@"1.0" forHTTPHeaderField:@"version"];// 版本号
    
    // 通过header返回的参数
    for (NSString *key in headerParameters) {
        [request setValue:headerParameters[key] forHTTPHeaderField:key];
    }
    
    // 签名相关
    NSMutableDictionary * headerDic = [[NSMutableDictionary alloc]init];
    NSString * unixTime = [self getUnixTime];
    NSString * nounce = [self getNounce];
    [request setValue:unixTime forHTTPHeaderField:@"timestamp"];//10位的UNIX时间戳
    [request setValue:nounce forHTTPHeaderField:@"nounce"];// 6位的随机数
    [request setValue:[self getSignature:headerDic] forHTTPHeaderField:@"signature"];//版本
    
    NSLog(@"POST-Header:%@",request.allHTTPHeaderFields);
    
    //把参数放到请求体内
    NSString *postStr = [DBNetworkHelper parseParams:parameters];
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            failureBlock(error);
        } else {  //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];  //开始请求
}

//重新封装参数 加入app相关信息
+ (NSString *)parseParams:(NSDictionary *)params
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    [parameters setValue:@"ios" forKey:@"client"];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];//ios系统版本号
    NSString *system = [NSString stringWithFormat:@"%@", phoneVersion];
    [parameters setValue:system forKey:@"system"];
    NSDate *date = [NSDate date];
    NSTimeInterval timeinterval = [date timeIntervalSince1970];
    [parameters setObject:[NSString stringWithFormat:@"%.0lf",timeinterval] forKey:@"auth_timestamp"];//请求时间戳
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
   //加密处理 将所有参数加密后结果当做参数传递
   //parameters = @{@"i":@"加密结果 抽空加入"};
    NSEnumerator *keyEnum = [parameters keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}

// MARK: Private Methods
- (NSString *)getNounce {
    int a = arc4random() % 100000;
    NSString *str = [NSString stringWithFormat:@"%06d", a];
    return str;
}

- (NSString *)getUnixTime {
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    long long int currentTime = (long long int)time;
    NSString *unixTime = [NSString stringWithFormat:@"%llu", currentTime];
    return unixTime;
    
}

- (NSString *)getSignature:(NSMutableDictionary*) params{
    
    NSArray *keyArray = [params allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[params objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    sign = [NSString stringWithFormat:@"%@&v1",sign];
    sign = [self MD5ForLower32Bate:sign];
    if ([self isBlank:sign]) {
        NSString *occurrencesString = @"s";
        NSRange range = [sign rangeOfString:occurrencesString];
        sign = [sign stringByReplacingCharactersInRange:range withString:@"b"];
    }
    sign = [NSString stringWithFormat:@"%@%@",sign,params[@"nounce"]];
    sign = [self MD5ForLower32Bate:sign];
    return sign;
}
- (BOOL)isBlank:(NSString *)str{
    NSRange _range = [str rangeOfString:@"s"];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

-(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}


@end
