//
//  WXTracingViewController.m
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import "WXTracingViewControllerManager.h"
#import "UIButton+WXEnlargeArea.h"
#import "WXRenderTracingViewController.h"
#import "MTStatusBarOverlay.h"
#import "FLEXWindow.h"
#import "ScrollTestVC.h"
#import "WXTracingLogImpl.h"
#import <WeexSDK/WXSDKEngine.h>

@interface WXTracingViewControllerManager ()

@property(nonatomic,strong)WXRenderTracingViewController *tracingVC;
@property(nonatomic)BOOL isLoad;
@property(nonatomic)BOOL isLoadTracing;

@end

@implementation WXTracingViewControllerManager

+ (instancetype) sharedInstance{
    
    static WXTracingViewControllerManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[WXTracingViewControllerManager alloc] init];
    });
    
    return instance;
}

+ (void)load
{
    [self loadTracingView];
}

+(void)loadTracingView
{
    if(![WXTracingViewControllerManager sharedInstance].isLoad){
        [WXTracingViewControllerManager addWeexView];
        [WXTracingViewControllerManager sharedInstance].isLoad = YES;
        [WXLog registerExternalLog:[WXTracingLogImpl new]];
    }
}

+(void)addWeexView
{
    double delayInSeconds = 2.0;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 50, 20);
            [button setTitle:@"weex" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showTracing) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor redColor];
            [button setEnlargeEdgeWithTop:20 right:20.0 bottom:20.0 left:20.0];
            UIWindow *wind = [[UIWindow alloc]initWithFrame:CGRectMake(100, 0, 70, 40)];
            [wind addSubview:button];
            wind.windowLevel = UIWindowLevelStatusBar+100;
            wind.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            wind.userInteractionEnabled = YES;
            wind.hidden = NO;
            [[UIApplication sharedApplication].keyWindow addSubview:wind];
            [WXTracingViewControllerManager sharedInstance].textView = [UITextView new];

        });
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)showTracing
{
    
    if(![WXTracingViewControllerManager sharedInstance].isLoadTracing){
        WXTracingViewControllerManager *manager = [WXTracingViewControllerManager sharedInstance];
        UINavigationController *nav = [[WXTracingViewControllerManager sharedInstance] visibleNavigationController];
        //    CGRect rect = [UIScreen mainScreen].bounds;
        manager.tracingVC = [[ScrollTestVC alloc]init];
        manager.tracingVC.view.backgroundColor = [UIColor whiteColor];
        //    manager.tracingVC = [[WXRenderTracingViewController alloc] initWithFrame:CGRectMake(0, rect.size.height/2-64, rect.size.width, rect.size.height/2)];
        [nav.visibleViewController addChildViewController:manager.tracingVC];
        [nav.visibleViewController.view addSubview:manager.tracingVC.view];
        [WXTracingViewControllerManager sharedInstance].isLoadTracing = YES;
    }else{
        WXTracingViewControllerManager *manager = [WXTracingViewControllerManager sharedInstance];
        [manager.tracingVC removeFromParentViewController];
        [manager.tracingVC.view removeFromSuperview];
        [WXTracingViewControllerManager sharedInstance].isLoadTracing = NO;
    }
    
    
}


- (UIWindow *)mainWindow {
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = [self.mainWindow rootViewController];
    return [self getVisibleViewControllerFrom:rootViewController];
}

- (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
    
}

- (UINavigationController *)visibleNavigationController {
    if([[self visibleViewController] isKindOfClass:[UINavigationController class]]){
        return [self visibleViewController];
    }
    return [[self visibleViewController] navigationController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
