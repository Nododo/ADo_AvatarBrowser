//
//  ViewController.m
//  ADo_AvatarBrowser
//
//  Created by 杜 维欣 on 15/7/30.
//  Copyright (c) 2015年 Nododo. All rights reserved.
//

#import "ViewController.h"
#import "ADo_AvatarBrowser.h"
@interface ViewController ()
- (IBAction)show:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)show:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ADo_AvatarBrowser *browser = [[ADo_AvatarBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds image:btn.imageView.image view:btn];
    [browser show];
}
@end
