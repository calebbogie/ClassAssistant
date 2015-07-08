//
//  AddClassViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "AddClassViewController.h"
#import "GradeSetupViewController.h"
#import <Parse/Parse.h>

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

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //_images = [[NSMutableArray alloc] initWithObjects:@"calendar.png", @"calendar.png", @"calendar.png", nil];
    _images = [[NSMutableArray alloc] init];
    [_images removeAllObjects];
    
    for (int i = 1; i < 27; i++) {
        NSString *fileName = [NSString stringWithFormat:@"CAicons-%d.png", i];
        [_images addObject:fileName];
    }
    
    [carousel setType:iCarouselTypeCoverFlow];
    return [_images count];
}



- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create a numbered view
    view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_images objectAtIndex:index]]];
    self.imageNum = index-3;
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return 150;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        default:
        {
            return value;
        }
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ((self.courseNameField.text.length == 0) && (self.creditHoursSlider.value == 0.000000)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Course name and/or credit hours not set!"
                                                        message:@"Please assign these values before continuing."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    if ((self.homeworkWeightSlider.value == 0.000000) && (self.quizWeightSlider.value == 0.000000) && (self.numberOfExamsSlider.value == 0.000000)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Assignment weights not assigned!"
                                                        message:@"Please assign grade weights to each type of assignment below."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    return true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Only allow the course to be created if the user has specified a name and credit hours value
    if ((self.courseNameField.text.length > 0) && (self.creditHoursSlider.value > 0)) {
        
        NSLog(@"OK");
        
        self.courseToAdd = [[Course alloc] init];
        self.courseToAdd.courseName = self.courseNameField.text;
        self.courseToAdd.creditHours = [NSNumber numberWithInteger:[[self.creditHoursLabel text] integerValue]];
        self.courseToAdd.currentGrade = @"-";
        
        self.courseToAdd.professorName = [self.professorName text];
        self.courseToAdd.professorOfficeLocation = [self.professorOfficeLocation text];
        self.courseToAdd.professorEmailAddress = [self.professorEmailAddress text];
        
        self.courseToAdd.numberOfExams = [NSNumber numberWithInteger:[[self.numberOfExamsLabel text] integerValue]];
        self.courseToAdd.homeworkWeight = [NSNumber numberWithFloat:[[self.homeworkWeightLabel text] doubleValue] / 100 ];
        self.courseToAdd.quizWeight = [NSNumber numberWithFloat:[[self.quizWeightLabel text] doubleValue] / 100 ];
        
        self.courseToAdd.imageNumber = self.imageNum;
        
        //Add all exam weights to Course object
        for (int i = 0; i < self.examWeightTextFields.count; i++) {
            UITextField *field = [self.examWeightTextFields objectAtIndex:i];
            //Get number from exam weight text field and add it to the examWeights array
            [self.courseToAdd.examWeights addObject:[NSNumber numberWithDouble:[[field text] doubleValue] / 100]];
        }
        
        ////////////////////////// ADD COURSE DATA TO PARSE DATABASE /////////////////////////////////////
        
        //Only add to database when user is creating course.  Not when they are editing it.
        if (!self.editMode) {
            PFObject *course = [PFObject objectWithClassName:@"Course"];
            [course setObject:@"Test User" forKey:@"User"];
            [course setObject:self.courseToAdd.courseName forKey:@"CourseName"];
            [course setObject:self.courseToAdd.creditHours forKey:@"CreditHours"];
            [course setObject:self.courseToAdd.professorName forKey:@"ProfessorName"];
            [course setObject:self.courseToAdd.professorEmailAddress forKey:@"ProfessorEmailAddress"];
            [course setObject:self.courseToAdd.professorOfficeLocation forKey:@"ProfessorOfficeLocation"];
            [course setObject:self.courseToAdd.numberOfExams forKey:@"NumberOfExams"];
            [course addObjectsFromArray:self.courseToAdd.examWeights forKey:@"ExamWeights"];
            [course setObject:self.courseToAdd.homeworkWeight forKey:@"HomeworkWeight"];
            [course setObject:self.courseToAdd.quizWeight forKey:@"QuizWeight"];
            [course addObjectsFromArray:self.courseToAdd.examGrades forKey:@"ExamGrades"];
            [course addObjectsFromArray:self.courseToAdd.quizGrades forKey:@"QuizGrades"];
            [course addObjectsFromArray:self.courseToAdd.homeworkGrades forKey:@"HomeworkGrades"];
            [course setObject:[NSNumber numberWithLong:self.courseToAdd.imageNumber] forKey:@"ImageNumber"];
            [course addObjectsFromArray:self.courseToAdd.previousGrades forKey:@"PreviousGrades"];
        
            [course saveInBackground];
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////////
        
        return;
    }
}

//- (IBAction)forwardButtonPressed:(id)sender {
//    NSLog(@"Forward button pressed");
//}
//
//- (IBAction)backwardButtonPressed:(id)sender {
//    NSLog(@"Backward button pressed");
//}

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
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
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

- (void)createExamSetupElements {
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
    int numExams = [self.numberOfExamsLabel.text intValue];
    
    //Adjust size of scrollview
    [self.scroller setContentSize:CGSizeMake(320, 1200+numExams*(SIZE_OF_EXAM_BLOCK))];
    
    //Initialize arrays
    self.examTitleLabels = [[NSMutableArray alloc] init];
    self.examWeightTextFields = [[NSMutableArray alloc] init];
    
    //Create text for Exam Setup title                                      //Was 710
    UILabel *examSetupTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 800, 150, 50)];
    
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
        UILabel *examLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 840+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
        
        //Set font size
        examLabel.font = [UIFont systemFontOfSize:17];
        
        //Set label text
        examLabel.text = examNumber;
        
        //Add label to scrollview
        [self.scroller addSubview:examLabel];
        
        //Add label to array
        [self.examTitleLabels addObject:examLabel];
        
        //Create exam weight text field
        UITextField *examWeight = [[UITextField alloc] initWithFrame:CGRectMake(20, 840+45+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
        
        [examWeight resignFirstResponder];
        examWeight.delegate = self;
        
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.restorationIdentifier isEqualToString:@"numberOfExams"]) {
        [self createExamSetupElements];
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

- (IBAction)creditHoursSliderChanged:(id)sender {
    self.creditHoursLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.creditHoursSlider.value];
}

- (IBAction)homeworkWeightSliderChanged:(id)sender {
    self.homeworkWeightLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.homeworkWeightSlider.value];
}

- (IBAction)quizWeightSliderChanged:(id)sender {
    self.quizWeightLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.quizWeightSlider.value];
}

- (IBAction)numberOfExamsSliderChanged:(id)sender {
    self.numberOfExamsLabel.text = [NSString stringWithFormat:@"%d", (int)self.numberOfExamsSlider.value];
}

- (IBAction)numberOfExamsSliderDidEndSliding:(id)sender {
    [self createExamSetupElements];
    [self.courseToAdd.examGrades removeAllObjects];
    [self.courseToAdd.examWeights removeAllObjects];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    //Initialize Course if not in edit mode (course is being created)
    
    [super viewDidLoad];
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(320, 1200)];
    
    //[self.view addSubview:self.courseImage];
    //[self.courseImage setImage:[UIImage imageNamed:@"calendar.png"]];
    
    //Populate fields so they can be edited
    if (self.editMode) {
        self.courseNameField.text = self.courseToAdd.courseName;
        self.courseNameField.enabled = NO;
        self.creditHoursSlider.value = [self.courseToAdd.creditHours floatValue];
        self.creditHoursLabel.text = [NSString stringWithFormat:@"%@", self.courseToAdd.creditHours];
        
        if (self.courseToAdd.professorName != nil)
            self.professorName.text = self.courseToAdd.professorName;
        if (self.courseToAdd.professorOfficeLocation != nil)
            self.professorOfficeLocation.text = self.courseToAdd.professorOfficeLocation;
        if (self.courseToAdd.professorEmailAddress != nil)
            self.professorEmailAddress.text = self.courseToAdd.professorEmailAddress;
        
        self.homeworkWeightLabel.text = [NSString stringWithFormat:@"%d%%", (int)([self.courseToAdd.homeworkWeight floatValue] * 100)];
        self.homeworkWeightSlider.value = [self.courseToAdd.homeworkWeight floatValue] * 100;
        self.quizWeightLabel.text = [NSString stringWithFormat:@"%d%%", (int)([self.courseToAdd.quizWeight floatValue] * 100)];
        self.quizWeightSlider.value = [self.courseToAdd.quizWeight floatValue] * 100;
        self.numberOfExamsLabel.text = [NSString stringWithFormat:@"%@", self.courseToAdd.numberOfExams];
        self.numberOfExamsSlider.value = [self.courseToAdd.numberOfExams floatValue];
    }
    //End populate fields so they can be edited
    
    if (self.editMode)
        [self createExamSetupElements];
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
