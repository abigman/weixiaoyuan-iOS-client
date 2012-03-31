//
//  meicanViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;
@interface meicanViewController : UITableViewController
@property(strong,nonatomic)NSArray *dishes;
@property(strong,nonatomic)WebViewController *webViewController;
@end
