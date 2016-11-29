//
//  JMParallaxView.h
//  JMParallaxView
//
//  Created by Joel Marquez on 11/25/16.
//  Copyright © 2016 Joel Marquez. All rights reserved.
//

typedef NS_ENUM(NSInteger, JMParallaxState)
{
    JMParallaxStateNearTop,
    JMParallaxStateNearBottom,
    JMParallaxStateOnTop,
    JMParallaxStateOnBottom
};


@protocol JMParallaxViewDelegate;


@interface JMParallaxView : UIView

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *stickyView;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIColor *headerTintColor;

@property (readonly, nonatomic) CGFloat offset;

@property (weak, nonatomic) id <JMParallaxViewDelegate> delegate;

- (void)userDidStartDraggingScrollView:(UIScrollView*)draggedScrollView;
- (void)userDidDragScrollView:(UIScrollView*)draggedScrollView toOffset:(CGFloat)offset;
- (void)userDidEndDraggingScrollView:(UIScrollView*)draggedScrollView toOffset:(inout CGPoint *)targetOffset;

- (void)addScrollView:(UIScrollView*)newScrollView;

- (void)resetParallaxView;

@end


@protocol JMParallaxViewDelegate <NSObject>

@optional

- (void)parallaxView:(JMParallaxView *)parallaxView didChangeState:(JMParallaxState)fromState toState:(JMParallaxState)toState;

@end
