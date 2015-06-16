//
//  AddClassViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface AddClassViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *courseNameField;
@property (weak, nonatomic) IBOutlet UITextField *creditHoursField;
@property (weak, nonatomic) IBOutlet UITextField *professorName;
@property (weak, nonatomic) IBOutlet UITextField *professorEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *professorOfficeLocation;
@property (weak, nonatomic) IBOutlet UITextField *numberOfExams;
@property (weak, nonatomic) IBOutlet UITextField *homeworkWeight;
@property (weak, nonatomic) IBOutlet UITextField *quizWeight;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scroller;
@property NSMutableArray *examTitleLabels;
@property NSMutableArray *examWeightTextFields;

@property CGFloat animatedDistance;

@property Course* courseToAdd;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
