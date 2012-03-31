//
//  SZULibSrchViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;
@interface SZULibSrchViewController : UITableViewController<UISearchBarDelegate>
@property(strong,nonatomic)WebViewController *webViewController;
@property (strong, nonatomic) IBOutlet UISearchBar *szulibsrchbar;
@property(strong,nonatomic)NSArray *books;
@end
