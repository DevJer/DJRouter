//
//  ViewController.m
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import "ViewController.h"
#import "DJRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(10, 100, 100, 40);
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 setTitle:@"push" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(10, 200, 100, 40);
    [button2 setBackgroundColor:[UIColor blueColor]];
    [button2 setTitle:@"present" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    
}

- (void)button1Click {
    [[DJRouter shared] pushViewControllerWithRoute:@"myapp://pushview/2233"];
}

- (void)button2Click {
    [[DJRouter shared] presentViewControllerWithRoute:@"myapp://presentview/hello?id=12&name=world" from:nil wrap:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
