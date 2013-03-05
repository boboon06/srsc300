//
//  StaticInfo.h
//  Storyboard
//
//  Created by sls38 on 21/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticInfo : NSObject

+ (NSString*) getName;
+ (NSNumber*) getAge;
+ (NSString*) getCountry;

+ (void) setName:(NSString*)newName;
+ (void) setAge:(NSNumber*)newAge; // TODO: Make sure they can only enter an age in decimal
+ (void) setCountry:(NSString*)newCountry;

+ (void) read;
+ (void) write; // Not really required, as writes happen automatically

@end
