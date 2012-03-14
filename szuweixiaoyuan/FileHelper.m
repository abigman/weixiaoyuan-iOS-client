//
//  FileHelper.m
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper
+ (NSString*) stringWithUUID {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    
    if ([paths count] > 0)
    {
        // dictionary的保存路径
        NSString  *dictPath = [[paths objectAtIndex:0] 
                               stringByAppendingPathComponent:cfuuidfile];
        // 从文件中读取回来
        NSString    *uuidString;
        NSArray *dictFromFile = [NSArray arrayWithContentsOfFile:dictPath];
        //NSLog(@"uuid file count:%d",dictFromFile.count);
        
        if (dictFromFile.count==0) {
            
            CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
            //get the string representation of the UUID
            uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
            CFRelease(uuidObj);
            NSArray *dictionary = [[NSArray alloc] initWithObjects:uuidString, nil];
            [dictionary writeToFile:dictPath atomically:YES];
            NSLog(@"%@%@",@"+uuid:",uuidString);
            return uuidString;
            
        }
        uuidString=[dictFromFile objectAtIndex:0];
        NSLog(@"%@%@",@"uuid:",uuidString);
        return uuidString;
    }
    return nil;
}
@end
