//
//  DBOfflineTTSViewController.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/15.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 带播放器的离线合成播放器
@interface DBOfflineTTSPlayerVC : UIViewController

// YES: 展示播放器 NO: 不展示播放器
@property(nonatomic,assign)BOOL needPlayer;

@end

NS_ASSUME_NONNULL_END
