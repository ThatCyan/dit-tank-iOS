//
//  ESPTankMainViewController.m
//  ESPTank
//
//  Created by 李育洋 on 2017/12/30.
//  Copyright © 2017年 李育洋. All rights reserved.
//

#import "ESPTankMainViewController.h"
#import "GCDAsyncUdpSocket.h"


@interface ESPTankMainViewController () <GCDAsyncUdpSocketDelegate>
@property (weak, nonatomic) IBOutlet UISlider *sliderLeft;
@property (weak, nonatomic) IBOutlet UISlider *sliderRight;
@property (nonatomic,assign) UInt8 leftValue;
@property (nonatomic,assign) UInt8 rightValue;
@property (nonatomic,assign) BOOL isLeftForward;
@property (nonatomic,assign) BOOL isRightForward;
@property (nonatomic,assign) float packagePersecond;
@property (nonatomic,strong) NSTimer *senderTimer;

@property (nonatomic,strong) GCDAsyncUdpSocket *udp;
@end

@implementation ESPTankMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
    _packagePersecond = 10.0f;
    _udp = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    [_udp enableBroadcast:YES error:nil];
}

- (void)setupUI {
    
    [self configSlider];
}

- (void)configSlider {
    [_sliderLeft addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_sliderLeft addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sliderLeft addTarget:self action:@selector(sliderTouchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_sliderRight addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_sliderRight addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sliderRight addTarget:self action:@selector(sliderTouchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)startTimer {
    if (_senderTimer) {
        [_senderTimer invalidate];
        _senderTimer = nil;
    }
    
    _senderTimer = [NSTimer scheduledTimerWithTimeInterval:1/_packagePersecond target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_senderTimer) {
        [_senderTimer invalidate];
        _senderTimer = nil;
    }
}

- (void)timerAction {
//    NSLog(@"\nL:%d speed :%d\nR:%d speed :%d",_isLeftForward,_leftValue,_isRightForward,_rightValue);
    [self packageData];
}

- (void)sliderTouchDown:(UISlider *)sender {
    [self startTimer];
    if ([sender isEqual:_sliderLeft]) {
        NSLog(@"左滑竿按下");
    } else {
        NSLog(@"右滑竿按下");
    }
}


- (void)sliderTouchUp:(UISlider *)sender {
    [self stopTimer];
    if ([sender isEqual:_sliderLeft]) {
        NSLog(@"左滑竿松开");
    } else {
        NSLog(@"右滑竿松开");
    }
    [self sliderGoback];
}

- (void)sliderTouchValueChanged:(UISlider *)sender {
    if (!_senderTimer) {
        return;
    }
    int value = sender.value*256 - 128;
    
    if ([sender isEqual:_sliderLeft]) {
        
        (value>=0)?(_isLeftForward=YES):(_isLeftForward=NO);
        _leftValue = abs(value);
    } else {
        (value>=0)?(_isRightForward=YES):(_isRightForward=NO);
        _rightValue = abs(value);
    }
}
- (void)sliderGoback {
    _leftValue = 0;
    _rightValue = 0;
    [_sliderLeft setValue:0.5 animated:YES];
    [_sliderRight setValue:0.5 animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)packageData {
    NSString *cmd = [NSString stringWithFormat:@"$CMD@%@@%d:%d:%d:%d@",self.devID,_isLeftForward,_leftValue,_isRightForward,_rightValue];
    NSLog(@"%@",cmd);
    [_udp sendData:[cmd dataUsingEncoding:NSUTF8StringEncoding] toHost:self.host port:self.port withTimeout:0 tag:1000];
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"%@",error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
