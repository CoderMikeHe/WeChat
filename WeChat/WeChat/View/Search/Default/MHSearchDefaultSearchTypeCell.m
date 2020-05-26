//
//  MHSearchDefaultSearchTypeCell.m
//  WeChat
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultSearchTypeCell.h"
#import "MHSearchDefaultSearchTypeItemViewModel.h"

@interface MHSearchDefaultSearchTypeCell ()

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultSearchTypeItemViewModel *viewModel;


/// RACCommand
@property (nonatomic, readwrite, strong) RACCommand *btnCmd;


@end
@implementation MHSearchDefaultSearchTypeCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchDefaultSearchTypeCell";
    MHSearchDefaultSearchTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
        
        
        
    }
    return cell;
}

- (void)bindViewModel:(MHSearchDefaultSearchTypeItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    
    
}

#pragma mark - 事件处理

- (IBAction)_btnDidClicked:(UIButton *)sender {
    [self.viewModel.searchTypeSubject sendNext:@(sender.tag)];
    
    
    [self.btnCmd execute:@0];
}

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    
    @weakify(self);
    self.btnCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
//        RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//             NSLog(@"0000000000");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSLog(@"000000000🔥");
//                [subscriber sendNext:@1];
//                [subscriber sendCompleted];
//            });
//
//            return nil;
//        }];
        
        RACSignal *signalA = [RACSignal return:@1];
        RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"11111111111");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"11111111111🔥");
                [subscriber sendNext:@2];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        
        RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"33333");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"33333🔥");
                [subscriber sendNext:@3];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        
        // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
        RACSignal *concatSignal = [signalA concat:signalB];
        
        // 以后只需要面对拼接信号开发。
        // 订阅拼接的信号，不需要单独订阅signalA，signalB
        // 内部会自动订阅。
        // 注意：第一个信号必须发送完成，第二个信号才会被激活
//        [concatSignal subscribeNext:^(id x) {
//
//            NSLog(@"xxxxxxx🔥xxx0000000  %@",x);
//
//        }];
        
        return [concatSignal concat:signalC];
        
    }];
    [self.btnCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"xxxxxxx🔥xxx0000000  %@",x);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
