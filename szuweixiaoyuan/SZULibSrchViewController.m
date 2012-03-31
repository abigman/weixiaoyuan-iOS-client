//
//  SZULibSrchViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SZULibSrchViewController.h"
#import "GongwentongFetcher.h"
#import "WebViewController.h"
@interface SZULibSrchViewController ()

@end

@implementation SZULibSrchViewController
@synthesize webViewController;
@synthesize szulibsrchbar;
@synthesize books;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"深大图书馆";
    }
    return self;
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
    [self setSzulibsrchbar:nil];
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

    // Return the number of rows in the section.
    return [books count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *array =[[NSArray alloc] initWithArray: [[self.books objectAtIndex:indexPath.row] componentsSeparatedByString:@"<br/>"]];
    // Configure the cell.
    if ([array count]<7) {
        cell.textLabel.text =@"";
        cell.detailTextLabel.text =@"";
        return cell;
    }
    cell.textLabel.text =[array objectAtIndex:1];
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"%@%@",@"作者:",[array objectAtIndex:2]];
    cell.detailTextLabel.text=[[NSString alloc]initWithFormat:@"%@%@",cell.detailTextLabel.text,@"可借:"];
    cell.detailTextLabel.text=[[NSString alloc]initWithFormat:@"%@%@",cell.detailTextLabel.text,[array objectAtIndex:7]];
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
    if (!self.webViewController) {
        self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }

    NSString *t= [self.books objectAtIndex:indexPath.row] ;
    NSArray *array =[[NSArray alloc] initWithArray: [t componentsSeparatedByString:@"<br/>"]];
    if ([array count]<4)return;
    [self.webViewController setType:@"lib"];
    [self.webViewController setURL:[array objectAtIndex:0]];
    [self.webViewController setWbtitle:[[NSString alloc] initWithFormat:@"%@%@",@"@深圳大学图书馆 分享：",[array objectAtIndex:1]]];
    [self.navigationController pushViewController:self.webViewController animated:YES];
}
#pragma mark - Search Bar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchTerm=[searchBar text];
    [searchBar resignFirstResponder];
    [self handleSearchForTerm:searchTerm];
    
}
- (void) handleSearchForTerm:(NSString *)searchTerm{
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSString *getspots = [GongwentongFetcher getlibsrch:searchTerm];
        NSArray *array =[[NSArray alloc] initWithArray: [getspots componentsSeparatedByString:@"<hr/>"]];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.books = array;
            [self.tableView reloadData];
            UIApplication *app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            //app.statusBarStyle=UIStatusBarStyleBlackTranslucent;
            
        });
    });
    dispatch_release(downloadQueue);
}
@end
