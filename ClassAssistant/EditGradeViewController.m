//
//  EditExamGradeViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 8/20/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "EditGradeViewController.h"
#import "AddItemTabBarController.h"

//Constants for animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

static const int SIZE_OF_EXAM_BLOCK = 75;

//@interface EditGradeViewController ()

//@end

@implementation EditGradeViewController

@synthesize scroller = _scroller;
@synthesize addHomework = _addHomework;
@synthesize addQuiz = _addQuiz;
@synthesize addExam = _addExam;

- (void) awakeFromNib {
    if([self.title isEqualToString:@"Exams"]) {
        self.title = @"Exams";
    }
    
    else if ([self.title isEqualToString:@"Homeworks"]) {
        self.title = @"Homeworks";
    }
    
    else if ([self.title isEqualToString:@"Quizzes"]) {
        self.title = @"Quizzes";
    }
    
    else if ([self.title isEqualToString:@"Other"]) {
        self.title = @"Other";
    }
    //[self.tabBarItem setImage: [UIImage imageNamed:@"image.png"]];
    //[self.tabBarItem setSelectedImage:[UIImage imageNamed:@"image-selected.png"]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self.title isEqualToString:@"Exams"]) {
        [self setupView:@"exam"];
    }
    
    else if ([self.title isEqualToString:@"Homeworks"]) {
        [self setupView:@"homework"];
    }
    
    else if ([self.title isEqualToString:@"Quizzes"]) {
        [self setupView:@"quiz"];
    }
    
    else if ([self.title isEqualToString:@"Other"]) {
        [self setupView:@"other"];
    }
    
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    [parentController.doneButton setEnabled:YES];
    parentController.updateGraph = FALSE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    [parentController.doneButton setEnabled:YES];
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.title isEqualToString:@"Exams"]) {
        [self modifyGrade:textField forType:@"exam"];
        //[self modifyExams:textField];
        
        [self computeAverage:@"exam"];
        
        [self addTextFieldForGrade:textField forType:@"exam"];
    }
    else if ([self.title isEqualToString:@"Quizzes"]) {
        [self modifyGrade:textField forType:@"quiz"];
        //[self modifyQuizzes:textField];
        
        [self computeAverage:@"quiz"];
        
        [self addTextFieldForGrade:textField forType:@"quiz"];
    }
    else if ([self.title isEqualToString:@"Homeworks"]) {
        [self modifyGrade:textField forType:@"homework"];
        //[self modifyHomeworks:textField];
        
        [self computeAverage:@"homework"];
        
        [self addTextFieldForGrade:textField forType:@"homework"];
    }
    
    else if ([self.title isEqualToString:@"Other"]) {
        [self modifyGrade:textField forType:@"other"];
        
        [self computeAverage:@"other"];
        
        [self addTextFieldForGrade:textField forType:@"other"];
    }
    
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    parentController.updateGraph = TRUE;
    
    CGSize oldSize = self.scroller.contentSize;
    [self.scroller setContentSize:CGSizeMake(320, oldSize.height + 90)];
    
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
    [textField resignFirstResponder];
    return YES;

}

- (void)computeAverage:(NSString *)type
{
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    double average = 0;
    
    //Calculate exam average
    if ([type isEqualToString:@"exam"]) {
        //No grades yet
        if (parentController.courseToEdit.examGrades.count == 0)
            _examAvg.text = @"-";
        else {
            //Call Course member function for computing average
            average = [parentController.courseToEdit calculateAverageForType:@"exam"];
            NSLog(@"Num exams: %@", parentController.courseToEdit.numberOfExams);
            _examAvg.text = [NSString stringWithFormat:@"%.02f", average];
        }
    }
    
    //Calculate quiz average
    else if ([type isEqualToString:@"quiz"]) {
        //No grades yet
        if (parentController.courseToEdit.quizGrades.count == 0)
            _quizAvg.text = @"-";
        else {
            //Call Course member function for computing average
            average = [parentController.courseToEdit calculateAverageForType:@"quiz"];
            
            _quizAvg.text = [NSString stringWithFormat:@"%.02f", average];
        }
    }
    
    //Calculate homework average
    else if ([type isEqualToString:@"homework"]) {
        //No grades yet
        if (parentController.courseToEdit.homeworkGrades.count == 0)
            _homeworkAvg.text = @"-";
        else {
            //Call Course member function for computing average
            average = [parentController.courseToEdit calculateAverageForType:@"homework"];
            
            _homeworkAvg.text = [NSString stringWithFormat:@"%.02f", average];
        }
    }
    
    else if ([type isEqualToString:@"other"]) {
        //No grades yet
        if (parentController.courseToEdit.otherGrades.count == 0)
            _otherAvg.text = @"-";
        else {
            //Call Course member function for computing average
            average = [parentController.courseToEdit calculateAverageForType:@"other"];
            
            _otherAvg.text = [NSString stringWithFormat:@"%.02f", average];
        }
    }
}

- (void)setupView:(NSString *)type
{
    //Initialize scrollview
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [_scroller setContentSize:CGSizeMake(320, 300)];
    [_scroller setScrollEnabled:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    int gradeCount = 0;
    
    //Comment out if method works
    int arraySize = 0;
    
    NSMutableArray *gradeArray = [[NSMutableArray alloc] init];
    
    //RESOLVE NAME OF TWO ABOVE VARIABLES
    
    if ([type isEqualToString:@"exam"]) {
        gradeCount = [parentController.courseToEdit.numberOfExams intValue];
        arraySize = (int)parentController.courseToEdit.examGrades.count;
        gradeArray = parentController.courseToEdit.examGrades;
    } else if ([type isEqualToString:@"quiz"]) {
        gradeCount = (int)parentController.courseToEdit.quizGrades.count + 1;
        NSLog(@"Grade count: %d", gradeCount);
        arraySize = gradeCount - 1;
        gradeArray = parentController.courseToEdit.quizGrades;
    } else if ([type isEqualToString:@"homework"]) {
        gradeCount = (int)parentController.courseToEdit.homeworkGrades.count + 1;
        arraySize = gradeCount - 1;
        gradeArray = parentController.courseToEdit.homeworkGrades;
    } else if ([type isEqualToString:@"other"]) {
        gradeCount = (int)parentController.courseToEdit.otherGrades.count + 1;
        arraySize = gradeCount - 1;
        gradeArray = parentController.courseToEdit.otherGrades;
    }
    
    NSLog(@"Array size: %d", arraySize);
    
    for (int i = 0; i < gradeCount; i++) {
        [self makeGradeTextFieldAndLabel:i forType:type forGradeArray:gradeArray];
    }
    
    //Create grade average title label
    //UILabel *gradeAverageLabel;
    
    if ([type isEqualToString:@"exam"]) {
        _gradeAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, ([parentController.courseToEdit.numberOfExams intValue]) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
        _gradeAverageLabel.text = @"Exam Average";
    }
    else if ([type isEqualToString:@"quiz"]) {
        _gradeAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, (parentController.courseToEdit.quizGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
        _gradeAverageLabel.text = @"Quiz Average";
    }
    else if ([type isEqualToString:@"homework"]) {
        _gradeAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (parentController.courseToEdit.homeworkGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
        _gradeAverageLabel.text = @"Homework Average";
    }
    else if ([type isEqualToString:@"other"]) {
        _gradeAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (parentController.courseToEdit.otherGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
        _gradeAverageLabel.text = @"Other Average";
    }
    
    
    //Add label to scroller
    [self.scroller addSubview:_gradeAverageLabel];
    
    //Create exam average label
    if ([type isEqualToString:@"exam"]) {
        _examAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, ([parentController.courseToEdit.numberOfExams intValue]) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
        [self computeAverage:@"exam"];
        
        //Change exam average font
        _examAvg.font = [UIFont systemFontOfSize:50];
        
        //Add label to scroller
        [self.scroller addSubview:_examAvg];
    }
    else if ([type isEqualToString:@"quiz"]) {
        _quizAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, (parentController.courseToEdit.quizGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
        [self computeAverage:@"quiz"];
        
        //Change quiz average font
        _quizAvg.font = [UIFont systemFontOfSize:50];
        
        //Add label to scroller
        [self.scroller addSubview:_quizAvg];
    }
    else if ([type isEqualToString:@"homework"]) {
        _homeworkAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, (parentController.courseToEdit.homeworkGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
        [self computeAverage:@"homework"];
        
        //Change homework average font
        _homeworkAvg.font = [UIFont systemFontOfSize:50];
        
        //Add label to scroller
        [self.scroller addSubview:_homeworkAvg];
    }
    else if ([type isEqualToString:@"other"]) {
        _otherAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, (parentController.courseToEdit.otherGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
        [self computeAverage:@"other"];
        
        //Change homework average font
        _otherAvg.font = [UIFont systemFontOfSize:50];
        
        //Add label to scroller
        [self.scroller addSubview:_otherAvg];
    }
    
    //Add scrollview to view
    [self.view addSubview:_scroller];
    
    //Set content size of exam scrollview
    //[_scroller setContentSize:CGSizeMake(320, 700)];
}

- (void)makeGradeTextFieldAndLabel:(int)i forType:(NSString *)type forGradeArray:(NSMutableArray *)gradeArray {
    //Create text for label
    NSString *gradeNumber;
    
    int arraySize = (int)gradeArray.count;
    
    if ([type isEqualToString:@"exam"])
        gradeNumber = [NSString stringWithFormat:@"Exam %d", i+1];
    else if ([type isEqualToString:@"quiz"])
        gradeNumber = [NSString stringWithFormat:@"Quiz %d", i+1];
    else if ([type isEqualToString:@"homework"])
        gradeNumber = [NSString stringWithFormat:@"Homework %d", i+1];
    else if ([type isEqualToString:@"other"])
        gradeNumber = [NSString stringWithFormat:@"Other %d", i+1];
    
    //Create label
    UILabel *gradeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
    
    //Set font size
    gradeNumberLabel.font = [UIFont systemFontOfSize:17];
    
    //Set label text
    gradeNumberLabel.text = gradeNumber;
    
    //Add label to scrollview
    [self.scroller addSubview:gradeNumberLabel];
    
    //Create grade text field
    UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 110+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
    
    if (arraySize > i) {
        NSString *grade = [NSString stringWithFormat:@"%@", [gradeArray objectAtIndex:i]];
        NSLog(@"element: %@", [gradeArray objectAtIndex:i]);
        gradeTextField.text = grade;
    }
    
    gradeTextField.delegate = self;
    
    //Necessary??
    if ([type isEqualToString:@"exam"])
        _addExam = gradeTextField;
    else if ([type isEqualToString:@"quiz"])
        _addQuiz = gradeTextField;
    else if ([type isEqualToString:@"homework"])
        _addHomework = gradeTextField;
    else if ([type isEqualToString:@"other"])
        _addOther = gradeTextField;
    
    //Setup grade text field
    gradeTextField.borderStyle = UITextBorderStyleRoundedRect;
    gradeTextField.backgroundColor = [UIColor whiteColor];
    //examGrade.keyboardType = UIKeyboardTypePhonePad;
    
    //Assign text field identifier
    NSString *restID;
    
    if ([type isEqualToString:@"exam"])
        restID = [NSString stringWithFormat:@"Exam %d", i+1];
    else if ([type isEqualToString:@"quiz"])
        restID = [NSString stringWithFormat:@"Quiz %d", i+1];
    else if ([type isEqualToString:@"homework"])
        restID = [NSString stringWithFormat:@"Homework %d", i+1];
    else if ([type isEqualToString:@"other"])
        restID = [NSString stringWithFormat:@"Other %d", i+1];
    
    gradeTextField.restorationIdentifier = restID;
    
    //Add text field to scrollview
    [self.scroller addSubview:gradeTextField];
}

- (void)modifyGrade:(UITextField *)textField forType:(NSString *)type {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    //Get number from textfield
    NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
    
    int gradeCount = 0;
    NSMutableArray *gradeArray = [[NSMutableArray alloc] init];
    
    if ([type isEqualToString:@"exam"]) {
        gradeCount = (int)parentController.courseToEdit.examGrades.count;
        gradeArray = parentController.courseToEdit.examGrades;
    }
    else if ([type isEqualToString:@"quiz"]) {
        gradeCount = (int)parentController.courseToEdit.quizGrades.count;
        gradeArray = parentController.courseToEdit.quizGrades;
    }
    else if ([type isEqualToString:@"homework"]) {
        gradeCount = (int)parentController.courseToEdit.homeworkGrades.count;
        gradeArray = parentController.courseToEdit.homeworkGrades;
    }
    else if ([type isEqualToString:@"other"]) {
        gradeCount = (int)parentController.courseToEdit.otherGrades.count;
        gradeArray = parentController.courseToEdit.otherGrades;
    }
    
    if (gradeCount == 0) {
        [gradeArray addObject:grade];
    }
    
    else {
        NSString *restID;
        
        for (int i = 0; i < gradeCount + 1; i++) {
            if ([type isEqualToString:@"exam"])
                restID = [NSString stringWithFormat:@"Exam %d", i+1];
            else if ([type isEqualToString:@"quiz"])
                restID = [NSString stringWithFormat:@"Quiz %d", i+1];
            else if ([type isEqualToString:@"homework"])
                restID = [NSString stringWithFormat:@"Homework %d", i+1];
            else if ([type isEqualToString:@"other"])
                restID = [NSString stringWithFormat:@"Other %d", i+1];
            
            //Get number from textfield
            NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
            
            if ([textField.restorationIdentifier isEqualToString:restID]) {
                
                //If object already exists, modify it
                if (gradeCount > i) {
                    [gradeArray replaceObjectAtIndex:i withObject:grade];
                }
                //If object doesn't exist, add it
                else {
                    [gradeArray addObject:grade];
                }
            }
        }
    }
}

- (void)addTextFieldForGrade:(UITextField *)textField forType:(NSString *)type {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    int nextGradeNumber = 0;
    NSMutableArray *gradeArray = [[NSMutableArray alloc] init];
    
    if ([type isEqualToString:@"exam"]) {
        //nextGradeNumber = parentController.courseToEdit.numberOfExams + 1;
    }
    
    else if ([type isEqualToString:@"quiz"]) {
        gradeArray = parentController.courseToEdit.quizGrades;
        nextGradeNumber = (int)gradeArray.count;
        
        //Change position of grade average just as I did in setupView
        _gradeAverageLabel.frame = CGRectMake(105, (parentController.courseToEdit.quizGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100);
        _quizAvg.frame = CGRectMake(145, (parentController.courseToEdit.quizGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100);
        
        [self makeGradeTextFieldAndLabel:nextGradeNumber forType:type forGradeArray:gradeArray];
    }
    
    else if ([type isEqualToString:@"homework"]) {
        gradeArray = parentController.courseToEdit.homeworkGrades;
        nextGradeNumber = (int)gradeArray.count;
        
        //Change position of grade average just as I did in setupView
        _gradeAverageLabel.frame = CGRectMake(105, (parentController.courseToEdit.homeworkGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100);
        _homeworkAvg.frame = CGRectMake(145, (parentController.courseToEdit.homeworkGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100);
        
        [self makeGradeTextFieldAndLabel:nextGradeNumber forType:type forGradeArray:gradeArray];
    }
    
    else if ([type isEqualToString:@"other"]) {
        gradeArray = parentController.courseToEdit.otherGrades;
        nextGradeNumber = (int)gradeArray.count;
        
        NSLog(@"Count: %lu", gradeArray.count);
        
        //Change position of grade average just as I did in setupView
        _gradeAverageLabel.frame = CGRectMake(105, (parentController.courseToEdit.otherGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100);
        _otherAvg.frame = CGRectMake(145, (parentController.courseToEdit.otherGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100);
        
        [self makeGradeTextFieldAndLabel:nextGradeNumber forType:type forGradeArray:gradeArray];
    }
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
