//
//  ViewController.m
//  ESPTank
//
//  Created by 李育洋 on 2017/12/30.
//  Copyright © 2017年 李育洋. All rights reserved.
//

#import "ViewController.h"
#import "ESPTankMainViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startControll:(UIButton *)sender {
    ESPTankMainViewController *vc = [[ESPTankMainViewController alloc] init];
    vc.devID = self.userId.text;
    vc.host = @"192.168.1.103";
    vc.port = 9999;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userId resignFirstResponder];
}


@end
