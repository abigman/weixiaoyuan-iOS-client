//
//  MasterViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "GWTListViewController.h"
#import "SZUCALLoginViewController.h"
@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize gwtListViewController;
@synthesize szuCALLoginViewController;
@synthesize MainItems;
@synthesize MasterTVCListtems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"深大加油";
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.MasterTVCListtems = [[NSArray alloc] initWithObjects:
                                @"深圳大学校园公文通", @"我的课程表", @"荔园晨风兼职",
                              @"外卖菜单",@"反馈意见",@"Git项目期待您的加入",nil]; 

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return self.MasterTVCListtems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell.
    cell.textLabel.text = [self.MasterTVCListtems objectAtIndex:indexPath.row] ;
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
    if (indexPath.row==0) {
        if (!self.gwtListViewController) {
            self.gwtListViewController = [[GWTListViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
        }
        [self.navigationController pushViewController:self.gwtListViewController animated:YES];
    }
    if (indexPath.row==1) {
        if (!self.szuCALLoginViewController) {
            self.szuCALLoginViewController = [[SZUCALLoginViewController alloc] initWithNibName:@"SZUCALLoginViewController" bundle:nil];
        }
        [self.navigationController pushViewController:self.szuCALLoginViewController animated:YES];
    }
    if(indexPath.row>1 && indexPath.row<5){
        NSString *msg = [[NSString alloc] 
                         initWithString:@"该功能的开发诚邀您的参与！"];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Github" 
                              message:msg 
                              delegate:nil 
                              cancelButtonTitle: @"好"
                              otherButtonTitles:nil];
        [alert show];
    }
    if(indexPath.row==5){
        NSString *msg = [[NSString alloc] 
                         initWithString:@"本项目在Github上的地址是\r\nhttps://github.com/stigliew/weixiaoyuan-iOS-client\r\n期待您的参与哟！\r\n有想法，不能等！\r\n详询短号68469"];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Github" 
                              message:msg 
                              delegate:nil 
                              cancelButtonTitle: @"好"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
