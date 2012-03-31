//
//  FileHelper.h
//  szuweixiaoyuan
//
//  Created by mac pro on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (NSString*) stringWithUUID;
+(void)savszucal:(NSArray *) dictionary;
+(NSArray *)readszucal;
@end
