//
//  SZUCALLoginViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUCALTableViewController.h"
@interface SZUCALLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *xingming;
@property (strong, nonatomic) IBOutlet UITextField *xuehao;
- (IBAction)loginpressed:(UIButton *)sender;
@property (strong,nonatomic)SZUCALTableViewController *szuCALTableViewController;
@end
