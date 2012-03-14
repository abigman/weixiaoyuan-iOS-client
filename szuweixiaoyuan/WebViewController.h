//
//  WebViewController.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate> {    
    
}
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong,nonatomic)NSString *URL;
@end
