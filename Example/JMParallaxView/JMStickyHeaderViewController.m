//
//  JMStickyHeaderViewController.m
//  JMParallaxView
//
//  Created by Joel Marquez on 11/28/16.
//  Copyright © 2016 Joel Marquez. All rights reserved.
//

#import "JMStickyHeaderViewController.h"

@interface JMStickyHeaderViewController ()

@end

@implementation JMStickyHeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.parallaxHeader.image = [UIImage imageNamed:@"header2"];
}

- (void)setupParallaxView
{
    [super setupParallaxView];
    
    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60)];
    stickyLabel.text = @"I'm a sticky label!";
    stickyLabel.backgroundColor = [UIColor orangeColor];
    stickyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.parallaxView.stickyView = stickyLabel;
    self.parallaxView.headerTintColor = [UIColor orangeColor];
}

@end
