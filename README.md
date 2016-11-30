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

##### 1. Create a tableView:

```objective-c
self.tableView = [UITableView new];
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

##### 6. Enjoy

![enjoy](http://memeshappen.com/media/created/Enjoy--meme-50385.jpg)

## Author

Joel Marquez, 90joelmarquez@gmail.com

## License

JMParallaxView is available under the MIT license. See the LICENSE file for more info.
