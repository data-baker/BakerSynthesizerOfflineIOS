//
//  DBTTSSettingTableViewController.m
//  WebSocketDemo
//
//  Created by linxi on 2020/11/27.
//  Copyright © 2020 newbike. All rights reserved.
//

#import "DBTTSSettingTableViewController.h"
//#import "SliderTableViewCell"

@interface DBTTSSettingTableViewController ()


@end

@implementation DBTTSSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"离线合成设置";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sliderCellID"];
        UISlider *slider = [cell.contentView viewWithTag:102];
        UILabel *titleLabel = [cell viewWithTag:101];
        if (indexPath.row == 0) {
            NSString *speed;
            if (!self.synthesizerPara.speed) {
                speed = @"5";
            }else {
                speed = self.synthesizerPara.speed;
            }
            
            slider.value = [speed intValue];
            titleLabel.text = [NSString stringWithFormat:@"语速%@",speed];
            
        }else if (indexPath.row == 1) {
            NSString *volume;
            if (!self.synthesizerPara.volume) {
                volume = @"5";
            }else {
                volume = self.synthesizerPara.volume;
            }
            slider.value = [volume integerValue];
            titleLabel.text = [NSString stringWithFormat:@"音量%@",volume];
        }
        
        [slider addTarget:self action:@selector(handleChangeValueAction:) forControlEvents:UIControlEventValueChanged];
        cell.contentView.tag = indexPath.row + 1000;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modelCellID"];
    cell.contentView.tag = indexPath.row + 1000;
    if (indexPath.row == 2) {
        UILabel *lable = [cell.contentView viewWithTag:201];
        UISegmentedControl *segmentControl = [cell.contentView viewWithTag:202];
        [segmentControl removeAllSegments];
        NSArray *titles = @[@"纯在线",@"纯离线",@"离在线"];
        [titles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 替换segmentControl的标题
//            if (idx > 3) {
                [segmentControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
//                return;
//            }
            [segmentControl setTitle:obj forSegmentAtIndex:idx];
        }];
        segmentControl.selectedSegmentIndex = self.networkMode;
        [segmentControl addTarget:self action:@selector(handleTapModelSegAction:) forControlEvents:UIControlEventValueChanged];
        lable.text = @"模式";
    }else if (indexPath.row == 3) {
        UILabel *lable = [cell.contentView viewWithTag:201];
        UISegmentedControl *segmentControl = [cell.contentView viewWithTag:202];
        // 修改segent的标题
        NSArray *titles = self.voiceArray;
        [segmentControl removeAllSegments];
        [titles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 替换segmentControl的标题
//            if (idx > 3) {
                [segmentControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
//                return;
//            }
            [segmentControl setTitle:obj forSegmentAtIndex:idx];
        }];
        [segmentControl addTarget:self action:@selector(handleTapSpeckerSegAction:) forControlEvents:UIControlEventValueChanged];
        segmentControl.selectedSegmentIndex = [self.voiceArray indexOfObject:self.offLineSpeaker];
        lable.text = @"离线发音";
    }
    return cell;
}

- (void)handleTapSpeckerSegAction:(UISegmentedControl *)seg {
    if (self.settingDelegate && [self.settingDelegate respondsToSelector:@selector(updateOfflineSpeaker:)]) {
        NSString *speaker = self.voiceArray[seg.selectedSegmentIndex];
        [self.settingDelegate updateOfflineSpeaker:speaker];
    }
}

- (void)handleTapModelSegAction:(UISegmentedControl *)seg {
    if (self.settingDelegate && [self.settingDelegate respondsToSelector:@selector(updateNetworkModel:)]) {
        [self.settingDelegate updateNetworkModel:seg.selectedSegmentIndex];
    }
    
    
}

- (void)handleChangeValueAction:(UISlider *)slider {
    UIView *contentView = (UIView *)slider.superview;
    if (contentView.tag - 1000 == 0) {
        UILabel *lable = [contentView viewWithTag:101];
        lable.text = [NSString stringWithFormat:@"语速%@",@(floorf(slider.value))];
        self.synthesizerPara.speed = @(ceilf(slider.value)).stringValue;
        NSLog(@"滑动了第 0 条");
    }else if (contentView.tag - 1000 == 1){
        NSLog(@"滑动了第 1 条");
        UILabel *lable = [contentView viewWithTag:101];
        lable.text = [NSString stringWithFormat:@"语音%@",@(floorf(slider.value))];
        self.synthesizerPara.volume = @(ceilf(slider.value)).stringValue;

    }
    NSLog(@"sliderValue:%@",@(slider.value));
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
