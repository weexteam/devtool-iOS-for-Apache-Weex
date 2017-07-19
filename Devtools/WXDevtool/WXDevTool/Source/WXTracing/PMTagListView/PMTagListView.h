//
//  PMTagListView.h
//  ipaimai
//
//  Created by Jun.Shi on 1/27/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@protocol PMTagListViewDelegate <NSObject>

@optional
- (void)selectedTag:(NSString *)tagName withIndex:(NSInteger)tagIndex;

@end

@interface PMTagListView : UIView

@property (strong) HMSegmentedControl *segmentedControl;
@property (weak) id<PMTagListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)bindData:(NSArray *)titles;
// after bindData
- (void)setHighLightIndex:(NSInteger)index;

@end
