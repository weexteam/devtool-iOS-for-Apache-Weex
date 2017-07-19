//
//  WXRenderTracingViewController.m
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import "WXRenderTracingViewController.h"
#import <UIKit/UIKit.h>
#import "WXTracingManager.h"
#import "WXRenderTracingTableViewCell.h"

@interface WXRenderTracingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *table;
@property (strong,nonatomic) NSArray     *content;
@property (strong,nonatomic) NSMutableArray *tasks;
@property (nonatomic) NSTimeInterval begin;
@property (nonatomic) NSTimeInterval end;

@end

@implementation WXRenderTracingViewController

- (instancetype)initWithFrame:(CGRect )frame
{
    if ((self = [super init])) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame =  CGRectMake(0, 0, rect.size.width, rect.size.height);
    [self cofigureTableview];
    self.tasks = [NSMutableArray new];
    WXTracingTask *task = [WXTracingManager getTracingData];
    for (WXTracing *tracing in task.tracings) {
        if(![WXTracingEnd isEqualToString:tracing.ph]){
            [self.tasks addObject:tracing];
            if(self.begin <0.0001){
                self.begin = tracing.ts;
            }
            
            if(tracing.ts < self.begin){
                self.begin = tracing.ts;
            }
            if((tracing.ts +tracing.duration) > self.end){
                self.end = tracing.ts +tracing.duration ;
            }
            
//            NSLog(@"%@ %@  %@  %@  %f %f %@  %@",tracing.iid,tracing.fName,tracing.name,tracing.className,tracing.ts,tracing.duration,tracing.ref,tracing.parentRef);
        }
    }
}

-(void)cofigureTableview
{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    WXRenderTracingTableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[WXRenderTracingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger row = [indexPath row];
    [cell config:self.tasks[row] begin:self.begin end:self.end];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"title of cell %@", [_content objectAtIndex:indexPath.row]);
}

@end
