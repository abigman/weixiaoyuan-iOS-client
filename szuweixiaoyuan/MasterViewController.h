//
//  MasterViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class GWTListViewController;
@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property(strong,nonatomic)GWTListViewController *gwtListViewController;
@property(strong,nonatomic)NSString *MainItems;
@property(strong,nonatomic)NSArray *MasterTVCListtems;
@end
