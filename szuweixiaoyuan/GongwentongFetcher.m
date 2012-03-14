//
//  GongwentongFetcher.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GongwentongFetcher.h"
#import "SBJson.h"
#import "FileHelper.h"
@implementation GongwentongFetcher
+ (id) JSONObjectWithData:(NSData *)data {
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    if (!jsonSerializationClass) {
        //iOS < 5 didn't have the JSON serialization class
        id jsonObject = data ? [data JSONValue] : nil;
        NSLog(@"%@",jsonObject);
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
    query = [[NSString alloc] initWithFormat:@"%@&cfuuid=%@", query,[FileHelper stringWithUUID]];
    //NSLog(@"HTTP REQUEST %@",query);
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
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
    }
    
    return ret;
}
@end
