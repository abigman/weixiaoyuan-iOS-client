//
//  SZUCALTableViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
@interface SZUCALTableViewController : UITableViewController<UIAlertViewDelegate>
@property(strong,nonatomic)NSString *q;
@property(strong,nonatomic)NSArray *callist;
@property(strong,nonatomic)NSArray *headers;
@property(strong,nonatomic)NSArray *sectioncounts;
@property(strong,nonatomic)EKEvent *event;
@property(strong,nonatomic)EKEventStore *eventStore;
@end
