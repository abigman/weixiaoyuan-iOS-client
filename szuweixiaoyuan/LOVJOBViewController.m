//
//  LOVJOBViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LOVJOBViewController.h"
#import "GongwentongFetcher.h"
#import "WebViewController.h"
@interface LOVJOBViewController ()

@end

@implementation LOVJOBViewController
@synthesize jobs;
@synthesize webViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"爱兼职";
    }
    return self;
}
-(void )viewDidAppear:(BOOL)animated{
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSArray *getspots = [GongwentongFetcher getLOVJOB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.jobs = getspots;
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
    return self.jobs.count;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 80;
    }else {
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"lovjoblistCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell.
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"找兼职，就选择爱兼职~！";
        cell.detailTextLabel.text=@"  www.lovingjob.com ";

    }else {
        NSString *t= [self.jobs objectAtIndex:indexPath.row-1] ;
        NSArray *array =[[NSArray alloc] initWithArray: [t componentsSeparatedByString:@"<br/>"]];
        
        if ([array count]>4) {
            t=[[NSString alloc] initWithFormat:@"%@%@%@%@",[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:4],[array objectAtIndex:5]];
            cell.textLabel.text =[array objectAtIndex:3];
            cell.detailTextLabel.text=t;
        }else {
            cell.textLabel.text=@"";
            cell.detailTextLabel.text=@"";
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
    NSString *t= [self.jobs objectAtIndex:indexPath.row-1] ;
    NSArray *array =[[NSArray alloc] initWithArray: [t componentsSeparatedByString:@"<br/>"]];
    if ([array count]<4)return;
    [self.webViewController setType:@"lovjob"];
    [self.webViewController setURL:[array objectAtIndex:0]];
    [self.webViewController setWbtitle:[[NSString alloc] initWithFormat:@"%@%@",@"@深圳爱兼职网 分享：",[array objectAtIndex:3]]];
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

@end
