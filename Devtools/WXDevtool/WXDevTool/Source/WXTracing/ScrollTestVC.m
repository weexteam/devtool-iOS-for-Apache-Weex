//
//  JPSlideBarViewController.m
//  JPSlideBar
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 XiFengLang. All rights reserved.
//

#import "ScrollTestVC.h"
#import "WXRenderTracingViewController.h"
#import "WXLogViewController.h"
#import "WXApiTracingViewController.h"
#import "WXEnviromentViewController.h"

@interface ScrollTestVC ()<UIGestureRecognizerDelegate>
{
    NSArray * titles;
}
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)JPSlideNavigationBar * slideBar;

@end

@implementation ScrollTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    titles = @[@"简书",@"ONE",@"网易云音乐",@"腾讯百度",@"谷歌",@"特斯拉",@"阿里巴巴"];
    titles = @[@"性能",@"网络",@"日志",@"api",@"环境变量"];
    
    [self initializeUI];
    self.scrollView.decelerationRate = 1.0;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    // 解决scrollView的pan手势和侧滑返回手势冲突
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
            break;
        }
    }
    CGFloat f= [UIScreen mainScreen].bounds.size.height/2;
    self.slideBar = [JPSlideNavigationBar slideBarWithObservableScrollView:self.scrollView
                                                            viewController:self
                                                              frameOriginY:0
                                                       slideBarSliderStyle:JPSlideBarStyleTransformationAndGradientColor];
    [self.view addSubview:self.slideBar];
    
    Weak(self); //避免循环引用
    [self.slideBar configureSlideBarWithTitles:titles
                                     titleFont:[UIFont systemFontOfSize:18]
                                     itemSpace:30
                           normalTitleRGBColor:JColor_RGB(0,0,0)
                         selectedTitleRGBColor:JColor_RGB(255,255,255)
                                 selectedBlock:^(NSInteger index) {
                                     Strong(self);
                                     CGFloat scrollX = CGRectGetWidth(self.scrollView.bounds) * index;
                                     [self.scrollView setContentOffset:CGPointMake(scrollX, 0)];
                                 }];
    
    // 可以监听每次翻页的通知。(比如刷新数据)
    [JPNotificationCenter addObserver:self selector:@selector(doSomeThingWhenScrollViewChangePage:) name:JPSlideBarChangePageNotification object:nil];
}

- (void)doSomeThingWhenScrollViewChangePage:(NSNotification *)notification{
    CGFloat offsetX = [notification.userInfo[JPSlideBarScrollViewContentOffsetX] floatValue];
    NSInteger index = [notification.userInfo[JPSlideBarCurrentIndex] integerValue];
    
    JKLog(@"offsetX:%f    index:%ld",offsetX,index);
}

- (void)initializeUI{
    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"JPSlideBar";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    [self initializeScrollViewWithStatusBarHeight:(64)];
    [self setupScrollViewSubViewsWithNumber:titles.count];
    self.scrollView.contentSize = CGSizeMake(titles.count * JPScreen_Width, CGRectGetHeight(self.scrollView.bounds));
}


- (void)initializeScrollViewWithStatusBarHeight:(CGFloat)statusBarHeight{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight, JPScreen_Width, JPScreen_Height-statusBarHeight)];
    self.scrollView.showsHorizontalScrollIndicator= NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

- (void)setupScrollViewSubViewsWithNumber:(NSInteger)count{
    for (NSInteger index = 0; index < count; index ++) {
        
        CGRect rect = [UIScreen mainScreen].bounds;
        UIViewController *subVC;
        if(index == 2){
            subVC = [[WXLogViewController alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            
            [self addChildViewController:subVC];
            [self.scrollView addSubview:subVC.view];
        }else if(index == 3){
            subVC = [[WXApiTracingViewController alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            
            [self addChildViewController:subVC];
            [self.scrollView addSubview:subVC.view];
        }else if(index == 4){
            subVC = [[WXEnviromentViewController alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            
            [self addChildViewController:subVC];
            [self.scrollView addSubview:subVC.view];
        }else {
            subVC = [[WXRenderTracingViewController alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            
            [self addChildViewController:subVC];
            [self.scrollView addSubview:subVC.view];
        }
        /// 如果在addChildViewController前面设置subVC.view.frame，会提前走viewDidLoad，可能会影响传值，所以放在最后面
        subVC.view.frame = CGRectMake(self.scrollView.bounds.size.width * index, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    }
}


- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}




@end
