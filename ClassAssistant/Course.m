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

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString *courseName = [decoder decodeObjectForKey:@"CourseName"];
    NSNumber *creditHours = [decoder decodeObjectForKey:@"CreditHours"];
    NSString *currentGrade = [decoder decodeObjectForKey:@"CurrentGrade"];
    NSMutableArray *previousGrades = [decoder decodeObjectForKey:@"PreviousGrades"];
    
    NSString *professorName = [decoder decodeObjectForKey:@"ProfessorName"];
    NSString *professorEmailAddress = [decoder decodeObjectForKey:@"ProfessorEmailAddress"];
    NSString *professorOfficeLocation = [decoder decodeObjectForKey:@"ProfessorOfficeLocation"];
    
    NSMutableArray *examWeights = [decoder decodeObjectForKey:@"ExamWeights"];
    NSNumber *quizWeight = [decoder decodeObjectForKey:@"QuizWeight"];
    NSNumber *homeworkWeight = [decoder decodeObjectForKey:@"HomeworkWeight"];
    NSNumber *otherWeight = [decoder decodeObjectForKey:@"OtherWeight"];
    
    NSNumber *numberOfExams = [decoder decodeObjectForKey:@"NumberOfExams"];
    NSMutableArray *examGrades = [decoder decodeObjectForKey:@"ExamGrades"];
    NSMutableArray *quizGrades = [decoder decodeObjectForKey:@"QuizGrades"];
    NSMutableArray *homeworkGrades = [decoder decodeObjectForKey:@"HomeworkGrades"];
    NSMutableArray *otherGrades = [decoder decodeObjectForKey:@"OtherGrades"];
    
    //NSInteger imageNumber = [decoder decodeObjectForKey:@"ImageNumber"];
    NSNumber *imageNumber = [decoder decodeObjectForKey:@"ImageNumber"];
    
    if ((self = [super init])) {
        _courseName = courseName;
        _creditHours = creditHours;
        _currentGrade = currentGrade;
        _previousGrades = previousGrades;
    
        _professorName = professorName;
        _professorEmailAddress = professorEmailAddress;
        _professorOfficeLocation = professorOfficeLocation;
    
        _examWeights = examWeights;
        _quizWeight = quizWeight;
        _homeworkWeight = homeworkWeight;
        _otherWeight = otherWeight;
        
        _numberOfExams = numberOfExams;
        _examGrades = examGrades;
        _quizGrades = quizGrades;
        _homeworkGrades = homeworkGrades;
        _otherGrades = otherGrades;
        
        _imageNumber = [imageNumber integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_courseName forKey:@"CourseName"];
    [encoder encodeObject:_creditHours forKey:@"CreditHours"];
    [encoder encodeObject:_currentGrade forKey:@"CurrentGrade"];
    [encoder encodeObject:_previousGrades forKey:@"PreviousGrades"];
    [encoder encodeObject:_professorName forKey:@"ProfessorName"];
    [encoder encodeObject:_professorOfficeLocation forKey:@"ProfessorOfficeLocation"];
    [encoder encodeObject:_professorEmailAddress forKey:@"ProfessorEmailAddress"];
    [encoder encodeObject:_examWeights forKey:@"ExamWeights"];
    [encoder encodeObject:_quizWeight forKey:@"QuizWeight"];
    [encoder encodeObject:_homeworkWeight forKey:@"HomeworkWeight"];
    [encoder encodeObject:_otherWeight forKey:@"OtherWeight"];
    [encoder encodeObject:_numberOfExams forKey:@"NumberOfExams"];
    [encoder encodeObject:_examGrades forKey:@"ExamGrades"];
    [encoder encodeObject:_quizGrades forKey:@"QuizGrades"];
    [encoder encodeObject:_homeworkGrades forKey:@"HomeworkGrades"];
    [encoder encodeObject:@(_imageNumber) forKey:@"ImageNumber"];
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
