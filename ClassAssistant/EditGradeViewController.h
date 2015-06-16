//
//  EditExamGradeViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 8/20/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditGradeViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scroller;

@property (weak, nonatomic) IBOutlet UITextField *addHomework;
@property (weak, nonatomic) IBOutlet UITextField *addQuiz;
@property (weak, nonatomic) IBOutlet UITextField *addExam;

//Could be consolidated into one
@property (nonatomic, retain) IBOutlet UILabel *homeworkAvg;
@property (nonatomic, retain) IBOutlet UILabel *quizAvg;
@property (nonatomic, retain) IBOutlet UILabel *examAvg;

@property (nonatomic, retain) IBOutlet UILabel *gradeAverageLabel;

//- (void)setupHomeworkView;
//- (void)setupQuizView;
//- (void)setupExamView;

- (void)setupView:(NSString *)type;
- (void)modifyGrade:(UITextField *)textField forType:(NSString *)type;

- (void)makeGradeTextFieldAndLabel:(int)i forType:(NSString *)type forGradeArray:(NSMutableArray *)gradeArray;
- (void)addTextFieldForGrade:(UITextField *)textField forType:(NSString *)type;

//- (void)modifyExams:(UITextField *)textField;
//- (void)modifyQuizzes:(UITextField *)textField;
//- (void)modifyHomeworks:(UITextField *)textField;

- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
