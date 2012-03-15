//
//  LOVJOBViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;
@interface LOVJOBViewController : UITableViewController
@property(strong,nonatomic)NSArray *jobs;
@property(strong,nonatomic)WebViewController *webViewController;
@end
