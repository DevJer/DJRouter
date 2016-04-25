//
//  DJRouterInit.m
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import "DJRouterInit.h"
#import "DJRouter.h"
#import "ViewController.h"
#import "DJPushViewController.h"
#import "DJPresentViewController.h"

@implementation DJRouterInit

+ (void)initRouter {
    [[DJRouter shared] map:@"myapp://mainview" toControllerClass:[ViewController class]];
    [[DJRouter shared] map:@"myapp://pushview/:id" toControllerClass:[DJPushViewController class]];
    [[DJRouter shared] map:@"myapp://presentview/:test" toControllerClass:[DJPresentViewController class]];
}

@end
