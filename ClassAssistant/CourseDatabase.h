//
//  CourseDatabase.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/14/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseDatabase : NSObject {
    
}

+ (NSMutableArray *)loadCourseDocs;
+ (NSString *)nextCourseDocPath;

@end
