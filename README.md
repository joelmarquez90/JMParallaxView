# JMParallaxView

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JMParallaxView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JMParallaxView"
```

## Usage

### Simple header

##### 1. Create a tableView:

```objective-c
self.tableView = [UITableView new];
self.tableView.delegate = self;
```

##### 2. Create a header:

```objective-c
self.parallaxHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header1"]];
self.parallaxHeader.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200);
self.parallaxHeader.contentMode = UIViewContentModeScaleAspectFill;
self.parallaxHeader.clipsToBounds = YES;
```

##### 3. Create a `JMParallaxView`:

```objective-c
self.parallaxView = [JMParallaxView new];
self.parallaxView.delegate = self;
self.parallaxView.headerTintColor = [UIColor whiteColor];
[self.view addSubview:self.parallaxView];
[self.parallaxView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
}];
```

##### 4. Create a parallax content view:
```objective-c
self.parallaxContentView = [UIView new];
[self.parallaxContentView addSubview:self.tableView];
[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.parallaxContentView);
}];
```

##### 5. Pluging in all the stuff together:

```objective-c
[self.parallaxView addScrollView:self.tableView];
self.parallaxView.mainView = self.parallaxContentView;
self.parallaxView.headerView = self.parallaxHeader;
```

##### 6. Implement scroll view delegate methods in order to notify the parallaxView for scroll events:

```objective-c
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
```
##### 7. Enjoy

![enjoy](http://i.giphy.com/l3vQZiDorvDVCbgHK.gif)

##### Note: optionally you could also implement the JMParallaxViewDelegate method in order to know the current state of the parallaxView:

```objective-c
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
               self.titleLabel.text = @"Header";
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
```

### Header with sticky view

Follow all the previous step, and in the final one, add this line:

```objective-c
UILabel *stickyLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60)];
stickyLabel.text = @"I'm a sticky label!";
stickyLabel.backgroundColor = [UIColor orangeColor];
stickyLabel.textAlignment = NSTextAlignmentCenter;

self.parallaxView.stickyView = stickyLabel;
```

##### Voilá!

![enjoy](http://i.giphy.com/3oz8xu4R96MdTVRK00.gif)

## Author

Joel Marquez, 90joelmarquez@gmail.com

## License

JMParallaxView is available under the MIT license. See the LICENSE file for more info.
