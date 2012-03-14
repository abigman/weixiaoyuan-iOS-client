//
//  WebViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "GongwentongFetcher.h"

@implementation WebViewController

@synthesize webview;
@synthesize URL=_URL;
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
-(void)viewDidAppear:(BOOL)animated{
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSString *getspots = [GongwentongFetcher getGWTContent:_URL];
        
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
    // Do any additional setup after loading the view from its nib.
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

@end
