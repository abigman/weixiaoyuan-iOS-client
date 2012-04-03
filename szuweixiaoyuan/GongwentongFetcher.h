//
//  GongwentongFetcher.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GongwentongFetcher : NSObject
+ (NSArray *)getGWTList:(int)page;
+ (NSString *)getGWTContent:(NSString *)nid;
+ (NSArray *)getSZUCAL:(NSString *)q;
+ (NSArray *)getLOVJOB;
+ (NSString *)getLOVContent:(NSString *)jid;
+ (NSString *)getlibsrch:(NSString *)q;
+ (NSString *)getlibContent:(NSString *)bid;
+ (NSArray *)getMCList;
+ (NSString *)getMCContent:(NSString *)nid;
+ (NSArray *)getMAILList:(int)page;
+ (NSString *)getMAILContent:(NSString *)nid;
@end
