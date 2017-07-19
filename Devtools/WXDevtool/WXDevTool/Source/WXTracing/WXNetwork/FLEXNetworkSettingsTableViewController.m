//
//  FLEXNetworkSettingsTableViewController.m
//  FLEXInjected
//
//  Created by Ryan Olson on 2/20/15.
//
//

#import "FLEXNetworkSettingsTableViewController.h"
#import "FLEXNetworkObserver.h"
#import "FLEXNetworkRecorder.h"
#import "FLEXUtility.h"
#import <WeexSDK/WXLog.h>
#import "WXLogSettingViewController.h"

@interface FLEXNetworkSettingsTableViewController () <UIActionSheetDelegate,WXLogSettingViewControllerDelegate>

@property (nonatomic, copy) NSArray *cells;

@property (nonatomic, strong) UITableViewCell *cacheLimitCell;

@end

@implementation FLEXNetworkSettingsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configData];
    
}

-(void)configData
{
    NSMutableArray *mutableCells = [NSMutableArray array];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger loglevel = [[defaults objectForKey:@"wxloglevel"] integerValue];
    UITableViewCell *logDebuggingCell = [self logCellWithTitle:@"日志级别" logLevel:loglevel];
    [mutableCells addObject:logDebuggingCell];
    
    UITableViewCell *networkDebuggingCell = [self switchCellWithTitle:@"网络调试" toggleAction:@selector(networkDebuggingToggled:) isOn:[FLEXNetworkObserver isEnabled]];
    [mutableCells addObject:networkDebuggingCell];
    
    UITableViewCell *cacheMediaResponsesCell = [self switchCellWithTitle:@"多媒体缓存" toggleAction:@selector(cacheMediaResponsesToggled:) isOn:NO];
    [mutableCells addObject:cacheMediaResponsesCell];
    
    NSUInteger currentCacheLimit = [[FLEXNetworkRecorder defaultRecorder] responseCacheByteLimit];
    const NSUInteger fiftyMega = 50 * 1024 * 1024;
    NSString *cacheLimitTitle = [self titleForCacheLimitCellWithValue:currentCacheLimit];
    self.cacheLimitCell = [self sliderCellWithTitle:cacheLimitTitle changedAction:@selector(cacheLimitAdjusted:) minimum:0.0 maximum:fiftyMega initialValue:currentCacheLimit];
    [mutableCells addObject:self.cacheLimitCell];
    
    UITableViewCell *clearRecordedRequestsCell = [self buttonCellWithTitle:@"❌  清除请求记录" touchUpAction:@selector(clearRequestsTapped:) isDestructive:YES];
    [mutableCells addObject:clearRecordedRequestsCell];
    
    self.cells = mutableCells;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Settings Actions

- (void)networkDebuggingToggled:(UISwitch *)sender
{
    [FLEXNetworkObserver setEnabled:sender.isOn];
}

- (void)logLevelDebuggingToggled
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"title" message:@"log level setting" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *offAction = [UIAlertAction actionWithTitle:@"off" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelOff) forKey:@"wxloglevel"];
        [defaults synchronize];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:offAction];
    
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"error" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelError) forKey:@"wxloglevel"];
        [defaults synchronize];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:errorAction];
    
    UIAlertAction *warnAction = [UIAlertAction actionWithTitle:@"warn" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelWarning) forKey:@"wxloglevel"];
        [defaults synchronize];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:warnAction];
    
    UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"info" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelInfo) forKey:@"wxloglevel"];
        [defaults synchronize];
    }];
    
    [alertController addAction:infoAction];
    
    UIAlertAction *logAction = [UIAlertAction actionWithTitle:@"log" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelLog) forKey:@"wxloglevel"];
        [defaults synchronize];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:logAction];
    
    UIAlertAction *debugAction = [UIAlertAction actionWithTitle:@"debug" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelDebug) forKey:@"wxloglevel"];
        [defaults synchronize];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:debugAction];
    
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"all" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(WXLogLevelAll) forKey:@"wxloglevel"];
        [defaults synchronize];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:allAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
//        [self popoverPresentationController];
    }];
    
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)cacheMediaResponsesToggled:(UISwitch *)sender
{
    [[FLEXNetworkRecorder defaultRecorder] setShouldCacheMediaResponses:sender.isOn];
}

- (void)cacheLimitAdjusted:(UISlider *)sender
{
    [[FLEXNetworkRecorder defaultRecorder] setResponseCacheByteLimit:sender.value];
    self.cacheLimitCell.textLabel.text = [self titleForCacheLimitCellWithValue:sender.value];
}

- (void)clearRequestsTapped:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除请求记录" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return self.cells[indexPath.row];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [[FLEXNetworkRecorder defaultRecorder] clearRecordedActivity];
    }
}

#pragma mark - Helpers

- (UITableViewCell *)logCellWithTitle:(NSString *)title logLevel:(WXLogLevel)logLevel
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = title;
    cell.textLabel.font = [[self class] cellTitleFont];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(CGRectGetMaxX(cell.frame) - 40 , round((cell.contentView.frame.size.height - 20) / 2.0), 80, 20);
    label.textAlignment = NSTextAlignmentRight;
    NSString *str = @"log";
    switch (logLevel) {
        case WXLogLevelOff:
            str = @"off";
            break;
        case WXLogLevelError:
            str = @"error";
            break;
        case WXLogLevelWarning:
            str = @"warn";
            break;
        case WXLogLevelInfo:
            str = @"info";
            break;
        case WXLogLevelLog:
            str = @"log";
            break;
        case WXLogLevelDebug:
            str = @"debug";
            break;
        case WXLogLevelAll:
            str = @"all";
            break;
            
        default:
            break;
    }
    
    label.text = str;
    [cell.contentView addSubview:label];

    return cell;
}

- (UITableViewCell *)switchCellWithTitle:(NSString *)title toggleAction:(SEL)toggleAction isOn:(BOOL)isOn
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = title;
    cell.textLabel.font = [[self class] cellTitleFont];

    UISwitch *theSwitch = [[UISwitch alloc] init];
    theSwitch.on = isOn;
    [theSwitch addTarget:self action:toggleAction forControlEvents:UIControlEventValueChanged];

    CGFloat switchOriginY = round((cell.contentView.frame.size.height - theSwitch.frame.size.height) / 2.0);
    CGFloat switchOriginX = CGRectGetMaxX(cell.contentView.frame) - theSwitch.frame.size.width - self.tableView.separatorInset.left;
    theSwitch.frame = CGRectMake(switchOriginX, switchOriginY, theSwitch.frame.size.width, theSwitch.frame.size.height);
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [cell.contentView addSubview:theSwitch];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        WXLogSettingViewController *logSettingVC = [[WXLogSettingViewController alloc] init];
        logSettingVC.delegate = self;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:logSettingVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)buttonCellWithTitle:(NSString *)title touchUpAction:(SEL)action isDestructive:(BOOL)isDestructive
{
    UITableViewCell *buttonCell = [[UITableViewCell alloc] init];
    buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [actionButton setTitle:title forState:UIControlStateNormal];
    if (isDestructive) {
        actionButton.tintColor = [UIColor redColor];
    }
    actionButton.titleLabel.font = [[self class] cellTitleFont];;
    [actionButton addTarget:self action:@selector(clearRequestsTapped:) forControlEvents:UIControlEventTouchUpInside];

    [buttonCell.contentView addSubview:actionButton];
    actionButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    actionButton.frame = buttonCell.contentView.frame;
    actionButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, self.tableView.separatorInset.left, 0.0, self.tableView.separatorInset.left);
    actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    return buttonCell;
}

- (NSString *)titleForCacheLimitCellWithValue:(long long)cacheLimit
{
    NSInteger limitInMB = round(cacheLimit / (1024 * 1024));
    return [NSString stringWithFormat:@"缓存限制 (%ld MB)", (long)limitInMB];
}

- (UITableViewCell *)sliderCellWithTitle:(NSString *)title changedAction:(SEL)changedAction minimum:(CGFloat)minimum maximum:(CGFloat)maximum initialValue:(CGFloat)initialValue
{
    UITableViewCell *sliderCell = [[UITableViewCell alloc] init];
    sliderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    sliderCell.textLabel.text = title;
    sliderCell.textLabel.font = [[self class] cellTitleFont];

    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = minimum;
    slider.maximumValue = maximum;
    slider.value = initialValue;
    [slider addTarget:self action:changedAction forControlEvents:UIControlEventValueChanged];
    [slider sizeToFit];

    CGFloat sliderWidth = round(sliderCell.contentView.frame.size.width * 2.0 / 5.0);
    CGFloat sliderOriginY = round((sliderCell.contentView.frame.size.height - slider.frame.size.height) / 2.0);
    CGFloat sliderOriginX = CGRectGetMaxX(sliderCell.contentView.frame) - sliderWidth - self.tableView.separatorInset.left;
    slider.frame = CGRectMake(sliderOriginX, sliderOriginY, sliderWidth, slider.frame.size.height);
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [sliderCell.contentView addSubview:slider];

    return sliderCell;
}

+ (UIFont *)cellTitleFont
{
    return [FLEXUtility defaultFontOfSize:14.0];
}

#pragma mark -
#pragma WXLogSettingViewControllerDelegate
- (void)selectLogLevel:(NSInteger)logLevel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(logLevel) forKey:@"wxloglevel"];
    [defaults synchronize];
    [self configData];
    [self.tableView reloadData];
}


@end
