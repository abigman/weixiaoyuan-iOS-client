//
//  GongwentongFetcher.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GongwentongFetcher.h"
#import "JSON.h"
#import "FileHelper.h"
@implementation GongwentongFetcher
+ (id) JSONObjectWithData:(NSString *)data {
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    NSError *jsonParsingError = nil;
    if (YES||!jsonSerializationClass) {//WHATEVER iOS5 ,JUST USE SBJSON FOR TEST
        SBJsonParser * parser = [[SBJsonParser alloc] init]; 
        //iOS < 5 didn't have the JSON serialization class
        id jsonObject = data ? [parser objectWithString:data] : nil;
        return jsonObject; //SBJson
    }
    else {
        NSError *jsonParsingError = nil;
        id jsonObject = data ? [NSJSONSerialization 
                                JSONObjectWithData:data 
                                options:0 
                                error:&jsonParsingError] : nil;
        return jsonObject;
    }
    return nil;
}
+ (NSDictionary *)executeFetch:(NSString *)query
{
    //query = [[NSString alloc] initWithFormat:@"%@&cfuuid=%@", query,[FileHelper stringWithUUID]];
    [FileHelper stringWithUUID];
    //NSLog(@"HTTP REQUEST %@",query);
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@",[NSString stringWithContentsOfURL:[NSURL URLWithString:query]]);
    NSDictionary *results = jsonData ? [self JSONObjectWithData:jsonData] : nil;
    
    return results;
}
+ (NSArray *)getGWTList:(int)page
{
    NSString *request = [NSString stringWithFormat:@"http://vlinju.sinaapp.com/schoolnews/lists?school_code=szu&page=%d",page];
    NSDictionary *temp=[self executeFetch:request];
    NSMutableArray *ret=[[NSMutableArray alloc] init];
    int i=0;
    for (NSDictionary *t in temp) {
        [ret insertObject:t atIndex:i];
        i++;
    }
    
    return ret;
}
+ (NSString *)getGWTContent:(NSString *)nid
{
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://vlinju.sinaapp.com/html5/news_content?nid=",nid];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];
    request=[request stringByReplacingOccurrencesOfString:@"<div class=\"top\">" withString:@"<div class=\"top\"><!--"];
    request=[request stringByReplacingOccurrencesOfString:@"weixiaoyuan.png\"/></a>" withString:@"-->"];
    return request;
}
+ (NSString *)getSZUCAL:(NSString *)q
{
    q = [q stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://szucal.com/wap/schedule.php?xing_ming=",q];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];
    
    
    
    request=[request stringByReplacingOccurrencesOfString:@"<font color=\"red\">" withString:@"<p>"];
    request=[request stringByReplacingOccurrencesOfString:@"</font>" withString:@"</p>"];
    request=[request stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"</p><hr/><p>"];
    request=[request stringByReplacingOccurrencesOfString:@"</p><br><p>" withString:@"</p><hr/><p>"];
    return request;
}
+ (NSArray *)getLOVJOB
{
    
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://1.szuapps.sinaapp.com/ios-service/getjob.php?cfuuid=",[FileHelper stringWithUUID]];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];

    return [[NSArray alloc] initWithArray: [request componentsSeparatedByString:@"<br/><hr/>"]];
}
//
+ (NSString *)getLOVContent:(NSString *)jid
{
    jid = [[NSString alloc] initWithFormat:@"%@&cfuuid=%@", jid,[FileHelper stringWithUUID]];
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://1.szuapps.sinaapp.com/ios-service/j.php?jid=",jid];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];

    return request;
}
+ (NSString *)getlibsrch:(NSString *)q
{
    q = [q stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    q = [[NSString alloc] initWithFormat:@"%@&cfuuid=%@", q,[FileHelper stringWithUUID]];
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://1.szuapps.sinaapp.com/ios-service/libq.php?q=",q];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];
    request=[request stringByReplacingOccurrencesOfString:@"<br/><hr/>" withString:@"<hr/>"];
    NSLog(@"%@",request);
    return request;
}
+ (NSString *)getlibContent:(NSString *)bid
{
    bid = [[NSString alloc] initWithFormat:@"%@&cfuuid=%@", bid,[FileHelper stringWithUUID]];
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://1.szuapps.sinaapp.com/ios-service/libi.php?q=",bid];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];
    
    return request;
}
+ (NSArray *)getMCList
{
    NSString *request = [NSString stringWithFormat:@"http://1.stigliew.sinaapp.com/ab/meicanlist.php"];
    NSDictionary *temp=[self executeFetch:request];
    NSMutableArray *ret=[[NSMutableArray alloc] init];
    int i=0;
    for (NSDictionary *t in temp) {
        [ret insertObject:t atIndex:i];
        i++;
    }
    
    return ret;
}
+ (NSString *)getMCContent:(NSString *)nid
{
    NSString *tempURL=[[NSString alloc] initWithFormat:@"%@%@",@"http://1.stigliew.sinaapp.com/ab/meicanid.php?id=",nid];
    NSString *request = [NSString stringWithContentsOfURL:[NSURL URLWithString:tempURL] encoding:NSUTF8StringEncoding error:nil];
    return request;
}
@end
