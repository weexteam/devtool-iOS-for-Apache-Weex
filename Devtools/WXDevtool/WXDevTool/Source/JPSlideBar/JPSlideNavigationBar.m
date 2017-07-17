//
//  JPSlideNavigationBar.m
//  JPSlideBar
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 XiFengLang. All rights reserved.
//

#import "JPSlideBar.h"
#import "JPSlideBar+ScrollViewDelegate.h"


@interface JPSlideNavigationBar ()

@property (nonatomic, assign)JPSlideBarStyle  slideBarStyle;
@property (nonatomic, copy) JPSlideBarSelectedBlock selectedBlock;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)NSMutableArray * titleArray;
@property (nonatomic, strong)NSMutableArray * labelArray;

// 存放label.center.x坐标
@property (nonatomic, strong)NSMutableArray * labelCenterXArray;
// 存放slider的宽度
@property (nonatomic, strong)NSMutableArray * sliderWidthArray;
// 存放相邻Label的center.x差值
@property (nonatomic, strong)NSMutableArray * labelCenterDValueArray;
// 存放相邻Label的宽度差值
@property (nonatomic, strong)NSMutableArray * labelWidthDValueArray;

// 内部实现KVO以及移除KVO
@property (nonatomic, strong)UIScrollView * observedScrollView;
// 用于判断是否减速，针对滑动过快
@property (nonatomic, assign)BOOL didEndDecelerating;
// 下面2个属性用于判断是否滑动到边缘位置
@property (nonatomic, assign)BOOL isScrollDirectionLeft;
@property (nonatomic, assign)CGFloat observedScrollViewOffsetX;

@property (nonatomic, strong)UIFont  * font;
@property (nonatomic, strong)UIColor * normalColor;
@property (nonatomic, strong)UIColor * selectedColor;
@property (nonatomic, strong)UILabel * selectedLabel;

@property (nonatomic, strong)UIView * sliderLine;
@property (nonatomic, assign)CGFloat sliderFrameY;
@property (nonatomic, assign)CGFloat itemSpace;

//  记录被观察scrollView实时X轴偏移量
@property (nonatomic, assign)CGFloat offestXKVO;
//  被观察scrollView减去上一次减速后的偏移X的差值 与屏宽的比例
//  (offsetX - self.currentOffsetX)/self.screenWidth;
@property (nonatomic, assign)CGFloat scale;
//  被观察scrollView上一次减速后的X轴偏移量
@property (nonatomic, assign)CGFloat currentOffsetX;
//  被观察scrollView上一次减速后的中心X坐标
@property (nonatomic, assign)CGFloat currentCenterX;

//  currentIndex相对selectedIndex而言是全局可改变、可利用的，记录当前的index，两者难以替换
@property (nonatomic, assign)NSInteger currentIndex;
//  selectedIndex是更改颜色后的Index，在修改颜色的方法中修改，防止主线程重复刷新颜色（尽量只刷新一次）
@property (nonatomic, assign)NSInteger selectedIndex;

@end


@implementation JPSlideNavigationBar

+ (instancetype)slideBarWithObservableScrollView:(UIScrollView *)scrollView
                                  viewController:(UIViewController *)viewController
                                    frameOriginY:(CGFloat)frameOriginY
                             slideBarSliderStyle:(JPSlideBarStyle)slideBarStyle{
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    JPSlideNavigationBar * slideBar = [[self alloc]initWithEffect:blurEffect];
    slideBar.frame = CGRectMake(0, frameOriginY, JPScreen_Width, JPSlideBarHeight);
    
    slideBar.sliderFrameY = CGRectGetHeight(slideBar.bounds)-2;
    slideBar.slideBarStyle = slideBarStyle;
    slideBar.didEndDecelerating = NO;
    
    if (scrollView) {
        slideBar.observedScrollView = scrollView;
        [scrollView addObserver:slideBar forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return slideBar;
}



- (void)configureSlideBarWithTitles:(NSArray *)titleArray
                          titleFont:(UIFont *)font
                          itemSpace:(CGFloat)space
                normalTitleRGBColor:(UIColor *)normalColor
              selectedTitleRGBColor:(UIColor *)selectedColor
                      selectedBlock:(JPSlideBarSelectedBlock)selectedBlock{
    
    self.titleArray = [titleArray mutableCopy];
    self.normalColor   = normalColor;
    self.selectedColor = selectedColor;
    if (selectedBlock) self.selectedBlock = selectedBlock;
    self.font = font;
    
    self.itemSpace    = space > JPSlideBarItemSpacing ? space : JPSlideBarItemSpacing;
    self.itemSpace   -= JPSlideBarItemBroadening;  // itemSpace减去增加的宽度，宽度又会加上增加的宽度，相互抵消
    [self initializeAndConfigureSlideBarItems];
    
    self.currentIndex = 0;
    self.selectedIndex = 0;
    self.scale = 0;
    self.currentOffsetX = 0;
    self.offestXKVO = 0;
    
    switch (self.slideBarStyle) {
        case JPSlideBarStyleChangeColorOnly:
            break;
            
        case JPSlideBarStyleGradientColorOnly:
            [self.normalColor   jp_decomposeColorObjectIntoRGBValue];
            [self.selectedColor jp_decomposeColorObjectIntoRGBValue];
            break;
            
        case JPSlideBarStyleShowSliderAndChangeColor:
            [self initializeDisplaySliderLine];
            break;
            
        case JPSlideBarStyleShowSliderAndGradientColor:
            [self.normalColor   jp_decomposeColorObjectIntoRGBValue];
            [self.selectedColor jp_decomposeColorObjectIntoRGBValue];
            [self initializeDisplaySliderLine];
            break;
            
        case JPSlideBarStyleTransformationAndGradientColor:
            [self.normalColor   jp_decomposeColorObjectIntoRGBValue];
            [self.selectedColor jp_decomposeColorObjectIntoRGBValue];
            break;
            
        default:
            break;
    }
}



- (void)initializeAndConfigureSlideBarItems{
    CGFloat itemsTotalWidth = 0;
    CGFloat width = 0;
    
    for (NSInteger index = 0; index < self.titleArray.count; index++) {
        CGRect rect;
        
        if (self.titleArray.count <= 5) {   // 等宽处理
            width = JPScreen_Width/self.titleArray.count;
            [self.sliderWidthArray addObject:@(width)];
            rect = CGRectMake(index * width, 0, width, JPSlideBarHeight);
            itemsTotalWidth += width;
            [self.labelCenterXArray addObject:@(itemsTotalWidth - width/2.0)];
            
        }else{
            width = [self widthOfString:self.titleArray[index]];
            width += JPSlideBarItemBroadening;
            [self.sliderWidthArray addObject:@(width)];
//            width += self.itemSpace;
//            rect = CGRectMake(itemsTotalWidth, 0, width, JPSlider_Height);
            rect = CGRectMake(itemsTotalWidth, 0, width + self.itemSpace, JPSlideBarHeight);
            itemsTotalWidth += self.itemSpace + width;
            [self.labelCenterXArray addObject:@(itemsTotalWidth - (width + self.itemSpace)/2.0)];
        }
//        [self.sliderWidthArray addObject:@(width)];
//        [self.labelCenterXArray addObject:@(itemsTotalWidth - width/2.0)];
        
        
        UILabel * label = [self initializeLabelItemWithFrame:rect atIndex:index];
        if (index == 0) {
            self.selectedLabel = label;
//            self.currentCenterX = itemsTotalWidth - width/2.0;
            self.currentCenterX = itemsTotalWidth - (width + self.itemSpace)/2.0;
            label.textColor = self.selectedColor;
            if (self.slideBarStyle == JPSlideBarStyleTransformationAndGradientColor) {
                label.transform = CGAffineTransformMakeScale(JPSlideBarMaxScaleValur, JPSlideBarMaxScaleValur);
            }
        }else{
            // 计算相邻Label的width和center.x的偏差
            label.textColor = self.normalColor;
//            CGFloat centerDValue = itemsTotalWidth - width/2.0 - [self.labelCenterXArray[index-1] floatValue];
            CGFloat centerDValue = [self.labelCenterXArray[index] floatValue] - [self.labelCenterXArray[index-1] floatValue];
//            CGFloat widthDValue  = width - [self.sliderWidthArray[index-1] floatValue];
            CGFloat widthDValue  = [self.sliderWidthArray[index] floatValue] - [self.sliderWidthArray[index-1] floatValue];
            
            [self.labelCenterDValueArray addObject:@(centerDValue)];
            [self.labelWidthDValueArray addObject:@(widthDValue)];
        }
        
        [self.scrollView addSubview:label];
        [self.labelArray addObject :label];
    }
    
    
    if (self.titleArray.count <= 5) {
        self.scrollView.contentSize = CGSizeMake(JPScreen_Width, JPSlideBarHeight);
    }else {
        self.scrollView.contentSize = CGSizeMake(itemsTotalWidth, JPSlideBarHeight);
    }
}

- (void)initializeDisplaySliderLine{
    if (self.titleArray.count > 5) {
        self.sliderLine = [[UIView alloc]initWithFrame:CGRectMake(self.itemSpace/2.0, CGRectGetHeight(self.scrollView.bounds)-2, [[self.sliderWidthArray firstObject]floatValue], 2)];
    }else{
        self.sliderLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.scrollView.bounds)-2, [[self.sliderWidthArray firstObject]floatValue], 2)];
    }
    self.sliderLine.backgroundColor = self.selectedColor;
    [self.scrollView addSubview:self.sliderLine];
}

- (UILabel *)initializeLabelItemWithFrame:(CGRect)frame atIndex:(NSInteger)index{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    label.text = self.titleArray[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.font;
    label.tag  = 777+ index;
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewLabelDidSelected:)];
    [label addGestureRecognizer:tap];
    
    return label;
}


#pragma mark - publicMethod
- (void)setSlideBarBackgroudColorIfNecessary:(UIColor *)color{
    self.scrollView.backgroundColor = color;
    for (UILabel * label in self.labelArray) {
        label.backgroundColor = color;
    }
}

- (NSInteger)indexOfSlideBarItemDidSelected{
    return self.selectedIndex;
}

- (UILabel *)labelAtIndex:(NSInteger)index{
    return self.labelArray[self.selectedIndex];
}


- (void)addBottomLineIfNecessaryLineBackgroundColor:(UIColor *)color{
    CALayer * layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, JPScreen_Width, 0.5);
    layer.position = CGPointMake(0, JPSlideBarHeight);
    layer.anchorPoint = CGPointMake(0, 1);
    layer.backgroundColor = color.CGColor;
    [self.contentView.layer addSublayer:layer];
}


#pragma mark - ScrollViewDelegate(其他的代理方法在分类实现)

// 减速后发哥通知，及时更新self.currentIndex/self.currentOffsetX/self.currentCenterX等数据。
// 这些数据不在KVO里面更新，而是根据被观察的ScrollView减速后的位置更新。
// 但是有个缺点，滑动很快的时候不会触发这个结束减速的动画，就会出现一些问题。接下来的2个代理方法就是用来解决这个问题的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
    self.didEndDecelerating = YES;
    [self scrollViewObservedDidChangePageWithOffsetX:scrollView.contentOffset.x];
}

// 开始减速的时候开始self.didEndDecelerating = NO;结束减速就会置为YES,如果滑动很快就还是NO（不调用上面的方法）。
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
    self.didEndDecelerating = NO;
    
    // KVO有延迟，滑动快的时候，sliderLine可能没移动到边缘,留有空隙（只针对移动到边缘，不然会跟KVO里面的平移起冲突）
    if (scrollView.contentOffset.x > self.observedScrollViewOffsetX) {
        self.isScrollDirectionLeft = NO;
    }else{
        self.isScrollDirectionLeft = YES;
    }
    
    CGFloat index = scrollView.contentOffset.x/JPScreen_Width;
    if(roundf(index) == 1 && self.isScrollDirectionLeft){
        [self movesliderLineToDestinationIndex:roundf(index)];
    }else if (roundf(index) == self.titleArray.count-2 && self.isScrollDirectionLeft == NO){
        [self movesliderLineToDestinationIndex:roundf(index)];
    }
}



// 再次拖拽的时候，判断有没有因为滑动太快而没有调用结束减速的方法。
// 如果没有，四舍五入手动确定位置。这样就可以解决滑动过快的问题
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
    self.observedScrollViewOffsetX = scrollView.contentOffset.x;
    
    if (!self.didEndDecelerating) {
        CGFloat index = scrollView.contentOffset.x/JPScreen_Width;
        [self scrollViewObservedDidChangePageWithOffsetX:roundf(index)*JPScreen_Width];
    }
}

#pragma mark - KVO && NSNotification

- (void)scrollViewObservedDidChangePageWithOffsetX:(CGFloat)offsetX{
    self.currentCenterX = [self.labelCenterXArray[self.selectedIndex] floatValue];
    self.currentIndex   = (NSInteger)(offsetX / JPScreen_Width);
    [self resetSlideBarContentOffsetWithIndex:self.currentIndex];
    
    // 翻页的通知（外部可以接收）
    if (self.currentOffsetX != offsetX) {
        [[NSNotificationCenter defaultCenter]postNotificationName:JPSlideBarChangePageNotification object:nil userInfo:@{JPSlideBarScrollViewContentOffsetX:@(offsetX),JPSlideBarCurrentIndex:@(self.currentIndex)}];
    }
    self.currentOffsetX = offsetX;
}

//  KVO的回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetX = [change[@"new"] CGPointValue].x;
        [self updateSlideBarWhenScrollViewDidScrollWithOffsetX:offsetX];
    }
}



- (void)updateSlideBarWhenScrollViewDidScrollWithOffsetX:(CGFloat)offsetX{
    @autoreleasepool {
        if (offsetX == self.offestXKVO || offsetX < 0 || offsetX > JPScreen_Width * (self.titleArray.count -1)) {
            return;  // scrollView.bounces = YES时生效，或者为NO时到边上了还一直侧滑时生效,
        }
        
        if (self.observedScrollView.delegate != self) {
            if (self.observedScrollView.delegate) {
                _delegate = self.observedScrollView.delegate;
            }
            self.observedScrollView.delegate = self;
        }
        
        NSInteger destinationIndex = (NSInteger)((JPScreen_Width/2.0 + offsetX)/JPScreen_Width);
        [self didSelectedSlideBarItemAtIndex:destinationIndex isLabelClicked:NO];
        
        if (self.slideBarStyle == JPSlideBarStyleChangeColorOnly) {
            return;
        }
        
        CGFloat centerSpace = 0;
        CGFloat widthSpace = 0;
        CGFloat scale = (offsetX - self.currentOffsetX)/JPScreen_Width;
        if (scale == self.scale) {
            return;   // 点击选中产生的非动态偏移时生效，scrollView.bounces = NO
        }
        
        self.scale = scale; // 移动到下一个目标的比例，>0向右，<0向左
        NSInteger leftIndex = 0;
        NSInteger rightIndex = 0;
        
        if (scale > 0) {
            leftIndex = self.currentIndex;
            rightIndex = self.currentIndex+1;
            
            if (self.slideBarStyle == JPSlideBarStyleShowSliderAndGradientColor ||
                self.slideBarStyle == JPSlideBarStyleShowSliderAndChangeColor) {
                centerSpace = scale * [self.labelCenterDValueArray[self.currentIndex] floatValue];
                widthSpace  = scale * [self.labelWidthDValueArray[self.currentIndex]  floatValue];
            }
            
        }else if (scale < 0){
            leftIndex = self.currentIndex-1;
            rightIndex = self.currentIndex;
            
            if (self.slideBarStyle == JPSlideBarStyleShowSliderAndGradientColor ||
                self.slideBarStyle == JPSlideBarStyleShowSliderAndChangeColor) {
                centerSpace = scale * [self.labelCenterDValueArray[self.currentIndex-1] floatValue];
                widthSpace  = scale * [self.labelWidthDValueArray[self.currentIndex-1]  floatValue];
            }
        }
        
        if (self.slideBarStyle == JPSlideBarStyleShowSliderAndGradientColor ||
            self.slideBarStyle == JPSlideBarStyleGradientColorOnly ) {
            [self displayGradientColorWithLeftIndex:leftIndex andRightIndex:rightIndex scale:scale];
        }
        
        
        if (self.slideBarStyle == JPSlideBarStyleTransformationAndGradientColor) {
            [self displayGradientColorWithLeftIndex:leftIndex andRightIndex:rightIndex scale:scale];
            [self displayGradientSizeWithLeftIndex:leftIndex andRightIndex:rightIndex scale:scale];
        }
        
        if (self.slideBarStyle == JPSlideBarStyleShowSliderAndGradientColor ||
            self.slideBarStyle == JPSlideBarStyleShowSliderAndChangeColor) {
            CGPoint center = self.sliderLine.center;
            center.x = self.currentCenterX + centerSpace;
            self.sliderLine.center = center;
            
            if (widthSpace != 0) {
                // 已经在最右侧还一直左滑时生效,scrollView.bounces = NO
                self.sliderLine.bounds = CGRectMake(0, 0, [self.sliderWidthArray[self.currentIndex] floatValue] + widthSpace, 2);
            }
        }
    }
}

#pragma mark - LabelDidSelected
- (void)scrollViewLabelDidSelected:(UITapGestureRecognizer *)tapGesture{
    UILabel * label = (UILabel *)tapGesture.view;
    NSInteger index = label.tag - 777;
    [self resetSlideBarContentOffsetWithIndex:index];
    [self didSelectedSlideBarItemAtIndex:index isLabelClicked:YES];
    [self movesliderLineToDestinationIndex:index];
    
    self.currentOffsetX = index * JPScreen_Width;
    self.currentIndex   = index;
    self.currentCenterX = [self.labelCenterXArray[index] floatValue];
    
    if (self.selectedBlock) self.selectedBlock(index);
}

//  设置字体颜色
- (void)didSelectedSlideBarItemAtIndex:(NSInteger)index isLabelClicked:(BOOL)isLabelClicked{
    if (self.selectedIndex != index) {
        UILabel * label   = self.labelArray[index];
        
        if (isLabelClicked) {
            self.selectedLabel.textColor = self.normalColor;
            label.textColor   = self.selectedColor;
            
            if (self.slideBarStyle == JPSlideBarStyleTransformationAndGradientColor) {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    label.transform = CGAffineTransformMakeScale(JPSlideBarMaxScaleValur, JPSlideBarMaxScaleValur);
                    self.selectedLabel.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        }else if (self.slideBarStyle != JPSlideBarStyleShowSliderAndGradientColor){
            self.selectedLabel.textColor = self.normalColor;
            label.textColor   = self.selectedColor;
        }
        
        self.selectedLabel = label;
        self.selectedIndex= index;
    }
}

//  颜色渐变
- (void)displayGradientColorWithLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex scale:(CGFloat)scale{
    UILabel * leftLabel = self.labelArray[leftIndex];
    UILabel * rightLabel = self.labelArray[rightIndex];
    
    CGFloat RDValur = self.normalColor.RValue- self.selectedColor.RValue;
    CGFloat GDValur = self.normalColor.GValue- self.selectedColor.GValue;
    CGFloat BDValur = self.normalColor.BValue- self.selectedColor.BValue;
    
    if (scale > 0) {
        leftLabel.textColor =JColor_RGB_Float(self.selectedColor.RValue + scale * RDValur,
                                              self.selectedColor.GValue + scale * GDValur,
                                              self.selectedColor.BValue + scale * BDValur);
        
        rightLabel.textColor = JColor_RGB_Float(self.normalColor.RValue - scale * RDValur,
                                                self.normalColor.GValue - scale * GDValur,
                                                self.normalColor.BValue - scale * BDValur);
        
    }else if (scale < 0){
        leftLabel.textColor =JColor_RGB_Float(self.normalColor.RValue + scale * RDValur,
                                              self.normalColor.GValue + scale * GDValur,
                                              self.normalColor.BValue + scale * BDValur);
        
        rightLabel.textColor = JColor_RGB_Float(self.selectedColor.RValue - scale * RDValur,
                                                self.selectedColor.GValue - scale * GDValur,
                                                self.selectedColor.BValue - scale * BDValur);
    }
}

- (void)displayGradientSizeWithLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex scale:(CGFloat)scale{
    UILabel * leftLabel = self.labelArray[leftIndex];
    UILabel * rightLabel = self.labelArray[rightIndex];
    if (scale > 0) {
        rightLabel.transform = CGAffineTransformMakeScale(1+ scale * JPSlideBarScaleDValue, 1+ scale * JPSlideBarScaleDValue);
        leftLabel.transform = CGAffineTransformMakeScale(JPSlideBarMaxScaleValur- scale * JPSlideBarScaleDValue, JPSlideBarMaxScaleValur- scale * JPSlideBarScaleDValue);
    }else if (scale < 0){
        rightLabel.transform = CGAffineTransformMakeScale(JPSlideBarMaxScaleValur+ scale * JPSlideBarScaleDValue, JPSlideBarMaxScaleValur+ scale * JPSlideBarScaleDValue);
        leftLabel.transform = CGAffineTransformMakeScale(1- scale * JPSlideBarScaleDValue, 1- scale * JPSlideBarScaleDValue);
    }
}


//  滚动条偏移，尽量将选择的Label居中显示
- (void)resetSlideBarContentOffsetWithIndex:(NSInteger)index{
    
    CGFloat offsetX = [self.labelCenterXArray[index] floatValue] - JPScreen_Width / 2.0;
    if (offsetX >= 0) {
        if (offsetX + JPScreen_Width < self.scrollView.contentSize.width) {
            [self.scrollView setContentOffset:CGPointMake([self.labelCenterXArray[index] floatValue] - JPScreen_Width / 2.0, 0) animated:YES];
        }else{
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-JPScreen_Width,0) animated:YES];
        }
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

//  选中后slider滑动条偏移
- (void)movesliderLineToDestinationIndex:(NSInteger)index{
    if (self.slideBarStyle != JPSlideBarStyleChangeColorOnly &&
        self.slideBarStyle != JPSlideBarStyleGradientColorOnly) {
        CGRect rect = self.sliderLine.frame;
        rect.origin.x = [self.labelCenterXArray[index] floatValue]-[self.sliderWidthArray[index] floatValue]/2.0;
        rect.size.width = [self.sliderWidthArray[index] floatValue];
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.sliderLine.frame = rect;
        } completion:nil];
    }
}

#pragma mark - ToolMethod

//  计算字符串宽度
- (CGFloat)widthOfString:(NSString *)string{
    NSDictionary *attributes = @{NSFontAttributeName : self.font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, JPSlideBarHeight);
    CGSize size = [string boundingRectWithSize:maxSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil].size;
    return ceil(size.width);
}


#pragma mark - 懒加载

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JPScreen_Width, JPSlideBarHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator  = NO;
        _scrollView.bounces  = YES;
        _scrollView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0];
        [self.contentView addSubview:_scrollView];
    }return _scrollView;
}


- (NSMutableArray *)sliderWidthArray{
    if (!_sliderWidthArray) {
        _sliderWidthArray = [[NSMutableArray alloc]init];
    }return _sliderWidthArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]init];
    }return _titleArray;
}

- (NSMutableArray *)labelCenterXArray{
    if (!_labelCenterXArray) {
        _labelCenterXArray = [[NSMutableArray alloc]init];
    }return _labelCenterXArray;
}

- (UIFont *)font{
    if (!_font) {
        _font = JPSlider_Font;
    }return _font;
}

- (UIColor *)normalColor{
    if (!_normalColor) {
        _normalColor = JColor_RGB(255,255,255);
        _selectedColor = JColor_RGB(240,133,25);
    }return _normalColor;
}

- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc]init];
    }return _labelArray;
}


- (NSMutableArray *)labelWidthDValueArray{
    if (!_labelWidthDValueArray) {
        _labelWidthDValueArray = [[NSMutableArray alloc]init];
    }return _labelWidthDValueArray;
}

- (NSMutableArray *)labelCenterDValueArray{
    if (!_labelCenterDValueArray) {
        _labelCenterDValueArray =[[NSMutableArray alloc]init];
    }return _labelCenterDValueArray;
}

- (void)dealloc{
    if (self.observedScrollView) {
        [self.observedScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observedScrollView = nil;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    JKLog(@"%@被释放",[self class]);
}



#if 0
- (void)addMaskLayer{   // 头尾添加模糊遮罩，留着以后用
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.bounds = self.scrollView.bounds;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.position = self.scrollView.center;
    layer.startPoint = CGPointMake(1, 0);
    
    layer.endPoint = CGPointMake(0, 0);
    layer.colors = @[(__bridge id)[UIColor darkGrayColor].CGColor,(__bridge id)[[UIColor darkGrayColor]colorWithAlphaComponent:0.3].CGColor,(__bridge id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.9),@(0.95),@(1.0)];
    self.contentView.layer.mask = layer;
}
#endif


@end
