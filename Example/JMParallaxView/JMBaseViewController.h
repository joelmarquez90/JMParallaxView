//
//  JMBaseViewController.h
//  JMParallaxView
//
//  Created by Joel Marquez on 11/29/16.
//  Copyright © 2016 Joel Marquez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JMParallaxView/JMParallaxView.h>

#import <Masonry/Masonry.h>

@interface JMBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, JMParallaxViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *parallaxContentView;
@property (strong, nonatomic) UIImageView *parallaxHeader;

@property (strong, nonatomic) NSArray <NSString *> *dataSource;

@property (strong, nonatomic) JMParallaxView *parallaxView;

@property (strong, nonatomic) UILabel *titleLabel;

- (void)setupParallaxView;

@end
