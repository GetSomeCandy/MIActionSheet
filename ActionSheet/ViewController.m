//
//  ViewController.m
//  ActionSheet
//
//  Created by mac2 on 16/8/26.
//  Copyright © 2016年 mac2. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "MIActionSheetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)actionSheetClick {
    
    //ActionSheet的使用方式
    MIActionSheetView * actionSheet = [MIActionSheetView actionSheetViewWithTitle:nil message:nil];
    MIActionSheetViewAction * action = [MIActionSheetViewAction actionWithTitle:@"你是好人" style:MIActionSheetStyleDefault handle:^(MIActionSheetView *actionSheetView) {
        NSLog(@"You are a good person");
    }];
    MIActionSheetViewAction * action2 = [MIActionSheetViewAction actionWithTitle:@"我是坏人" style:MIActionSheetStyleDefault handle:^(MIActionSheetView *actionSheetView) {
        NSLog(@"I am a bad guy");
    }];
    MIActionSheetViewAction * action3 = [MIActionSheetViewAction actionWithTitle:@"他是笨蛋" style:MIActionSheetStyleDefault handle:^(MIActionSheetView *actionSheetView) {
        NSLog(@"He is a fool");
    }];
    [actionSheet addAction:action];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet show];
}

@end










