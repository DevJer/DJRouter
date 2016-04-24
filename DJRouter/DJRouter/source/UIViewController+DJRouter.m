//
//  UIViewController+DJRouter.m
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import "UIViewController+DJRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (DJRouter)

static char kAssociatedParamsObjectKey;

- (void)setParams:(NSDictionary*)paramsDictionary
{
    objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, paramsDictionary,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary*)params
{
    return objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}

+ (UIViewController*)topMostViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topMostViewControllerOfViewController:(UIViewController*)rootViewController];
}

+ (UIViewController*)topMostViewControllerOfViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarViewController = (UITabBarController*)viewController;
        UIViewController *selectedViewController = tabBarViewController.selectedViewController;
        return [self topMostViewControllerOfViewController:selectedViewController];
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController*)viewController;
        UIViewController *visibleViewController = navController.visibleViewController;
        return [self topMostViewControllerOfViewController:visibleViewController];
    }
    if (viewController.presentedViewController) {
        UIViewController *presentedViewController = viewController.presentedViewController;
        return [self topMostViewControllerOfViewController:presentedViewController];
    }
    for (UIView *subView in viewController.view.subviews) {
        if ([subView.nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *childViewController = (UIViewController*)subView;
            return [self topMostViewControllerOfViewController:childViewController];
        }
    }
    return viewController;
}

@end
