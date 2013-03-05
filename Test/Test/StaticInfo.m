//
//  StaticInfo.m
//  Test
//
//  Created by sls38 on 19/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import "StaticInfo.h"

@implementation StaticInfo

//@synthesize personName;
//@synthesize phoneNumbers;

static NSString *personName;
static NSMutableArray *phoneNumbers;

+ (NSString*) getPersonName {
    NSLog(@"getTheString");
    return personName;
}

+ (void) setPersonName:(NSString*)newPersonName {
    personName = newPersonName;
    NSLog(@"Set the string to %@", newPersonName);
    [StaticInfo write]; 
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
    personName = [temp objectForKey:@"Name"];
    NSLog(@"Person Name: %@", personName);
    phoneNumbers = [NSMutableArray arrayWithArray:[temp objectForKey:@"Phones"]];
}

+ (void) write {
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: personName, phoneNumbers, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"Name", @"Phones", nil]];
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
