//
//  CourseDoc.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/14/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Course;

@interface CourseDoc : NSObject {
    Course *_data;
    NSString *_docPath;
}

@property (retain) Course *data;
@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithCourse:(Course *)c;
- (void)saveData;
- (void)saveImages;
- (void)deleteCourse;
- (Course *)getData;

@end
