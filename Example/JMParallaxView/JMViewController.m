//
//  JMViewController.m
//  JMParallaxView
//
//  Created by Joel Marquez on 11/28/2016.
//  Copyright (c) 2016 Joel Marquez. All rights reserved.
//

#import "JMViewController.h"

#import "JMHeaderViewController.h"
#import "JMStickyHeaderViewController.h"

#import "Masonry.h"

static NSString *const kJMTitle = @"JMTitle";
static NSString *const kJMViewControllerClassName = @"JMViewControllerClassName";

@interface JMViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation JMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.dataSource = @[@{kJMTitle: @"Header", kJMViewControllerClassName:
                              NSStringFromClass(JMHeaderViewController.class)},
                        @{kJMTitle: @"Header + Sticky view", kJMViewControllerClassName:
                              NSStringFromClass(JMStickyHeaderViewController.class)}];
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
    
    cell.textLabel.text = self.dataSource[indexPath.row][kJMTitle];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.dataSource[indexPath.row][kJMViewControllerClassName];
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    
    vc.title = self.dataSource[indexPath.row][kJMTitle];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
