//
//  DBLoginVC.m
//  DBVoiceEngraverDemo
//
//  Created by linxi on 2020/3/12.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "DBLoginVC.h"
#import "UIView+Toast.h"
#import "XCHudHelper.h"
#import <DBTTSOfflineSDK/DBOfflineSynthesizerManager.h>

@interface DBLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *clientIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *clientSecretTextField;
@property(nonatomic,strong)DBOfflineSynthesizerManager * synthesizerManager;

@end

@implementation DBLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // MARK: 测试
//    self.clientIdTextField.text = @"e2d17fce-f69a-4b78-bbe5-7fef824a77c2";
//    self.clientSecretTextField.text = @"ZTZlOTMyMzAtMThlZS00M2ZjLWJhMTktYTQ2NjBhZTE3Yzk0";
}
- (IBAction)loginAction:(id)sender {
    
    if (self.clientIdTextField.text.length <= 0) {
        [self.view makeToast:@"请输入clentId" duration:2 position:CSToastPositionCenter];
        return ;
    }
    if (self.clientSecretTextField.text.length <= 0 ) {
        [self.view makeToast:@"请输入clentSecret" duration:2 position:CSToastPositionCenter];
        return ;
    }
    NSString *clientId = [self.clientIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *clientSecret = [self.clientSecretTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _synthesizerManager = [DBOfflineSynthesizerManager instance];
    //设置打印日志
    _synthesizerManager.log = YES;
    
 MBProgressHUD * hudView = [[XCHudHelper sharedInstance] showHudOnView:self.view caption:@"" image:nil acitivity:YES autoHideTime:0];
    [_synthesizerManager setupClientId:clientId clientSecret:clientSecret successHandler:^{
        [hudView hideAnimated:YES];
        [[NSUserDefaults standardUserDefaults]setObject:clientId forKey:clientIdKey];
        [[NSUserDefaults standardUserDefaults]setObject:clientSecret forKey:clientSecretKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"获取token成功");
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureHander:^(DBFailureModel * _Nonnull error) {
        [hudView hideAnimated:YES];
        NSLog(@"获取token失败:%@",error);
        NSString *msg = [NSString stringWithFormat:@"获取token失败:%@",error.description];
        [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.clientIdTextField resignFirstResponder];
    [self.clientSecretTextField resignFirstResponder];
}
@end
