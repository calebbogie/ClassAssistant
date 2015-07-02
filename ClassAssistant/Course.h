//
//  Course.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

//General Properties
@property NSString *courseName;
@property NSNumber *creditHours;
@property NSString *currentGrade;
@property NSMutableArray *previousGrades;

//Professor Properties
@property NSString *professorName;
@property NSString *professorEmailAddress;
@property NSString *professorOfficeLocation;

//Grade Properties
@property NSMutableArray* examWeights;
@property NSNumber *quizWeight;
@property NSNumber *homeworkWeight;

//Changed from int to NSNumber
@property NSNumber *numberOfExams;
@property NSMutableArray *examGrades;
@property NSMutableArray *quizGrades;
@property NSMutableArray *homeworkGrades;

@property NSInteger imageNumber;

- (double)calculateAverageForType:(NSString *)type;
- (double)calculateCurrentGrade;

@end
