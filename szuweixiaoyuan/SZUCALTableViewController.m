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
        NSString *getspots = [GongwentongFetcher getSZUCAL:q];
        getspots=[getspots stringByReplacingOccurrencesOfString:@"<hr />" withString:@"<hr/>"];
        NSMutableArray *array =[[NSMutableArray alloc] initWithArray: [getspots componentsSeparatedByString:@"<hr/>"]];
        if ([array count]<5) {
            UIApplication *app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            return;
        }
        [array removeObjectAtIndex:0];
        [array removeObjectAtIndex:[array count]-1];
        [array removeObjectAtIndex:[array count]-1];
        [array removeObjectAtIndex:[array count]-1];
        //处理一天多节课
        NSString *datestr;
        int i=0;
        int c=1;
        NSMutableArray *ret=[[NSMutableArray alloc] init];
        NSMutableArray *hret=[[NSMutableArray alloc] init];
        NSMutableArray *scret=[[NSMutableArray alloc] init];
        for (NSString *t in array) {
            BOOL  found  = ([t rangeOfString:@"号第"].location !=NSNotFound);
            //NSLog(@"%d",[t rangeOfString:@"号第"].location);
            if (found) {
                if (i>0) {
                    [scret insertObject:[NSNumber numberWithInt:c] atIndex:[scret count]];
                    c=1;
                }
                NSArray *array1 =[[NSArray alloc] initWithArray: [t componentsSeparatedByString:@"："]];
                datestr=[array1 objectAtIndex:0];
                [hret insertObject:datestr atIndex:[hret count]];
                [ret insertObject:[[NSString alloc]initWithFormat:@"%@",t] atIndex:i];
            }else {
                if (!datestr) {
                    UIAlertView *alert = [[UIAlertView alloc]  
                                          initWithTitle:@"出错了，老大"   
                                          message:@"你有可能是已经毕业了，要不然就是szucal的数据木有更新"   
                                          delegate:nil 
                                          cancelButtonTitle:@"好"   
                                          otherButtonTitles:nil];  
                    [alert show];
                    UIApplication *app = [UIApplication sharedApplication];
                    app.networkActivityIndicatorVisible = NO;
                    return;
                }
                c++;
                [ret insertObject:[[NSString alloc]initWithFormat:@"%@：%@",datestr,t] atIndex:i];
            }
            i++;
        
        }
        [scret insertObject:[NSNumber numberWithInt:c] atIndex:[scret count]];
        dispatch_async(dispatch_get_main_queue(), ^{
            callist=[[NSArray alloc] initWithArray:ret];
            headers=[[NSArray alloc] initWithArray:hret];
            sectioncounts=[[NSArray alloc] initWithArray:scret];

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

    return [headers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[sectioncounts objectAtIndex:section] intValue];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return [headers objectAtIndex:section];
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
    int count=0;
    int actualrow=indexPath.row;
    for (NSNumber *t in sectioncounts) {
        if (count<indexPath.section) {
            actualrow=actualrow+[t intValue];
            count++;
        }
        
    }
    NSArray *array =[[NSArray alloc] initWithArray: [[callist objectAtIndex:actualrow] componentsSeparatedByString:@"："]];
    if (array.count==2) {
        cell.textLabel.text=[[self stringByStrippingHTML:[array objectAtIndex:1]] stringByReplacingOccurrencesOfString:@"课程于" withString:@""];
        cell.detailTextLabel.text=[self stringByStrippingHTML:[array objectAtIndex:1]];
        BOOL  found  = ([cell.detailTextLabel.text
                         rangeOfString:@"由 "].location !=NSNotFound);
        if (found) {
            cell.detailTextLabel.text=[cell.detailTextLabel.text 
                                       substringFromIndex:
                                       [cell.detailTextLabel.text
                                        rangeOfString:@"由 "].location+2];
            cell.detailTextLabel.text=[cell.detailTextLabel.text 
                                       substringToIndex:
                                       [cell.detailTextLabel.text
                                        rangeOfString:@" "].location];
        }else {
            cell.detailTextLabel.text=@"发呆日";
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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    int year=[comps year];
    //int week = [comps weekday];   
    int month = [comps month];
    int day = [comps day];
    //int hour = [comps hour];
    //int min = [comps minute];
    //int sec = [comps second];
    
    // Get the event store object  
    //EKEventStore *eventStore = [[EKEventStore alloc] init];  
    
    // Create a new event  
    event  = [EKEvent eventWithEventStore:eventStore];  
    
    // Create NSDates to hold the start and end date  
    NSDate *startDate = [[NSDate alloc] init];  
    NSDate *endDate  = [[NSDate alloc] init];
    int count=0;
    int actualrow=indexPath.row;
    for (NSNumber *t in sectioncounts) {
        if (count<indexPath.section) {
            actualrow=actualrow+[t intValue];
            count++;
        }
        
    }
    NSArray *array =[[NSArray alloc] initWithArray: [[callist objectAtIndex:actualrow] componentsSeparatedByString:@"："]];
    if([array count]<2)return;
    NSString *temp=[[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"<br/><p>" withString:@"<p>"];
    temp=[self stringByStrippingHTML:temp];
    temp=[temp stringByReplacingOccurrencesOfString:@"课程于" withString:@"课程于|"];
    temp=[temp stringByReplacingOccurrencesOfString:@"在" withString:@"|在"];
    NSArray *array1 =[[NSArray alloc] initWithArray: [temp componentsSeparatedByString:@"|"]];
    if([array1 count]<2)return;
    NSArray *array2 =[[NSArray alloc] initWithArray: [[array1 objectAtIndex:1] componentsSeparatedByString:@"-"]];
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-43200];// 1 Day
    
    if([array2 count]<2){
        event.allDay = YES;
    }else {
        NSString *st=[self trimString:[array2 objectAtIndex:0]];
        NSString *et=[self trimString:[array2 objectAtIndex:1]];
        array1 =[[NSArray alloc] initWithArray: [[self stringByStrippingHTML:[array objectAtIndex:0]] componentsSeparatedByString:@"号"]];
        if([array1 count]<2)return;
        temp=[array1 objectAtIndex:0];
        if([temp intValue]<day-7)month--;
        st=[[NSString alloc] initWithFormat:@"%d%@%d%@%@%@%@",year,@"-",month,@"-",temp,@" ",st];
        et=[[NSString alloc] initWithFormat:@"%d%@%d%@%@%@%@",year,@"-",month,@"-",temp,@" ",et];
        
        startDate=[self NSStringDateToNSDate:st];
        endDate=[self NSStringDateToNSDate:et];
        event.allDay = NO;
        alarm = [EKAlarm alarmWithRelativeOffset:-1800];// 30 minutes
        
        
    }
    [event addAlarm:alarm];
    
    
    
    // Set properties of the new event object  
    event.title     = [self stringByStrippingHTML:[array objectAtIndex:1]];

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
