//
//  WebViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
@interface WebViewController : UIViewController<UIWebViewDelegate,WBEngineDelegate, WBSendViewDelegate> {    
    NSString *appKey;
    NSString *appSecret;
    
    WBEngine *engine;
    NSMutableArray *timeLine;
    
    UITableView *timeLineTableView;
    UIActivityIndicatorView *indicatorView;
}
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong,nonatomic)NSString *URL;
@property(strong,nonatomic)NSString *type;
@property(strong,nonatomic)NSString *wbtitle;
@property (nonatomic, retain) WBEngine *weiBoEngine;
@end
