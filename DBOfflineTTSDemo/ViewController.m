//
//  ViewController.m
//  DBVoiceEngraverDemo
//
//  Created by linxi on 2020/3/2.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "ViewController.h"
#import <DBTTSOfflineSDK/DBOfflineSynthesizerManager.h>
#import "UIView+Toast.h"
#import "DBLoginVC.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:clientIdKey];
    NSString *clientSecret = [[NSUserDefaults standardUserDefaults] objectForKey:clientSecretKey];
    
    if (!clientSecret || !clientId) {
        [self showLoginVC];
    }else {
        [[DBOfflineSynthesizerManager instance] setupClientId:clientId clientSecret:clientSecret successHandler:^{
            NSLog(@"初始化SDK成功");
        } failureHander:^(DBFailureModel * _Nonnull error) {
            [self showLoginVC];
    }];
}
}

- (void)showLoginVC {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DBLoginVC *loginVC  =   [story instantiateViewControllerWithIdentifier:@"DBLoginVC"];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}

// MARK: DBVoiceEngraverDelegate

//- (void)onErrorCode:(NSInteger)errorCode errorMsg:(NSString *)errorMsg {
//    [self.view makeToast:[NSString stringWithFormat:@"%@:%@",@(errorCode),errorMsg] duration:2 position:CSToastPositionCenter];
//}



@end
