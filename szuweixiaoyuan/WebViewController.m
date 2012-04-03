//
//  WebViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//

#import "WebViewController.h"
#import "GongwentongFetcher.h"
//#define kWBSDKDemoAppKey
//#define kWBSDKDemoAppSecret

#ifndef kWBSDKDemoAppKey
#define kWBSDKDemoAppKey @""
#endif

#ifndef kWBSDKDemoAppSecret
#define kWBSDKDemoAppSecret @""
#endif
@implementation WebViewController

@synthesize webview;
@synthesize URL=_URL;
@synthesize type;//公文还是爱兼职？
@synthesize wbtitle;
@synthesize weiBoEngine;
- (void)setURL:(id)newURL
{
    _URL = newURL;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [webview loadHTMLString:@"<center>读取中 ……</center>" baseURL:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 148, 45)]; 
    [tools setTintColor:self.navigationController.navigationBar.tintColor]; 
    [tools setAlpha:[self.navigationController.navigationBar alpha]]; 
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2]; 
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"登出" 
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self 
                                                                     action:@selector(onLogoutButtonPressed)];
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"分享到微博" 
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self 
                                                                      action:@selector(onSendButtonPressed)];
    [buttons addObject:anotherButton]; 

    [buttons addObject:anotherButton1]; 

    [tools setItems:buttons animated:NO]; 

    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools]; 
    self.navigationItem.rightBarButtonItem = myBtn;

    
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSString *getspots;
        NSString *sourceurl=@"";
        if (self.type) {
            if ([self.type isEqualToString:@"lib"]){
                self.title=@"藏书详情";
                getspots = [GongwentongFetcher getlibContent:_URL];
                sourceurl=[[NSString alloc]initWithFormat:@"%@%@", @"http://opac.lib.szu.edu.cn/opac/bookinfo.aspx?ctrlno=",_URL];
            }else if ([self.type isEqualToString:@"meican"]) {
                self.title=@"";
                getspots = [GongwentongFetcher getMCContent:_URL];
                sourceurl=[[NSString alloc]initWithFormat:@"%@%@", @"http://meican.com/restaurant/",_URL];
            }else if ([self.type isEqualToString:@"xzxx"]) {
                self.title=@"";
                getspots = [GongwentongFetcher getMAILContent:_URL];
                sourceurl=[[NSString alloc]initWithFormat:@"%@%@", @"http://www.weixiaoyuan.com/html5/mailbox_content?mid=",_URL];
            }else{
                self.title=@"";
                getspots = [GongwentongFetcher getLOVContent:_URL];
                sourceurl=[[NSString alloc]initWithFormat:@"%@%@", @"http://www.lovingjob.com/job.action?jobs.jid=",_URL];
            }
            
        }else {
            self.title=@"";
            getspots = [GongwentongFetcher getGWTContent:_URL];
            sourceurl=[[NSString alloc]initWithFormat:@"%@%@", @"http://www.weixiaoyuan.com/html5/news_content?nid=",_URL];
        }
        sourceurl = [sourceurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _URL =sourceurl;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [webview loadHTMLString:getspots baseURL:nil];
            
            UIApplication *app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            //app.statusBarStyle=UIStatusBarStyleBlackTranslucent;
            
        });
    });
    dispatch_release(downloadQueue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WBEngine *tengine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [tengine setRootViewController:self];
    [tengine setDelegate:self];
    [tengine setRedirectURI:@"http://"];
    [tengine setIsUserExclusive:NO];
    self.weiBoEngine = tengine;
}

- (void)viewDidUnload
{
    [self setWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)onLogoutButtonPressed{
    [weiBoEngine logOut];
}
- (void)onSendButtonPressed
{
    if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        
        NSString *weibotext=[[NSString alloc] initWithFormat:@"%@ 详细地址： %@ (外网可用)-#深大勃校园#iOS开源客户端",self.wbtitle,_URL];
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:weibotext image:nil];
        [sendView setDelegate:self];
        [sendView show:YES];
    }else {
        [weiBoEngine logIn];
    }
    
}
- (void)engineDidLogIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    NSString *weibotext=[[NSString alloc] initWithFormat:@"%@ 详细地址： %@ (外网可用)-#深大勃校园#iOS开源客户端",self.wbtitle,_URL];
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:weibotext image:nil];
    [sendView setDelegate:self];
    [sendView show:YES];
}
#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [indicatorView stopAnimating];
    NSLog(@"requestDidSucceedWithResult: %@", result);

}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    NSLog(@"requestDidFailWithError: %@", error);
}

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    NSLog(@"sendViewNotAuthorized");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    NSLog(@"sendViewAuthorizeExpired");
    [self dismissModalViewControllerAnimated:YES];
}

@end
