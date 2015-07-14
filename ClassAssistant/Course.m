//
//  Course
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "Course.h"

@implementation Course : NSObject

//General Class Information
@synthesize courseName = _courseName;
@synthesize creditHours = _creditHours;
@synthesize currentGrade = _currentGrade;

//Individual Grades
@synthesize examGrades = _examGrades;
@synthesize quizGrades = _quizGrades;
@synthesize homeworkGrades = _homeworkGrades;
@synthesize examWeights = _examWeights;
@synthesize quizWeight = _quizWeight;
@synthesize otherWeight = _otherWeight;
@synthesize homeworkWeight = _homeworkWeight;
@synthesize professorName = _professorName;
@synthesize professorEmailAddress = _professorEmailAddress;
@synthesize professorOfficeLocation = _professorOfficeLocation;

- (id)init {
    _examGrades = [[NSMutableArray alloc] init];
    _quizGrades = [[NSMutableArray alloc] init];
    _homeworkGrades = [[NSMutableArray alloc] init];
    _otherGrades = [[NSMutableArray alloc] init];
    _examWeights = [[NSMutableArray alloc] init];
    _previousGrades = [[NSMutableArray alloc] init];
    
    return self;
}

- (double)calculateAverageForType:(NSString *)type {
    double average = 0;
    
    if ([type isEqualToString:@"exam"]) {
        for (int i = 0; i < _examGrades.count; i++) {
            average += [[_examGrades objectAtIndex:i] doubleValue];
        }
        
        if (_examGrades.count > 0)
            average /= _examGrades.count;
        else
            average = 0;
        
    }
    
    else if ([type isEqualToString:@"quiz"]) {
        for (int i = 0; i < _quizGrades.count; i++) {
            average += [[_quizGrades objectAtIndex:i] doubleValue];
        }
        
        if(_quizGrades.count > 0)
            average /= _quizGrades.count;
        else
            average = 0;
    }
    
    else if ([type isEqualToString:@"homework"]) {
        for (int i = 0; i < _homeworkGrades.count; i++) {
            average += [[_homeworkGrades objectAtIndex:i] doubleValue];
        }
        
        if (_homeworkGrades. count > 0)
            average /= _homeworkGrades.count;
        else
            average = 0;
    }
    
    else if ([type isEqualToString:@"other"]) {
        for (int i = 0; i < _otherGrades.count; i++) {
            average += [[_otherGrades objectAtIndex:i] doubleValue];
        }
        
        if (_otherGrades.count > 0)
            average /= _otherGrades.count;
        else
            average = 0;
        
    }
    
    return average;
}

//NEEDS TESTING
- (double)calculateCurrentGrade {
    //Convert weights to decimals
    
    double examWeight = 0;
    double effectiveQuizWeight = 0;
    double effectiveHomeworkWeight = 0;
    //double effectiveExamWeight = 0;
    double effectiveOtherWeight = 0;
    
    if (self.homeworkGrades.count > 0) {
        effectiveHomeworkWeight = [self.homeworkWeight doubleValue];
    }
    if (self.quizGrades.count > 0) {
        effectiveQuizWeight = [self.quizWeight doubleValue];
    }
    if (self.otherGrades.count > 0) {
        effectiveOtherWeight = [self.otherWeight doubleValue];
    }
    
    for (int i = 0; i < _examGrades.count; i++)
        examWeight += [[_examWeights objectAtIndex:i] doubleValue];
    
    //Add exam calculation later
    double result = ( ([self calculateAverageForType:@"homework"] * [_homeworkWeight doubleValue]) + ([self calculateAverageForType:@"quiz"] * [_quizWeight doubleValue]) + ([self calculateAverageForType:@"exam"] * examWeight) + ([self calculateAverageForType:@"other"] * [_quizWeight doubleValue]) ) / (examWeight + effectiveHomeworkWeight + effectiveQuizWeight + effectiveOtherWeight);
    
    if (isnan(result))
        return 0.00;
    else
        return result;
}

@end
