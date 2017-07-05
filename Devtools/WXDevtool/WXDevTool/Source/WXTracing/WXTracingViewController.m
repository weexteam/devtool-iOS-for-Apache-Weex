//
//  WXTracingViewController.m
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import "WXTracingViewController.h"
#import "UIButton+WXEnlargeArea.h"
#import "WXRenderTracingViewController.h"

@interface WXTracingViewController ()

@property(nonatomic,strong)WXRenderTracingViewController *tracingVC;

@end

@implementation WXTracingViewController

+ (instancetype) sharedInstance{
    
    static WXTracingViewController *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[WXTracingViewController alloc] init];
    });
    
    return instance;
}

+(void)load
{
    [self addWeexView];
}

+(void)addWeexView
{
    double delayInSeconds = 2.0;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(100, 0, 50, 40);
            [button setTitle:@"weex" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showTracing) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor redColor];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:button];
            [button setEnlargeEdgeWithTop:20 right:20.0 bottom:20.0 left:20.0];
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
    WXTracingViewController *manager = [WXTracingViewController sharedInstance];
    UINavigationController *nav = [[WXTracingViewController sharedInstance] visibleNavigationController];
    manager.tracingVC = [[WXRenderTracingViewController alloc] initWithFrame:[[WXTracingViewController sharedInstance] mainWindow].bounds];
    [nav pushViewController:manager.tracingVC animated:YES];
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
