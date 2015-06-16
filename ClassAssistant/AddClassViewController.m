//
//  AddClassViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "AddClassViewController.h"
#import "GradeSetupViewController.h"

//Constants for animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

static const int SIZE_OF_EXAM_BLOCK = 75;

@interface AddClassViewController ()

@end

@implementation AddClassViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Only allow the course to be created if the user has specified a name and credit hours value
    if ((self.courseNameField.text.length > 0) && (self.creditHoursField.text.length > 0)) {
        
        self.courseToAdd = [[Course alloc] init];
        self.courseToAdd.courseName = self.courseNameField.text;
        self.courseToAdd.creditHours = [[self.creditHoursField text] doubleValue];
        self.courseToAdd.currentGrade = @"No data";
        
        self.courseToAdd.professorName = [self.professorName text];
        self.courseToAdd.professorOfficeLocation = [self.professorOfficeLocation text];
        self.courseToAdd.professorEmailAddress = [self.professorEmailAddress text];
        
        // ************************* Handle case where weights will be passed as percentages **************************
        
        self.courseToAdd.numberOfExams = [[self.numberOfExams text] doubleValue];
        self.courseToAdd.homeworkWeight = [[self.homeworkWeight text] doubleValue];
        self.courseToAdd.quizWeight = [[self.quizWeight text] doubleValue];
        
        // ************************* Handle case where weights will be passed as percentages **************************
        
        //Add all exam weights to Course object
        for (NSNumber *i in self.examWeightTextFields) {
            [self.courseToAdd.examWeights addObject:i];
        }
        
        return;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Editing...");
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        _animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        _animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= _animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.restorationIdentifier isEqualToString:@"numberOfExams"]) {
        
        //Remove old text fields
        for (UITextField *examWeight in _examWeightTextFields) {
            NSLog(@"Removing textfield");
            [examWeight removeFromSuperview];
        }
        
        //Remove old labels
        for (UILabel *examLabel in _examTitleLabels) {
            [examLabel removeFromSuperview];
        }
        
        //Clear arrays
        [self.examWeightTextFields removeAllObjects];
        [self.examTitleLabels removeAllObjects];
        
        //Get number of exams from text field
        int numExams = [self.numberOfExams.text intValue];
        
        //Adjust size of scrollview
        [self.scroller setContentSize:CGSizeMake(320, 1050+numExams*(SIZE_OF_EXAM_BLOCK))];
        
        //Initialize arrays
        self.examTitleLabels = [[NSMutableArray alloc] init];
        self.examWeightTextFields = [[NSMutableArray alloc] init];
        
        //Create text for Exam Setup title
        UILabel *examSetupTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 710, 150, 50)];
        
        //Set title text
        examSetupTitle.text = @"Exam Setup";
        
        //Set title font
        examSetupTitle.font = [UIFont systemFontOfSize:25];
        
        //Add title to scrollview
        [self.scroller addSubview:examSetupTitle];
        
        //Add items to array
        for (int i = 0; i < numExams; i++) {
            
            //Create text for label
            NSString *examNumber = [NSString stringWithFormat:@"Exam %d Weight", i+1];
            
            //Create label
            UILabel *examLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 750+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
            
            //Set font size
            examLabel.font = [UIFont systemFontOfSize:17];
            
            //Set label text
            examLabel.text = examNumber;
            
            //Add label to scrollview
            [self.scroller addSubview:examLabel];
            
            //Add label to array
            [self.examTitleLabels addObject:examLabel];
            
            //Create exam weight text field
            UITextField *examWeight = [[UITextField alloc] initWithFrame:CGRectMake(20, 795+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
            
            //Setup exam weight text field
            examWeight.borderStyle = UITextBorderStyleRoundedRect;
            examWeight.backgroundColor = [UIColor whiteColor];
            examWeight.keyboardType = UIKeyboardTypeDecimalPad;
            
            //Add text field to scrollview
            [self.scroller addSubview:examWeight];
            
            //Add text field to array
            [self.examWeightTextFields addObject:examWeight];
        }
        
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += _animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Returning...");
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(320, 1030)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
