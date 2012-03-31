//
//  meicanViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "meicanViewController.h"
#import "GongwentongFetcher.h"
#import "WebViewController.h"
@interface meicanViewController ()

@end

@implementation meicanViewController
@synthesize dishes;
@synthesize webViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"美餐";
    }
    return self;
}
-(void )viewDidAppear:(BOOL)animated{
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSArray *getspots = [GongwentongFetcher getMCList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dishes = getspots;
            [self.tableView reloadData];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.dishes count]>0)return [self.dishes count]+1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dishCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell.
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"  www.meican.com ";
        
    }else {
        NSDictionary *t= [self.dishes objectAtIndex:indexPath.row-1] ;
        cell.textLabel.text=[t objectForKey:@"name"];
        cell.detailTextLabel.text=@"";
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return;
    }
    if (!self.webViewController) {
        self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }
    NSDictionary *t= [self.dishes objectAtIndex:indexPath.row-1] ;

    [self.webViewController setType:@"meican"];
    [self.webViewController setURL:[t objectForKey:@"uuid"]];
    [self.webViewController setWbtitle:[[NSString alloc] initWithFormat:@"%@%@",@"@美餐网 分享：",[t objectForKey:@"name"]]];
    [self.navigationController pushViewController:self.webViewController animated:YES];}

@end
