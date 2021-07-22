//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "DBOfflineTTSPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <DBTTSOfflineSDK/DBOfflineSynthesizer.h>
#import "TTSConfig.h"
#import "DBTTSSettingTableViewController.h"


//static NSString *  textViewText = @"语音编码指语音数据存储和传输的方式。";

static NSString * textViewText = @"标贝（北京）科技有限公司专注于智能语音交互，包括语音合成整体解决方案，并提供语音合成、语音识别、图像识别等人工智能数据服务 。帮助客户实现数据价值，以推动技术、应用和产业的创新  。帮助企业盘活大数据资源，挖掘数据中有价值的信息。主要提供智能语音交互相关服务，包括语音合成整体解决方案，以及语音合成、语音识别、图像识别等人工智能数据服务。标贝科技在范围内有数据采集、处理团队，可以满足在不同地区收集数据的需求。以语音数据为例，可采集、加工普通话、英语、粤语、日语、韩语及方言等各类数据，以支持客户进行语音合成或者语音识别系统的研发工作 。";

@interface DBOfflineTTSPlayerVC ()<DBSynthesisPlayerDelegate,DBSynthesizerDelegate,DBSynthesizerSettingDelegate,UITextViewDelegate>
/// 合成管理类
@property(nonatomic,strong)DBOfflineSynthesizer * synthesizerManager;
/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// 展示回调状态
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property(nonatomic,copy)NSDictionary * voiceDictionary;
@property(nonatomic,copy)NSArray * voiceArray;
@property(nonatomic,strong)NSString * offlineSpeaker;
@property(nonatomic,strong)UIButton * lastSlectedButton;
@property (weak, nonatomic) IBOutlet UILabel *synthesizerStateLabel;

@property(nonatomic,strong)NSThread * syntheProgressThread;

@property (strong, nonatomic) IBOutlet UILabel *playStatusLabel;

@property(nonatomic,assign)CGFloat  totalData;

@end

@implementation DBOfflineTTSPlayerVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopAction];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.playStatusLabel.text = @"";
    if (!self.needPlayer) {
        self.playButton.hidden = YES;
        self.playStatusLabel.text = @"";
        self.playStatusLabel.hidden = YES;
        self.totalData = 0;
    }
    
    [self addBorderOfView:self.textView];
    self.textView.text = textViewText;
   self.voiceArray = @[@"标准女声",@"甜美女声",@"标准男声",@"磁性男声",@"小君儿童"];
    self.voiceDictionary = @{@"标准女声":tts_back_ch_standard, @"甜美女声":tts_back_ch_hts_sweet, @"标准男声":tts_back_ch_standard_male_voice, @"磁性男声":tts_back_ch_magnetic_male_voice, @"小君儿童":tts_back_ch_xiaojun};
    _synthesizerManager = [DBOfflineSynthesizer instance];
    _synthesizerManager.delegate = self;
    _synthesizerManager.playerDelegate = self;
    self.offlineSpeaker = self.voiceArray[1];
    [self setupSpeechDataModel:self.voiceDictionary[self.offlineSpeaker]];
    if (!_synthesizerPara) {
        _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    }
    _synthesizerManager.bufferDataLenght = 200;
    //设置打印日志
     _synthesizerManager.log = YES;
}

- (void)setupSpeechDataModel:(NSString *)speakerName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tts_entry_1.0.0_release_front_chn_eng_arm_18121801" ofType:@"dat"];
    NSString *speechName = [speakerName componentsSeparatedByString:@"."].firstObject;
    NSString *speechPath = [[NSBundle mainBundle] pathForResource:speechName ofType:@"dat"];
    [_synthesizerManager setDataPath:path speechPath:speechPath];
}


- (void)handleSelcetVoiceAction:(UIButton *)sender {
    if (self.lastSlectedButton == sender) {
        return ;
    }else {
        self.lastSlectedButton.selected = NO;
        self.lastSlectedButton = sender;
    }
    [self stopAction];
    sender.selected = !sender.isSelected;
    NSString *voice = sender.titleLabel.text;
    NSString *offlineVoice = self.voiceDictionary[voice];
    [self setupSpeechDataModel:offlineVoice];

}
// MARK: IBActions

- (IBAction)startAction:(UIButton* )sender {
    if (sender.isSelected == NO) {
        [self startAction];
    }else {
        [self stopAction];
    }
}
- (void)startAction {
    // 先清除之前的数据
    [self resetPlayState];
    _synthesizerPara.audioType = DBTTSAudioTypePCM16K;
    _synthesizerPara.speaker = @"Jingjing";
    _synthesizerPara.text = self.textView.text;
    _synthesizerPara.language = DBlanguageTypezh;
    // 设置合成参数
    NSInteger code = [self.synthesizerManager setSynthesizerParams:self.synthesizerPara];
    if (code != 0) {// 开始合成
        NSLog(@"设置参数错误：%@",@(code));
    }
    [self.synthesizerManager startPlayISNeedSpeaker:self.needPlayer];
    self.startButton.selected = YES;
}


- (void)stopAction {
    [self.synthesizerManager stop];
    [self resetPlayState];
    [self resetSyntheLabelState];
    
    if (![self.syntheProgressThread isCancelled]) {
        [self.syntheProgressThread cancel];
    }
    self.startButton.selected = NO;

}

///  重置播放器播放控制状态
- (void)resetPlayState {
    if (self.playButton.isSelected) {
        self.playButton.selected = NO;
    }
    if (!self.needPlayer) {
        self.totalData = 0.f;
    }
    self.playStatusLabel.text = @"";
}

- (IBAction)playAction:(UIButton *)sender {

    if (self.startButton.isSelected == NO) { // 如果未开启播放，点击无效
        return;
    }
    
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self.synthesizerManager resume];
    }else {
        [self.synthesizerManager pause];
    }
}
- (IBAction)playState:(id)sender {
    NSString *message;
    if (self.synthesizerManager.isPlayerPlaying) {
        message = @"正在播放";
    }else {
        message = @"播放暂停";
    }
    [self appendLogMessage:message];
    
}

- (void)onSynthesisCompleted {
//    [self appendLogMessage:@"合成完成"];
    if (!self.needPlayer) {
        [self appendLogMessage:@"合成完成"];
        self.startButton.selected = NO;
    }
    NSLog(@"%s",__func__);

}

- (void)onSynthesisStarted {
 // [self appendLogMessage:@"开始合成"];
    NSLog(@"%s",__func__);

}
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
    
    if (endFlag) {
        [self appendLogMessage:[NSString stringWithFormat:@"合成完成"]];
    }
    
    if (!self.needPlayer) {
        [self appendLogMessage:[NSString stringWithFormat:@"合成中..."]];
        self.totalData += data.length/1024.f;
        self.synthesizerStateLabel.text = [NSString stringWithFormat:@" 共合成数据:%.1fKB",self.totalData];
    }
}

- (void)onTaskFailed:(NSError *)error  {
    NSLog(@"失败 %@",error.description);
    [self appendLogMessage:[NSString stringWithFormat:@"失败 %@",error.description]];
    NSLog(@"%s",__func__);
}

//MARK:  UITextViewDelegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
}

//MARK: player Delegate

- (void)readlyToPlay {
    [self appendLogMessage:@"准备就绪"];
    NSLog(@"%s",__func__);
}

- (void)playFinished {
    [self appendLogMessage:@"播放结束"];
    [self resetSyntheLabelState];
    [self resetPlayState];
    self.playButton.selected = NO;
    self.startButton.selected = NO;
    NSLog(@"%s",__func__);
}

- (void)playPausedIfNeed {
    self.playButton.selected = NO;
    [self appendLogMessage:@"暂停"];
    NSLog(@"%s",__func__);
}

- (void)playResumeIfNeed  {
    self.playButton.selected = YES;
    [self appendLogMessage:@"播放"];
    NSLog(@"%s",__func__);
}

- (void)playerNeedSynthesizerText:(NSInteger)textCount playerCanBuffer:(NSInteger)bufferLength {
    self.synthesizerStateLabel.text = [NSString stringWithFormat:@"待合成文本段数：%@  待播放buffer:%@KB",@(textCount),@(bufferLength)];
    NSLog(@"%s",__func__);
}
- (void)resetSyntheLabelState {
    if (self.needPlayer) {
        self.synthesizerStateLabel.text = [NSString stringWithFormat:@"待合成文本段数：%@  待播放buffer:%@KB",@(0),@(0)];
    }
    
}

// MARK: DBSynthesizerSettingDelegate --

- (void)updateOfflineSpeaker:(NSString *)offlineSpeaker {
    NSString *offlineVoice = self.voiceDictionary[offlineSpeaker];
    self.offlineSpeaker = offlineSpeaker;
    [self setupSpeechDataModel:offlineVoice];
    NSLog(@"选中了发音人：%@",offlineSpeaker);
}

// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}

- (void)appendLogMessage:(NSString *)message {
    self.playStatusLabel.hidden = NO;
    self.playStatusLabel.text = message;
}

// MARK: Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DBTTSSettingTableViewController *desVC = [segue destinationViewController];
    desVC.synthesizerPara = self.synthesizerPara;
    desVC.settingDelegate = self;
    desVC.offLineSpeaker = self.offlineSpeaker;
    desVC.voiceArray = self.voiceArray;
}
@end
