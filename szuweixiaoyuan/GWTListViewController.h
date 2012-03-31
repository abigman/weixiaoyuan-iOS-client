//
//  GWTListViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController;

@interface GWTListViewController : UITableViewController

@property (strong, nonatomic) WebViewController *webViewController;
@property(strong,nonatomic)NSString *MainItems;
@property(strong,nonatomic)NSArray *MasterTVCListtems;
@property(nonatomic,strong)NSNumber *page;
@property(nonatomic,strong)NSNumber *loading;
@property(nonatomic,strong)NSString *type;
@end
