//
//  UIViewController+DJRouter.h
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DJRouter)

@property (nonatomic, strong) NSDictionary* params;

+ (UIViewController*)topMostViewController;

@end
