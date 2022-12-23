//
//  DBTTSSettingTableViewController.h
//  WebSocketDemo
//
//  Created by linxi on 2020/11/27.
//  Copyright © 2020 newbike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBMixtTTS3SDK/DBSynthesizerRequestParam.h>

//#import "DBSynthesizerRequestParam.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DBSynthesizerSettingDelegate <NSObject>
/// 设置合成的模式
/// @param mode 合成模式
- (void)updateNetworkModel:(MODE_Threshold)mode;

/// 设置离线发音人
/// @param offlineSpeaker 离线发音人
- (void)updateOfflineSpeaker:(NSString *)offlineSpeaker;

@end

@interface DBTTSSettingTableViewController : UITableViewController
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
@property(nonatomic,assign)id<DBSynthesizerSettingDelegate> settingDelegate;
@property(nonatomic,strong)NSString  * offLineSpeaker;
@property(nonatomic,copy)NSArray * voiceArray;
@property(nonatomic,assign)MODE_Threshold  networkMode;

@end

NS_ASSUME_NONNULL_END
