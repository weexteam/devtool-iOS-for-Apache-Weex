//
//  WXTracingTableViewCell.h
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTracingManager.h"

@interface WXTracingApiTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classLabel;

- (void)config:(NSDictionary *)dict;

@end
