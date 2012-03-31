//
//  GWTListViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GWTListViewController.h"

#import "GongwentongFetcher.h"
#import "WebViewController.h"
@implementation GWTListViewController

@synthesize webViewController = _webViewController;
@synthesize MainItems;
@synthesize MasterTVCListtems;
@synthesize page;
@synthesize loading;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"深大公文通";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated{
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        page=0;
        NSArray *getspots;
        if (self.type) {
            self.title=@"校长信箱";
            getspots = [GongwentongFetcher getMAILList:[page intValue]];
        }else {
            getspots = [GongwentongFetcher getGWTList:[page intValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.MasterTVCListtems = getspots;
            [self.tableView reloadData];
            UIApplication *app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            page=[NSNumber numberWithInt:[page intValue]+1];
            //app.statusBarStyle=UIStatusBarStyleBlackTranslucent;
            
        });
    });
    dispatch_release(downloadQueue);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.MasterTVCListtems.count==0) {
        return 0;
    }
    return self.MasterTVCListtems.count+1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GWTListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    if (indexPath.row>=self.MasterTVCListtems.count) {
        cell.textLabel.text =@"  更多…";
        cell.detailTextLabel.text=nil;
    }else {
        NSDictionary *t=[self.MasterTVCListtems objectAtIndex:indexPath.row];
        cell.textLabel.text = [t valueForKeyPath:@"title"];
        if (self.type) {
            cell.detailTextLabel.text=[[NSString alloc] initWithFormat:@"回复时间%@",[t valueForKeyPath:@"reply_time"]];
        }else {
            cell.detailTextLabel.text=[[NSString alloc] initWithFormat:@"%@%@%@",[t valueForKeyPath:@"posttime"],@" by ",[t valueForKeyPath:@"unit"]];
        }
        
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.webViewController) {
        self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }
    if (indexPath.row>=self.MasterTVCListtems.count){
        if ([loading intValue]==1) {
            return;
        }
        dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
        
        
        dispatch_async(downloadQueue, ^{
            loading=[NSNumber numberWithInt:1];
            UIApplication *app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = YES;
            NSArray *getspots;
            if (self.type) {
                self.title=@"校长信箱";
                getspots = [GongwentongFetcher getMAILList:[page intValue]];
            }else {
                getspots = [GongwentongFetcher getGWTList:[page intValue]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.MasterTVCListtems =[self.MasterTVCListtems arrayByAddingObjectsFromArray: getspots];
                [self.tableView reloadData];
                loading=[NSNumber numberWithInt:0];
                UIApplication *app = [UIApplication sharedApplication];
                app.networkActivityIndicatorVisible = NO;
                page=[NSNumber numberWithInt:[page intValue]+1];
                //app.statusBarStyle=UIStatusBarStyleBlackTranslucent;
                
            });
        });
        dispatch_release(downloadQueue);
        return;
    }
    NSDictionary *t=[self.MasterTVCListtems objectAtIndex:indexPath.row];
    if (self.type) {
        [self.webViewController setURL:[t valueForKeyPath:@"mid"]];
        [self.webViewController setType:@"xzxx"];
        [self.webViewController setWbtitle:[[NSString alloc] initWithFormat:@"%@%@",@"@深大微校园 深大校长信箱分享：",[t valueForKeyPath:@"title"]]];
    }else {
        [self.webViewController setURL:[t valueForKeyPath:@"nid"]];
        [self.webViewController setWbtitle:[[NSString alloc] initWithFormat:@"%@%@",@"@深大微校园 深大公文通分享：",[t valueForKeyPath:@"title"]]];
    }
    
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

@end
