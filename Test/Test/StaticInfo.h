//
//  StaticInfo.h
//  Test
//
//  Created by sls38 on 19/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticInfo : NSObject;
//@property (copy, nonatomic) + NSString *personName;
//@property (retain, nonatomic) NSMutableArray *phoneNumbers;

+ (NSString*) personName;
+ (NSMutableArray*) phoneNumbers;

+ (NSString*) getPersonName;
+ (void) setPersonName:(NSString*)newPersonName;
+ (void) read;
+ (void) write;

@end
