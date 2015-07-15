//
//  CourseDatabase.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/14/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "CourseDatabase.h"
#import "CourseDoc.h"

@implementation CourseDatabase

+ (NSString *)getPrivateDocsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

+ (NSMutableArray *)loadCourseDocs {
    // Get private docs dir
    NSString *documentsDirectory = [CourseDatabase getPrivateDocsDir];
    NSLog(@"Loading courses from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Create ScaryBugDoc for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"course" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            
            CourseDoc *doc = [[CourseDoc alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    
    return retval;
}

+ (NSString *)nextCourseDocPath {
    
    // Get private docs dir
    NSString *documentsDirectory = [CourseDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"course" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.course", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}

@end
