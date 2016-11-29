//
//  JMHeaderViewController.m
//  JMParallaxView
//
//  Created by Joel Marquez on 11/28/16.
//  Copyright © 2016 Joel Marquez. All rights reserved.
//

#import "JMHeaderViewController.h"

#import <JMParallaxView/JMParallaxView.h>

#import "Masonry.h"

@interface JMHeaderViewController () <UITableViewDelegate, UITableViewDataSource, JMParallaxViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *parallaxContentView;
@property (strong, nonatomic) UIImageView *parallaxHeader;

@property (strong, nonatomic) NSArray <NSString *> *dataSource;

@property (strong, nonatomic) JMParallaxView *parallaxView;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation JMHeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.opaque = YES;
    
    [self setupView];
    [self setupDataSource];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    self.parallaxHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header1"]];
    self.parallaxHeader.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200);
    self.parallaxHeader.contentMode = UIViewContentModeScaleAspectFill;
    self.parallaxHeader.clipsToBounds = YES;
    
    [self setupParallaxView];
}

- (void)setupParallaxView
{
    // Parallax creation
    
    self.parallaxView = [JMParallaxView new];
    self.parallaxView.delegate = self;
    self.parallaxView.headerTintColor = [UIColor whiteColor];
    [self.view addSubview:self.parallaxView];
    [self.parallaxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Parallax content view
    
    self.parallaxContentView = [UIView new];
    [self.parallaxContentView addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.parallaxContentView);
    }];
    
    // Setting parallax properties
    
    [self.parallaxView addScrollView:self.tableView];
    self.parallaxView.mainView = self.parallaxContentView;
    self.parallaxView.headerView = self.parallaxHeader;
}

- (void)setupDataSource
{
    self.dataSource = @[@"Row 1",
                        @"Row 2",
                        @"Row 3",
                        @"Row 4",
                        @"Row 5",
                        @"Row 6",
                        @"Row 7",
                        @"Row 8",
                        @"Row 9",
                        @"Row 10",
                        @"Row 11", 
                        @"Row 12", 
                        @"Row 13", 
                        @"Row 14", 
                        @"Row 15", 
                        @"Row 16", 
                        @"Row 17", 
                        @"Row 18", 
                        @"Row 19", 
                        @"Row 20", 
                        @"Row 21", 
                        @"Row 22", 
                        @"Row 23", 
                        @"Row 24", 
                        @"Row 25", 
                        @"Row 26", 
                        @"Row 27", 
                        @"Row 28" ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.parallaxView userDidStartDraggingScrollView:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.parallaxView userDidDragScrollView:scrollView toOffset:scrollView.contentOffset.y];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.parallaxView userDidDragScrollView:scrollView toOffset:scrollView.contentOffset.y];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.parallaxView userDidEndDraggingScrollView:scrollView toOffset:targetContentOffset];
}

#pragma mark - JMParallaxViewDelegate

- (void)parallaxView:(JMParallaxView *)parallaxView didChangeState:(JMParallaxState)fromState
             toState:(JMParallaxState)toState
{
    CATransition *fade = [CATransition animation];
    fade.type = kCATransitionFade;
    fade.duration = 0.1;
    [self.navigationController.navigationBar.layer addAnimation:fade forKey:nil];
    
    switch (toState) {
        case JMParallaxStateOnBottom:
        case JMParallaxStateNearBottom: {
            if (fromState != JMParallaxStateOnBottom && fromState != JMParallaxStateNearBottom) {
                self.titleLabel.text = self.title;
                [self.titleLabel sizeToFit];
                self.tableView.showsVerticalScrollIndicator = NO;
            }
        }
            break;
            
        case JMParallaxStateOnTop:
        case JMParallaxStateNearTop: {
            if (fromState != JMParallaxStateOnTop && fromState != JMParallaxStateNearTop) {
                self.titleLabel.text = @"Scrolled!";
                [self.titleLabel sizeToFit];
                self.tableView.showsVerticalScrollIndicator = YES;
            }
        }
            break;
            
        default:
            break;
    }
}

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.title;
    [_titleLabel sizeToFit];
    
    return _titleLabel;
}

@end
