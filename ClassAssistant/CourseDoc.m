//
//  CourseDoc.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/14/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "CourseDoc.h"
#import "CourseDatabase.h"
#import "Course.h"
#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation CourseDoc

- (id)init {
    if ((self = [super init])) {
        
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = docPath;
    }
    return self;
}

- (id)initWithCourse:(Course *)c {
    if ((self = [super init])) {
        _data = c;
    }
    return self;
}

- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [CourseDatabase nextCourseDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
    
}

- (void)saveData {
    NSLog(@"Saving Data");
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

- (void)saveImages {
    
}

- (void)deleteCourse {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}

- (Course *)getData {
    if (_data != nil) return _data;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return _data;
    
}

@end
