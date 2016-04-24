//
//  DJRouter.h
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id (^DJRouterBlock)(NSDictionary* params);

@interface DJRouter : NSObject

+ (instancetype)shared;

- (void)setNavigationController:(UINavigationController *)navigationController;

- (void)map:(NSString*)route toControllerClass:(Class)controllerClass;
- (UIViewController*)matchController:(NSString*)route;
- (UIViewController*)pushViewControllerWithRoute:(NSString*)route;
- (UIViewController*)pushViewControllerWithRoute:(NSString *)route from:(UINavigationController*)nav;
- (UIViewController*)pushViewControllerWithRoute:(NSString *)route from:(UINavigationController*)nav animated:(BOOL) animated;

- (UIViewController*)presentViewControllerWithRoute:(NSString*)route;
- (UIViewController*)presentViewControllerWithRoute:(NSString*)route from:(UIViewController*)ctl;
- (UIViewController*)presentViewControllerWithRoute:(NSString*)route from:(UIViewController*)ctl wrap:(BOOL)wrap;
- (UIViewController*)presentViewControllerWithRoute:(NSString*)route from:(UIViewController*)ctl wrap:(BOOL)wrap animated:(BOOL)animated completion:(void(^)())block;

- (void)map:(NSString*)route toBlock:(DJRouterBlock)block;
- (DJRouterBlock)matchBlock:(NSString*)route;
- (id)callBlock:(NSString*)route;

@end
