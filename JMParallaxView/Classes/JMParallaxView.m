//
//  JMParallaxView.m
//  JMParallaxView
//
//  Created by Joel Marquez on 11/25/16.
//  Copyright © 2016 Joel Marquez. All rights reserved.
//

#import "JMParallaxView.h"

#import "Masonry.h"

@interface JMParallaxView()

@property (strong, nonatomic) UIView *headerViewContainer;
@property (strong, nonatomic) UIView *stickyViewContainer;
@property (strong, nonatomic) UIView *mainViewContainer;
@property (strong, nonatomic) UIView *tintView;

@property (strong, nonatomic) MASConstraint *topHeaderConstraint;
@property (strong, nonatomic) MASConstraint *bottomStickyConstraint;
@property (strong, nonatomic) MASConstraint *headerHeightConstraint;

@property (assign, nonatomic) CGFloat headerViewContainerOffset;
@property (assign, nonatomic) CGFloat stickyViewContainerOffset;

@property (assign, nonatomic) CGFloat initialOffset;

@property (assign, nonatomic) CGFloat headerHeight;

@property (strong, nonatomic) NSMutableArray *scrollViews;

@end

@implementation JMParallaxView

#pragma mark - Setup

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.headerViewContainer = [UIView new];
    self.stickyViewContainer = [UIView new];
    self.mainViewContainer = [UIView new];
    
    self.tintView = [UIView new];
    self.headerTintColor = [UIColor clearColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.headerViewContainer];
    [self addSubview:self.mainViewContainer];
    [self addSubview:self.tintView];
    [self addSubview:self.stickyViewContainer];
}

- (void)setHeaderTintColor:(UIColor *)headerTintColor
{
    _headerTintColor = headerTintColor;
    
    self.tintView.alpha = 0.0f;
    self.tintView.backgroundColor = headerTintColor;
}

- (void)addScrollView:(UIScrollView *)newScrollView
{
    if (self.scrollViews == nil) {
        self.scrollViews = [NSMutableArray array];
    }
    
    if ([self.scrollViews containsObject:newScrollView]) {
        return;
    }
    
    [self setContentInset:UIEdgeInsetsMake(self.initialOffset, 0, 0, 0)
            forScrollView:newScrollView];
    [self setContentOffset:CGPointMake(newScrollView.contentOffset.x, _offset)
             forScrollView:newScrollView animated:NO];
    
    [self.scrollViews addObject:newScrollView];
}

#pragma mark - Offset methods

- (void)setOffset:(CGFloat)newOffset
{
    JMParallaxState previousState = [self parallaxState];
    
    // We do this to truncate the number of decimals in extreme cases
    newOffset = ((int)(newOffset * 100) / 100.0);

    CGFloat deltaOffset = newOffset - _offset;
    
    self.headerViewContainerOffset -= deltaOffset / 2.0f;
    [self.topHeaderConstraint setOffset:self.headerViewContainerOffset];

    self.stickyViewContainerOffset -= deltaOffset;
    [self.bottomStickyConstraint setOffset:self.stickyViewContainerOffset];

    [self.headerHeightConstraint setSizeOffset:
     CGSizeMake(0, MAX(- newOffset - CGRectGetHeight(self.stickyViewContainer.frame),
                       self.initialOffset - CGRectGetHeight(self.stickyViewContainer.frame)))];
    
    [self layoutIfNeeded];
    
    self.tintView.alpha = 1 - (self.stickyViewContainer.frame.origin.y /
                               (self.headerHeight - CGRectGetHeight(self.stickyViewContainer.frame)));
    
    _offset = newOffset;
    
    JMParallaxState currentState = [self parallaxState];
    
    if (previousState != currentState) {
        if ([self.delegate respondsToSelector:@selector(parallaxView:didChangeState:toState:)]) {
            [self.delegate parallaxView:self didChangeState:previousState toState:currentState];
        }
    }
}

- (JMParallaxState)parallaxStateWithOffset:(CGFloat)anOffset
{
    anOffset = -anOffset;
    
    if (anOffset < CGRectGetHeight(self.stickyViewContainer.frame)) {
        return JMParallaxStateOnTop;
    } else if(anOffset < (self.headerHeight + CGRectGetHeight(self.stickyViewContainer.frame)) * 0.5f) {
        return JMParallaxStateNearTop;
    } else if (anOffset >= self.headerHeight + CGRectGetHeight(self.stickyViewContainer.frame)) {
        return JMParallaxStateOnBottom;
    } else {
        return JMParallaxStateNearBottom;
    }
}

- (JMParallaxState)parallaxState
{
    return [self parallaxStateWithOffset:self.offset];
}

- (void)userDidStartDraggingScrollView:(UIScrollView *)draggedScrollView
{
    self.headerViewContainer.userInteractionEnabled = NO;
    self.stickyViewContainer.userInteractionEnabled = NO;
}

- (void)userDidDragScrollView:(UIScrollView *)draggedScrollView toOffset:(CGFloat)offset
{
    [self setOffset:offset];
    
    // We synchronize the other scrollViews to match the current scrollView movement
    for (UIScrollView *scrollView in self.scrollViews) {
        if (scrollView != draggedScrollView) {
            CGFloat stickyViewBottom = - (CGRectGetHeight(self.stickyViewContainer.frame) +
                                          self.stickyViewContainer.frame.origin.y);
            
            // If the scrollView is under the stickyView or the stickyView is not at the top
            if (scrollView.contentOffset.y <= stickyViewBottom || self.stickyViewContainer.frame.origin.y > 0) {
                [self setContentOffset:CGPointMake(0, stickyViewBottom) forScrollView:scrollView animated:NO];
            }
        }
    }
}

- (void)userDidEndDraggingScrollView:(UIScrollView *)draggedScrollView toOffset:(inout CGPoint *)targetOffset
{
    self.headerViewContainer.userInteractionEnabled = YES;
    self.stickyViewContainer.userInteractionEnabled = YES;
    
    switch ([self parallaxStateWithOffset:targetOffset->y]) {
        case JMParallaxStateNearTop: {
            // The top is a special case. It scrolls to the top only if the content of the scrollView content can fill all the screen. If not, it scrolls only to the targetOffset
            if (draggedScrollView.contentSize.height >=
                CGRectGetHeight(self.frame) - CGRectGetHeight(self.stickyViewContainer.frame)) {
                targetOffset->y = - CGRectGetHeight(self.stickyViewContainer.frame);
            }
        }
            break;

        case JMParallaxStateNearBottom: {
            // Move all the views to the bottom
            targetOffset->y = - self.headerHeight - CGRectGetHeight(self.stickyViewContainer.frame);
        }
            break;
            
        case JMParallaxStateOnTop:
        case JMParallaxStateOnBottom:
            break;
    }
}

#pragma mark - Move scrollviews

- (void)setInitialOffset:(CGFloat)initialOffset
{
    _initialOffset = initialOffset;
    
    for (UIScrollView *scrollView in self.scrollViews) {
        [self setContentInset:UIEdgeInsetsMake(initialOffset, 0, 0, 0) forScrollView:scrollView];
    }
}

- (void)setContentOffset:(CGPoint)offset forScrollView:(UIScrollView *)scrollView animated:(BOOL)animated
{
    id oldDelegate = scrollView.delegate;
    scrollView.delegate = nil;
    [scrollView setContentOffset:offset animated:animated];
    scrollView.delegate = oldDelegate;
}

- (void)setContentInset:(UIEdgeInsets)insets forScrollView:(UIScrollView *)scrollView
{
    id oldDelegate = scrollView.delegate;
    scrollView.delegate = nil;
    scrollView.contentInset = insets;
    scrollView.delegate = oldDelegate;
}

#pragma mark - Set parallax layout

- (void)resetParallaxView
{
    self.headerViewContainerOffset = 0;
    
    if (self.headerView) {
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.headerViewContainer);
        }];
        
        [self.headerViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            self.topHeaderConstraint = make.top.equalTo(self.mas_top).offset(self.headerViewContainerOffset).priorityLow();
            make.top.lessThanOrEqualTo(self.mas_top).priorityHigh();
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            self.headerHeightConstraint = make.height.mas_equalTo(CGRectGetHeight(self.headerView.frame));
        }];
        
        [self.tintView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.stickyViewContainer.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self.headerViewContainer.mas_height).offset(CGRectGetHeight(self.stickyView.frame));
        }];
    }
    
    self.stickyViewContainerOffset = CGRectGetHeight(self.headerView.frame) + CGRectGetHeight(self.stickyView.frame);
    
    if (self.stickyView) {
        [self.stickyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.stickyViewContainer);
        }];
    }

    [self.stickyViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        self.bottomStickyConstraint = make.bottom.equalTo(self.mas_top).offset(self.stickyViewContainerOffset).priorityLow();
        make.top.greaterThanOrEqualTo(self.mas_top).priorityHigh();
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(CGRectGetHeight(self.stickyView.frame));
    }];
    
    if (self.mainView) {
        [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.mainViewContainer);
        }];
        
        [self.mainViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    [self layoutIfNeeded];
    
    self.headerHeight = CGRectGetHeight(self.headerView.frame);

    self.initialOffset = self.headerHeight + CGRectGetHeight(self.stickyView.frame);
    _offset = - self.initialOffset;
    
    for (UIScrollView *scrollView in self.scrollViews) {
        [self setContentOffset:CGPointMake(scrollView.contentOffset.x, _offset)
                 forScrollView:scrollView animated:NO];
    }
}

- (void)setHeaderView:(UIView *)headerView
{
    if (self.headerView == headerView) {
        return;
    }
    
    [self.headerView removeFromSuperview];
    _headerView = headerView;
    
    [self.headerViewContainer addSubview:headerView];
    
    [self resetParallaxView];
}

- (void)setStickyView:(UIView *)stickyView
{
    if (self.stickyView == stickyView) {
        return;
    }
    
    [self.stickyView removeFromSuperview];
    _stickyView = stickyView;

    [self.stickyViewContainer addSubview:stickyView];
    
    [self resetParallaxView];
}

- (void)setMainView:(UIView *)mainView
{
    if (self.mainView == mainView) {
        return;
    }
    
    [self.mainView removeFromSuperview];
    _mainView = mainView;

    [self.mainViewContainer addSubview:mainView];
    
    [self resetParallaxView];
}

#pragma mark - Manejo de toques

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // If the touch point is inside the header, we pass it
    if (point.y < - self.offset - CGRectGetHeight(self.stickyView.frame)) {
        return [self.headerViewContainer hitTest:point withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
}

@end
