//
//  DJPresentViewController.m
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import "DJPresentViewController.h"
#import "UIViewController+DJRouter.h"

@implementation DJPresentViewController

- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor blueColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 100, 100, 40);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    NSLog(@"%@",self.params);
}

- (void)buttonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
