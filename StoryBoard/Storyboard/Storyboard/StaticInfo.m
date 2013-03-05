//
//  StaticInfo.m
//  Storyboard
//
//  Created by sls38 on 21/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import "StaticInfo.h"

@implementation StaticInfo

static NSString * name = @"Test Name";
static NSNumber * age = nil;
static NSString * country = @"New Zealand";

+ (NSString*) getName {
    return name;
}

+ (NSNumber*) getAge {
    if (age == nil) {
        age = [NSNumber numberWithInt:5]; // Hack hack hack 
    }
    return age;
}

+ (NSString*) getCountry {
    return country;
}

+ (void) setName:(NSString*)newName {
    name = newName;
    [self write];
}

+ (void) setAge:(NSNumber*)newAge { // TODO: Make sure they can only enter an age in decimal
    age = newAge;
    [self write];
}

+ (void) setCountry:(NSString*)newCountry {
    country = newCountry;
    [self write];
}

+ (void) read {
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    name = [temp objectForKey:@"name"];
    age = [temp objectForKey:@"age"];
    country = [temp objectForKey:@"country"];
}

+ (void) write {
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSArray * items = [NSArray arrayWithObjects: name, age, country, nil];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: items
                                                          forKeys:[NSArray arrayWithObjects: @"name", @"age", @"country", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(@"%@", error);
    }
}

@end
