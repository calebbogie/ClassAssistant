//
//  AddItemTabBarController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/14/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "AddItemTabBarController.h"
#import "EditGradeViewController.h"
#import "ViewClassViewController.h"

@interface AddItemTabBarController ()

@end

@implementation AddItemTabBarController

@synthesize picker = _picker;
@synthesize courseToEdit = _courseToEdit;
@synthesize doneButton = _doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5; // Numbers of rows
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"5"; // If it's a string
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
}

-(IBAction)addGrade:(id)sender {
    //Add grade to appropriate array in Course
    
    /*EditGradeViewController *currentTabBar = (EditGradeViewController *)self.selectedViewController;
    
    UITextField *currentTextField = currentTabBar.addHomework;
    
    NSNumber *gradeValue = [NSNumber numberWithDouble:[[currentTextField text] doubleValue]];
    
    if ([self.selectedViewController.title isEqualToString:@"Add Homework"]) {
        [_courseToEdit.homeworkGrades addObject:gradeValue];
        NSLog(@"New value is: %@", _courseToEdit.homeworkGrades[0]);
    } else if ([self.selectedViewController.title isEqualToString:@"Add Quiz"]) {
        [_courseToEdit.quizGrades addObject:gradeValue];
        NSLog(@"New value is: %@", _courseToEdit.quizGrades[0]);
    } else if ([self.selectedViewController.title isEqualToString:@"Add Exam"]) {
        [_courseToEdit.examGrades addObject:gradeValue];
        NSLog(@"New value is: %@", _courseToEdit.examGrades[0]);
    }*/
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
