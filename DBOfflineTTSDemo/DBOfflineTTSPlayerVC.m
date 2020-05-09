//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "DBOfflineTTSPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <DBTTSOfflineSDK/DBOfflineSynthesizerManager.h>
#import <DBTTSOfflineSDK/DBSynthesisPlayer.h>
#import <DBTTSOfflineSDK/TTSConfig.h>

static NSString *  textViewText = @"语音编码指语音数据存储和传输的方式。请注意，语音编码和语音文件格式不同。例如常见声道是指声音在录制时在不同空间位置采集的相互独立的音频信号，所以声道数也就是声音录制时的音源数量。常见的音频数据为单声道或双声道音频采样率是指录音设备在一秒钟内对声音信号的采样次数，采样频率越高声音的还原就越真实越自然；调用语音识别服务时，您需要设置采样率参数。参数数值，您的语音数据和项目配置三者必须一致，否则识别效果会非常差。如果您的语音数据采样率高于16000Hz，需要先把采样率转换为16000Hz才能发送给语音识别服务。如果您的语音数据采样率是8000Hz的，请不要把采样率转换为16000Hz，应该在项目中选用支持8000Hz采样率的模型语音编码指语音数据存储和传输的方式。请注意，语音编码和语音文件格式不同。例如常见声道是指声音在录制时在不同空间位置采集的相互独立的音频信号，所以声道数也就是声音录制时的音源数量。常见的音频数据为单声道或双声道音频采样率是指录音设备在一秒钟内对声音信号的采样次数，采样频率越高声音的还原就越真实越自然；调用语音识别服务时，您需要设置采样率参数。参数数值，您的语音数据和项目配置三者必须一致，否则识别效果会非常差。如果您的语音数据采样率高于16000Hz，需要先把采样率转换为16000Hz才能发送给语音识别服务。如果您的语音数据采样率是8000Hz的，请不要把采样率转换为16000Hz，应该在项目中选用支持8000Hz采样率的模型";

//NSString * textViewText = @"近期，天津市宝坻区某百货大楼内部，相继出现了5例新型冠状病毒感染的肺炎病例。";

@interface DBOfflineTTSPlayerVC ()<DBSynthesisPlayerDelegate,UITextViewDelegate>
/// 合成管理类
@property(nonatomic,strong)DBOfflineSynthesizerManager * synthesizerManager;
/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableString * textString;

/// 播放器设置
@property(nonatomic,strong)DBSynthesisPlayer * synthesisDataPlayer;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// 展示回调状态
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property(nonatomic,strong)NSDictionary * voiceDictionary;
@property(nonatomic,strong)UIButton * lastSlectedButton;

@end

@implementation DBOfflineTTSPlayerVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.synthesizerManager refreshAuthoreInfoIfNeed];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self closeAction:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textString = [textViewText mutableCopy];
    self.displayTextView.text = @"";
    [self addBorderOfView:self.textView];
    [self addBorderOfView:self.displayTextView];
    self.textView.text = textViewText;
    
    
    if (!_synthesizerPara) {
        _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    }
    
    self.voiceDictionary = @{@"标准女声":tts_back_ch_standard, @"甜美女声":tts_back_ch_hts_sweet, @"标准男声":tts_back_ch_standard_male_voice, @"磁性男声":tts_back_ch_magnetic_male_voice, @"小君儿童":tts_back_ch_xiaojun};
    [self configureView:self.voiceView addVoiceNameButtonWithArray:self.voiceDictionary.allKeys];
    _synthesizerManager = [DBOfflineSynthesizerManager instance];
    //设置打印日志
     _synthesizerManager.log = YES;
    // 设置播放器
    _synthesisDataPlayer = [[DBSynthesisPlayer alloc]init];
    _synthesisDataPlayer.delegate = self;
    // 将初始化的播放器给合成器持有，合成器会持有并回调数据给player
    self.synthesizerManager.synthesisDataPlayer = self.synthesisDataPlayer;
    
}


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
// MARK: IBActions

- (IBAction)startAction:(UIButton* )sender {
    sender.enabled = NO;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         sender.enabled = YES;
     });
    // 先清除之前的数据
    [self resetPlayState];
    self.displayTextView.text = @"";
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
    [self resetPlayState];
    self.displayTextView.text = @"";

}
///  重置播放器播放控制状态
- (void)resetPlayState {
    if (self.playButton.isSelected) {
        self.playButton.selected = NO;
    }
    [self.synthesisDataPlayer stopPlay];
}

- (IBAction)playAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.synthesisDataPlayer.isReadyToPlay && self.synthesisDataPlayer.isPlayerPlaying == NO) {
        [self.synthesisDataPlayer startPlay];
    }else {
        [self.synthesisDataPlayer pausePlay];
    }
}
- (IBAction)currentPlayPosition:(id)sender {
    NSString *position = [NSString stringWithFormat:@"播放进度 %@",[self timeDataWithTimeCount:self.synthesisDataPlayer.currentPlayPosition]];
    [self appendLogMessage:position];
}
- (IBAction)getAudioLength:(id)sender {
    NSString *audioLength = [NSString stringWithFormat:@"音频数据总长度 %@",[self timeDataWithTimeCount:self.synthesisDataPlayer.audioLength]];
    [self appendLogMessage:audioLength];
}
- (IBAction)playState:(id)sender {
    NSString *message;
    if (self.synthesisDataPlayer.isPlayerPlaying) {
        message = @"正在播放";
    }else {
        message = @"播放暂停";
    }
    [self appendLogMessage:message];
}

//

- (void)onSynthesisCompleted {
//    [self appendLogMessage:@"合成完成"];
}

- (void)onSynthesisStarted {
//    [self appendLogMessage:@"开始合成"];

}
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
//    [self appendLogMessage:[NSString stringWithFormat:@"收到合成回调的数据"]];
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    NSLog(@"失败 %@",failreModel);
    [self appendLogMessage:[NSString stringWithFormat:@"失败 %@",failreModel.message]];
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

//MARK: player Delegate

- (void)readlyToPlay {
    [self appendLogMessage:@"准备就绪"];
    [self playAction:self.playButton];
}

- (void)playFinished {
    [self appendLogMessage:@"播放结束"];
    [self resetPlayState];
    self.playButton.selected = NO;
}

- (void)playPausedIfNeed {
    self.playButton.selected = NO;
    [self appendLogMessage:@"暂停"];

}

- (void)playResumeIfNeed  {
    self.playButton.selected = YES;
    [self appendLogMessage:@"播放"];
}

- (void)updateBufferPositon:(float)bufferPosition {
    static NSInteger count = 0;
    count++;
    if (count == 10) {
        [self appendLogMessage:[NSString stringWithFormat:@"缓存进度 %.0f%%",bufferPosition*100]];
        count=0;
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
