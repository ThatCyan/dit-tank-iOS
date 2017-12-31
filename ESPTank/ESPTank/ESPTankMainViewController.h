//
//  ESPTankMainViewController.h
//  ESPTank
//
//  Created by 李育洋 on 2017/12/30.
//  Copyright © 2017年 李育洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESPTankMainViewController : UIViewController
@property (nonatomic,strong) NSString *devID;
@property (nonatomic, copy) NSString *host;
@property (nonatomic,assign) UInt16 port;
@end
