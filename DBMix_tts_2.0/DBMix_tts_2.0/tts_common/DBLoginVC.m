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
#import "DBUserInfoManager.h"
#import <DBMixtTTS3SDK/DBMixSynthesizer.h>
//#import "DBAuthentication.h"


typedef NS_ENUM(NSInteger,DBAudioSDKType) {
    DBAudioSDKTypeOnlineTTS = 1, // online tts
    DBAudioSDKTypeOneSpeechASR , // one speech asr
    DBAudioSDKTypeLongTimeASR, // long time asr
    DBAudioSDKTypeVoiceTransfer, // voice transfer
    DBAudioSDKTypeVoiceEngraver, // voice Engraver
};

//#error  请联系标贝科技获取clientId 和clientSecret
static  NSString *onClientId = @"xxx";
static  NSString *onClientSecret = @"xxx";

static  NSString *offClientId = @"xxx";
static  NSString *offClientSecret = @"xxx";


@interface DBLoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *onlineClientIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *onlineClientSecretTextField;
@property (weak, nonatomic) IBOutlet UITextField *offlineClientIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *offlineClientSecretTextField;
@property(nonatomic,strong)NSArray * textFieldArray;
@property(nonatomic,strong)dispatch_semaphore_t semaphore;
@property(nonatomic,assign)BOOL  needKeyBoardChange;
@end

@implementation DBLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//  MARK: Test author
    self.onlineClientIdTextField.text =onClientId;
    self.onlineClientSecretTextField.text = onClientSecret;
    self.offlineClientIdTextField.text = offClientId;
    self.offlineClientSecretTextField.text = offClientSecret;
    NSArray *array = @[self.onlineClientIdTextField,self.onlineClientSecretTextField,self.offlineClientIdTextField,self.offlineClientSecretTextField];
    for (UITextField * textField in array) {
        textField.delegate = self;
    }
    self.textFieldArray = array;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    self.semaphore = dispatch_semaphore_create(1);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (IBAction)loginAction:(id)sender {
    if (self.onlineClientIdTextField.text.length <= 0) {
        [self.view makeToast:@"请输入onlineClientId" duration:2 position:CSToastPositionCenter];
        return ;
    }
    if (self.onlineClientIdTextField.text.length <= 0 ) {
        [self.view makeToast:@"请输入onlineClientSecret" duration:2 position:CSToastPositionCenter];
        return ;
    }
    if (self.offlineClientIdTextField.text.length <= 0) {
        [self.view makeToast:@"请输入offlineClientId" duration:2 position:CSToastPositionCenter];
        return ;
    }
    if (self.offlineClientSecretTextField.text.length <= 0 ) {
        [self.view makeToast:@"请输入offlineClientSecret" duration:2 position:CSToastPositionCenter];
        return ;
    }
   
    for (UITextField *textfield in self.textFieldArray) {
        NSString *text = [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        textfield.text = text;
    }
    
    DBMixSynthesizer * _synthesizerManager = [DBMixSynthesizer shareInstance];
    DBUserInfoManager * userInfoManager= [DBUserInfoManager shareManager];
    userInfoManager.onlineClientId = self.onlineClientIdTextField.text;
    userInfoManager.onlineClientSecret = self.onlineClientSecretTextField.text;
    userInfoManager.offlineClientId = self.offlineClientIdTextField.text;
    userInfoManager.offlineClientSecret = self.offlineClientSecretTextField.text;
    
    [[XCHudHelper sharedInstance] showHudOnView:self.view caption:@"" image:nil acitivity:YES autoHideTime:0];
// xn
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [_synthesizerManager onlineSetupClientId:userInfoManager.onlineClientId clientSecret:userInfoManager.onlineClientSecret messageHander:^(NSInteger ret, NSString * _Nonnull message) {
            dispatch_semaphore_signal(self.semaphore);
            if (ret != 0) {
                NSLog(@"[error -- online] 获取合成的token失败");
                return;
            }
    //        _synthesizerToken = message;
    //        [self setupOnlineSynthesisParams];
            NSLog(@"在线鉴权成功");
        }];
        /// 离线的鉴权信息
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [_synthesizerManager offlineSetupClientId:userInfoManager.offlineClientId clientSecret:userInfoManager.offlineClientSecret ttsModel:tts_model_2 messageHander:^(NSInteger ret, NSString * _Nonnull message) {
            dispatch_semaphore_signal(self.semaphore);
            if (ret != 0) {
                NSLog(@"[error -- offline]鉴权失败-code:%@-msg:%@",@(ret),message);
                return ;
            };
            NSLog(@"离线鉴权成功");
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XCHudHelper sharedInstance] hideHud];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITextField *textField in self.textFieldArray) {
        [textField resignFirstResponder];
    }
//    [self.clientIdTextField resignFirstResponder];
//    [self.clientSecretTextField resignFirstResponder];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
  
  //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    //执行动画
    if (self.needKeyBoardChange) {
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y = transformY;
            self.view.frame = rect;
        }];
    }else {
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y = 0;
            self.view.frame = rect;
        }];
    }
    
   
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.frame.origin.y < 400) {
        self.needKeyBoardChange = NO;
        return;
    }
    
    self.needKeyBoardChange = YES;
}


- (IBAction)clearAuthInfo:(id)sender {
    [DBMixSynthesizer clearUserAuthInfo];
}



@end
