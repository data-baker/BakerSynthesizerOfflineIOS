//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "DBOfflineTTSNormalVC.h"
#import <DBTTSOfflineSDK/DBOfflineSynthesizerManager.h>
#import <DBTTSOfflineSDK/DBSynthesisPlayer.h>
#import <DBTTSOfflineSDK/TTSConfig.h>
#import <AVFoundation/AVFoundation.h>


static NSString *  textViewText = @"标贝（北京）科技有限公司专注于智能语音交互，包括语音合成整体解决方案，并提供语音合成、语音识别、图像识别等人工智能数据服务。帮助客户实现数据价值，以推动技术、应用和产业的创新。帮助企业盘活大数据资源，挖掘数据中有价值的信息  。主要提供智能语音交互相关服务，包括语音合成整体解决方案，以及语音合成、语音识别、图像识别等人工智能数据服务。 标贝科技在范围内有数据采集、处理团队，可以满足在不同地区收集数据的需求。以语音数据为例，可采集、加工普通话、英语、粤语、日语、韩语及方言等各类数据，以支持客户进行语音合成或者语音识别系统的研发工作";

//NSString * textViewText = @"近期，天津市宝坻区某百货大楼内部，相继出现了5例新型冠状病毒感染的肺炎病例。";

@interface DBOfflineTTSNormalVC ()<DBSynthesizerDelegate,UITextViewDelegate>
/// 合成管理类
@property(nonatomic,strong)DBOfflineSynthesizerManager * synthesizerManager;
/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableString * textString;

/// 展示回调状态
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;

@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property(nonatomic,strong)NSDictionary * voiceDictionary;
@property(nonatomic,strong)UIButton * lastSlectedButton;

@end

@implementation DBOfflineTTSNormalVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.synthesizerManager refreshAuthoreInfoIfNeed];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.textString = [textViewText mutableCopy];
    self.displayTextView.text = @"";
    [self addBorderOfView:self.textView];
    [self addBorderOfView:self.displayTextView];
    self.textView.text = textViewText;
    // 1.初始化OfflineSynthesizerManager类，得到DBSynthesizerManager的实例。
    _synthesizerManager = [DBOfflineSynthesizerManager instance];
    // 2.注册成为DBSynthesizerDelegate的回调者。
    _synthesizerManager.delegate = self;
// 设置DBSynthesizerRequestParam合成参数
    if (!_synthesizerPara) {
           _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
       }
       self.voiceDictionary = @{@"标准女声":tts_back_ch_standard, @"甜美女声":tts_back_ch_hts_sweet, @"标准男声":tts_back_ch_standard_male_voice, @"磁性男声":tts_back_ch_magnetic_male_voice, @"小君儿童":tts_back_ch_xiaojun};
       [self configureView:self.voiceView addVoiceNameButtonWithArray:self.voiceDictionary.allKeys];

    //设置打印日志
     _synthesizerManager.log = YES;    
}

// 按钮的点击事件
- (void)handleSelcetVoiceAction:(UIButton *)sender {
    if (self.lastSlectedButton == sender) {
        return ;
    }else {
        self.lastSlectedButton.selected = NO;
        self.lastSlectedButton = sender;
    }
    [self closeAction:nil];
    sender.selected = !sender.isSelected;
    NSString *voice = sender.titleLabel.text;
    self.synthesizerPara.speaker = self.voiceDictionary[voice];
}


//  初始化按钮位置
- (void)configureView:(UIView *)voiceNameView addVoiceNameButtonWithArray:(NSArray *)array {
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        if (idx == 0) {
            self.lastSlectedButton = button;
            self.lastSlectedButton.selected = YES;
            self.synthesizerPara.speaker = [self.voiceDictionary objectForKey:array[idx]];
        }
        
        CGFloat space = 15;
        CGFloat margin = 30;
        NSInteger maskCols =4;
        NSInteger rows = (idx) / maskCols;
        NSInteger cols = idx % maskCols;
        CGFloat availableSpace = self.view.frame.size.width - margin*2 - (cols -1)*space;
        CGFloat width = availableSpace/maskCols;
        CGFloat  height = 20;
        button.frame = CGRectMake(margin + (width +space)* cols, rows*(space + height), width, height);
        [button setTitle:array[idx] forState:UIControlStateNormal];
        button.tag = 100+idx;
        [button addTarget:self action:@selector(handleSelcetVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
        [voiceNameView addSubview:button];
    }];
}


// MARK: IBActions

- (IBAction)startAction:(id)sender {
    // 先清除之前的数据
    self.displayTextView.text = @"";
    if (!_synthesizerPara) {
        _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    }
    _synthesizerPara.audioType = DBTTSAudioTypePCM16K;
    _synthesizerPara.text = self.textView.text;
    // 设置合成参数
    NSInteger code = [self.synthesizerManager setSynthesizerParams:self.synthesizerPara];
    if (code == 0) {
        // 开始合成
        [self.synthesizerManager start];
    }
}
- (IBAction)closeAction:(id)sender {
    [self.synthesizerManager stop];
    self.displayTextView.text = @"";

}




- (void)onSynthesisCompleted {
    [self appendLogMessage:@"合成完成"];
}

- (void)onSynthesisStarted {
    [self appendLogMessage:@"开始合成"];

}
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
    static NSInteger count = 0;
    count++;
    if (count == 10) {
        [self appendLogMessage:[NSString stringWithFormat:@"收到合成回调的数据 dataLength:%@ endFlag:%@",@(data.length),@(endFlag)]];
        count=0;
    }
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    NSLog(@"合成播放失败 %@",failreModel);
    [self appendLogMessage:[NSString stringWithFormat:@"合成播放失败 %@",failreModel.message]];
}

//MARK:  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:textViewText]&&textView == self.textView) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
    if (self.displayTextView.isFirstResponder) {
        [self.displayTextView resignFirstResponder];
    }
}



// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)timeDataWithTimeCount:(CGFloat)timeCount {
    long audioCurrent = ceil(timeCount);
    NSString *str = nil;
    if (audioCurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(audioCurrent/60.f)),lround(floor(audioCurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(audioCurrent/3600.f)),lround(floor(audioCurrent%3600)/60.f),lround(floor(audioCurrent/1.f))%60];
    }
    return str;
    
}

- (void)appendLogMessage:(NSString *)message {
    NSString *text = self.displayTextView.text;
    NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",message]];
    self.displayTextView.text = appendText;
    [self.displayTextView scrollRangeToVisible:NSMakeRange(self.displayTextView.text.length, 1)];
}


@end
