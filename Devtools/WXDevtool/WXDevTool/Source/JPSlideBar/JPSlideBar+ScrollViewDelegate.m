//
//  JPSlideBar+ScrollViewDelegate.m
//  JPSlideBar
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import "JPSlideBar+ScrollViewDelegate.h"

@implementation JPSlideNavigationBar (ScrollViewDelegate)

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
//        [self.delegate scrollViewDidEndDecelerating:scrollView];
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:JPScrollViewDidEndDeceleratingNotification object:nil userInfo:@{JPScrollViewContentOffsetX:@(scrollView.contentOffset.x)}];
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2){
    if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
//        [self.delegate scrollViewWillBeginDecelerating:scrollView];
//    }
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]){
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
//        [self.delegate scrollViewWillBeginDecelerating:scrollView];
//    }
//}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.delegate viewForZoomingInScrollView:scrollView];
    }return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
    if([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]){
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    }return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.delegate scrollViewDidScrollToTop:scrollView];
    }
}


@end
