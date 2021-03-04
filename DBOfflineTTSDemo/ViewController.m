//
//  ViewController.m
//  DBVoiceEngraverDemo
//
//  Created by linxi on 2020/3/2.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "ViewController.h"
#import <DBTTSOfflineSDK/DBOfflineSynthesizer.h>
#import "UIView+Toast.h"
#import "DBLoginVC.h"
#import "XCHudHelper.h"
#import "DBOfflineTTSPlayerVC.h"


@interface ViewController ()<DBSynthesizerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:clientIdKey];
    NSString *clientSecret = [[NSUserDefaults standardUserDefaults] objectForKey:clientSecretKey];
    
    if (!clientSecret || !clientId) {
        [self showLoginVC];
    }else {
        
        // MARK: 需授权成功后才能调用SDK
        MBProgressHUD * hudView = [[XCHudHelper sharedInstance] showHudOnView:self.view caption:@"请求授权中" image:nil acitivity:YES autoHideTime:0];
        [[DBOfflineSynthesizer instance] setupClientId:clientId clientSecret:clientSecret messageHander:^(NSInteger ret, NSString * _Nonnull message) {
            [hudView hideAnimated:YES];
            if (ret != 0) {
                [self showLoginVC];
            }else {
                NSLog(@"授权成功");
            }
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DBOfflineTTSPlayerVC * seg = [segue destinationViewController];
    UIButton *button = (UIButton *)sender;
    if (button.tag == 101) {
        seg.needPlayer = YES;
    }else {
        seg.needPlayer = NO;
    }
    seg.title = button.titleLabel.text;
}




@end
