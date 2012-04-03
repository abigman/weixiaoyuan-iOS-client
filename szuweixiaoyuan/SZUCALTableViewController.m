//
//  SZUCALTableViewController.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SZUCALTableViewController.h"
#import "GongwentongFetcher.h"
#import <EventKit/EventKit.h>
@interface SZUCALTableViewController ()

@end

@implementation SZUCALTableViewController
@synthesize q;
@synthesize callist;
@synthesize headers;
@synthesize sectioncounts;
@synthesize event;
@synthesize eventStore;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的课表";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    dispatch_queue_t downloadQueue = dispatch_queue_create("json downloader", NULL);
    
    
    dispatch_async(downloadQueue, ^{
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSArray *getspots = [GongwentongFetcher getSZUCAL:q];

        dispatch_async(dispatch_get_main_queue(), ^{
            callist=getspots;

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
    // Get the event store object  
    eventStore = [[EKEventStore alloc] init];  
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

    return [callist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *temp=[callist objectAtIndex:section];
    NSArray *temp1=[temp objectForKey:@"courses"];
    if ([temp1 count]==0) {
        return 1;
    }
    return [temp1 count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSDictionary *temp=[callist objectAtIndex:section];
    return [[NSString alloc] initWithFormat:@"%@月%@日 - 第%@周",
            [temp objectForKey:@"month"],
            [temp objectForKey:@"day"],
            [temp objectForKey:@"week"]];
}
-(NSString *) stringByStrippingHTML:(NSString *)input {
    NSRange r;
    NSString *s = [input copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"szucalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.detailTextLabel.text=@"";
    cell.textLabel.text=@"";
    NSDictionary *temp=[callist objectAtIndex:indexPath.section];
    NSArray *temp1=[temp objectForKey:@"courses"];
    if ([temp1 count]==0) {
        cell.detailTextLabel.text=@"本日休假";
        cell.textLabel.text=@"没有安排";
    }else{
        temp=[temp1 objectAtIndex:indexPath.row];
        cell.textLabel.text=[[NSString alloc] initWithFormat:@"%@-%@",
                             [temp objectForKey:@"course_name"],
                             [temp objectForKey:@"professor"]];
        if ([[temp objectForKey:@"section_order"] intValue]!=70) {
            cell.detailTextLabel.text=[[NSString alloc] initWithFormat:@"%@ - %@ 在 %@",
                                       [temp objectForKey:@"begin"],
                                       [temp objectForKey:@"end"],
                                       [temp objectForKey:@"locale"]];
        }else {
            cell.detailTextLabel.text=[[NSString alloc] initWithFormat:@"%@ 在 %@",
                                       [temp objectForKey:@"begin"],
                                       [temp objectForKey:@"locale"]];
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

    

    
    // Get the event store object  
    //EKEventStore *eventStore = [[EKEventStore alloc] init];  
    
    // Create a new event  
    event  = [EKEvent eventWithEventStore:eventStore];  
    
    // Create NSDates to hold the start and end date  
    NSDate *startDate = [[NSDate alloc] init];  
    NSDate *endDate  = [[NSDate alloc] init];
    
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-43200];// 1 Day
    
    NSDictionary *temp=[callist objectAtIndex:indexPath.section];
    
    NSArray *temp1=[temp objectForKey:@"courses"];
    int year=[[temp objectForKey:@"year"] intValue];  
    int month = [[temp objectForKey:@"month"] intValue];
    int day = [[temp objectForKey:@"day"] intValue];
    
    if ([temp1 count]==0) {
        return;
    }else{
        temp=[temp1 objectAtIndex:indexPath.row];
        
        event.title =[[NSString alloc] initWithFormat:@"%@-%@",
                             [temp objectForKey:@"course_name"],
                             [temp objectForKey:@"professor"]];
        if ([[temp objectForKey:@"section_order"] intValue]!=70) {
            event.allDay = NO;
            alarm = [EKAlarm alarmWithRelativeOffset:-1800];
            NSString *st=[[NSString alloc] initWithFormat:@"%d%@%d%@%d%@%@",year,@"-",month,@"-",day,@" ",[temp objectForKey:@"begin"]];
            NSString *et=[[NSString alloc] initWithFormat:@"%d%@%d%@%d%@%@",year,@"-",month,@"-",day,@" ",[temp objectForKey:@"end"]];
            
            startDate=[self NSStringDateToNSDate:st];
            endDate=[self NSStringDateToNSDate:et];
            
        }else {
            event.allDay = YES;
            NSString *st=[[NSString alloc] initWithFormat:@"%d%@%d%@%d%@",year,@"-",month,@"-",day,@" 00:00"];
            
            startDate=[self NSStringDateToNSDate:st];
            endDate=[self NSStringDateToNSDate:st];
        }
        
    }
    
    [event addAlarm:alarm];
    [event setLocation:[[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"locale"]]];
    
    
    // Set properties of the new event object  
    

    event.startDate = startDate;  
    event.endDate   = endDate;  
    
    // set event's calendar to the default calendar  
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];  
    UIAlertView *alert = [[UIAlertView alloc]  
                          initWithTitle:@"添加到手机日历？"   
                          message:event.title   
                          delegate:self  
                          cancelButtonTitle:@"那不能"   
                          otherButtonTitles:@"好",nil];  
    [alert show];
 
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        return;
    }
    if (buttonIndex == 1)
    {
        
    }
    if (buttonIndex == 2)
    {
        
    }
    NSError *err=[[NSError alloc] init];  
    // Save the event  
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];   
    NSLog(@"%@",err);
    // Test for errors  
    if (err == 0) {  
        UIAlertView *alert = [[UIAlertView alloc]  
                              initWithTitle:@"已添加:"   
                              message:event.title   
                              delegate:nil 
                              cancelButtonTitle:@"好"   
                              otherButtonTitles:nil];  
        //[alert show];  
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]  
                              initWithTitle:@"出错了"   
                              message:@"哎…"   
                              delegate:nil 
                              cancelButtonTitle:@"好"   
                              otherButtonTitles:nil];  
        [alert show];
    }
    
}
-(NSDate *)NSStringDateToNSDate:(NSString *)string {    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:string];

    return date;
}
- (NSString *)trimString:(NSString *)str {
    NSMutableString *mStr = [str mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)mStr);   
    NSString *result = [mStr copy];   

    return result;
}
@end
