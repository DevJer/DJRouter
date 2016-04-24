//
//  DJRouter.m
//  DJRouter
//
//  Created by 郑中杰 on 16/4/24.
//  Copyright © 2016年 郑中杰. All rights reserved.
//

#import "DJRouter.h"
#import "UIViewController+DJRouter.h"
#import <objc/runtime.h>

@interface DJRouter()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSMutableDictionary* routes;
@end

@implementation DJRouter
+ (instancetype)shared {
    static DJRouter* router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    return router;
}

- (NSMutableDictionary*)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

- (void)setNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
}

- (void)map:(NSString*)route toControllerClass:(Class)controllerClass {
    NSMutableDictionary* subRoutes = [self subRoutesToRoute:route];
    
    subRoutes[@"_"] = controllerClass;
}


- (UIViewController*)matchController:(NSString*)route {
    NSDictionary* params = [self paramsInRoute:route];
    Class controllerClass = params[@"controller_class"];
    
    UIViewController* viewController = [[controllerClass alloc] init];
    
    if ([viewController respondsToSelector:@selector(setParams:)]) {
        [viewController performSelector:@selector(setParams:)
                             withObject:[params copy]];
    }
    return viewController;
}

- (UIViewController*)pushViewControllerWithRoute:(NSString *)route {
    return [self pushViewControllerWithRoute:route from:nil animated:YES];
}

- (UIViewController*)pushViewControllerWithRoute:(NSString *)route from:(UINavigationController*)nav {
    return [self pushViewControllerWithRoute:route from:nav animated:YES];
}

- (UIViewController*)pushViewControllerWithRoute:(NSString *)route from:(UINavigationController*)nav animated:(BOOL) animated{
    UIViewController *viewController = [self matchController:route];
    if (nav == nil) {
        if (self.navigationController == nil) {
            self.navigationController = [[UINavigationController alloc] init];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [nav pushViewController:viewController animated:animated];
    }
    return viewController;
}

- (UIViewController*)presentViewControllerWithRoute:(NSString*)route {
    return [self presentViewControllerWithRoute:route from:nil wrap:NO animated:YES completion:nil];
}

- (UIViewController*)presentViewControllerWithRoute:(NSString*)route from:(UIViewController*)ctl {
    return [self presentViewControllerWithRoute:route from:ctl wrap:NO animated:YES completion:nil];
}

- (UIViewController*)presentViewControllerWithRoute:(NSString*)route from:(UIViewController*)ctl wrap:(BOOL)wrap {
    return [self presentViewControllerWithRoute:route from:ctl wrap:wrap animated:YES completion:nil];
}

- (UIViewController*)presentViewControllerWithRoute:(NSString*)route from:(UIViewController*)ctl wrap:(BOOL)wrap animated:(BOOL)animated completion:(void(^)())block {
    UIViewController *viewController = [self matchController:route];
    UIViewController *fromCtl = ctl != nil ? ctl : [UIViewController topMostViewController];
    if (wrap) {
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [fromCtl presentViewController:nav animated:animated completion:block];
    } else {
        [fromCtl presentViewController:viewController animated:animated completion:block];
    }
    return viewController;
}

- (void)map:(NSString*)route toBlock:(DJRouterBlock)block {
    NSMutableDictionary* subRoutes = [self subRoutesToRoute:route];
    
    subRoutes[@"_"] = [block copy];
}

- (DJRouterBlock)matchBlock:(NSString*)route {
    NSDictionary* params = [self paramsInRoute:route];
    DJRouterBlock routerBlock = [params[@"block"] copy];
    DJRouterBlock returnBlock = ^id(NSDictionary* aParams) {
        if (routerBlock) {
            return routerBlock([params copy]);
        }
        return nil;
    };
    
    return [returnBlock copy];
}

- (id)callBlock:(NSString*)route {
    NSDictionary* params = [self paramsInRoute:route];
    DJRouterBlock routerBlock = [params[@"block"] copy];
    
    if (routerBlock) {
        return routerBlock([params copy]);
    }
    return nil;
}

- (NSDictionary*)paramsInRoute:(NSString*)route
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    params[@"route"] = route;
    
    NSMutableDictionary* subRoutes = self.routes;
    NSArray* pathComponents =
    [self pathComponentsFromRoute:route];
    for (NSString* pathComponent in pathComponents) {
        BOOL found = NO;
        NSArray* subRoutesKeys = subRoutes.allKeys;
        for (NSString* key in subRoutesKeys) {
            if ([subRoutesKeys containsObject:pathComponent]) {
                found = YES;
                subRoutes = subRoutes[pathComponent];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                params[[key substringFromIndex:1]] = pathComponent;
                break;
            }
        }
        if (!found) {
            return nil;
        }
    }
    
    NSRange firstRange = [route rangeOfString:@"?"];
    if (firstRange.location != NSNotFound && route.length > firstRange.location + firstRange.length) {
        NSString* paramsString = [route substringFromIndex:firstRange.location + firstRange.length];
        NSArray* paramStringArr = [paramsString componentsSeparatedByString:@"&"];
        for (NSString* paramString in paramStringArr) {
            NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString* key = [paramArr objectAtIndex:0];
                NSString* value = [paramArr objectAtIndex:1];
                params[key] = value;
            }
        }
    }
    
    Class class = subRoutes[@"_"];
    if (class_isMetaClass(object_getClass(class))) {
        if ([class isSubclassOfClass:[UIViewController class]]) {
            params[@"controller_class"] = subRoutes[@"_"];
        } else {
            return nil;
        }
    } else {
        if (subRoutes[@"_"]) {
            params[@"block"] = [subRoutes[@"_"] copy];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:params];
}

- (NSArray*)pathComponentsFromRoute:(NSString*)route
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    for (NSString *pathComponent in route.pathComponents) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

- (NSMutableDictionary*)subRoutesToRoute:(NSString*)route
{
    NSArray* pathComponents = [self pathComponentsFromRoute:route];
    
    NSInteger index = 0;
    NSMutableDictionary* subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString* pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    return subRoutes;
}

@end
