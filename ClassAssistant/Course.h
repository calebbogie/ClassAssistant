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
@property double creditHours;
@property NSString *currentGrade;

//Professor Properties
@property NSString *professorName;
@property NSString *professorEmailAddress;
@property NSString *professorOfficeLocation;

//Grade Properties
@property NSMutableArray* examWeights;
@property double quizWeight;
@property double homeworkWeight;
@property int numberOfExams;
@property NSMutableArray *examGrades;
@property NSMutableArray *quizGrades;
@property NSMutableArray *homeworkGrades;

- (double)calculateAverageForType:(NSString *)type;
- (double)calculateCurrentGrade;

@end
