//
//  EditExamGradeViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 8/20/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "EditGradeViewController.h"
#import "AddItemTabBarController.h"

static const int SIZE_OF_EXAM_BLOCK = 75;

//@interface EditGradeViewController ()

//@end

@implementation EditGradeViewController

@synthesize scroller = _scroller;
@synthesize addHomework = _addHomework;
@synthesize addQuiz = _addQuiz;
@synthesize addExam = _addExam;

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
    
    if([self.title isEqualToString:@"Add Exam"]) {
        //[self setupExamView];
        [self setupView:@"exam"];
        self.title = @"Add Exam";
    }
    
    else if ([self.title isEqualToString:@"Add Homework"]) {
        //[self setupHomeworkView];
        [self setupView:@"homework"];
        self.title = @"Add Homework";
    }
    
    else if ([self.title isEqualToString:@"Add Quiz"]) {
        //[self setupQuizView];
        [self setupView:@"quiz"];
        self.title = @"Add Quiz";
    }
    
    //_examAvg = [[UILabel alloc] init];
    
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    [parentController.doneButton setEnabled:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    [parentController.doneButton setEnabled:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.title isEqualToString:@"Add Exam"]) {
        [self modifyGrade:textField forType:@"exam"];
        //[self modifyExams:textField];
        
        [self computeAverage:@"exam"];
        
        [self addTextFieldForGrade:textField forType:@"exam"];
    }
    else if ([self.title isEqualToString:@"Add Quiz"]) {
        [self modifyGrade:textField forType:@"quiz"];
        //[self modifyQuizzes:textField];
        
        [self computeAverage:@"quiz"];
        
        [self addTextFieldForGrade:textField forType:@"quiz"];
    }
    else if ([self.title isEqualToString:@"Add Homework"]) {
        [self modifyGrade:textField forType:@"homework"];
        //[self modifyHomeworks:textField];
        
        [self computeAverage:@"homework"];
        
        [self addTextFieldForGrade:textField forType:@"homework"];
    }
    
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
    
//    double average = 0;
//    
//    if ([type isEqualToString:@"exam"]) {
//        if (parentController.courseToEdit.examGrades.count == 0)
//            _examAvg.text = @"-";
//        else {
//            for (int i = 0; i < parentController.courseToEdit.examGrades.count; i++) {
//                average += [[parentController.courseToEdit.examGrades objectAtIndex:i] doubleValue];
//            }
//            
//            average /= parentController.courseToEdit.examGrades.count;
//        
//            _examAvg.text = [NSString stringWithFormat:@"%.02f", average];
//        }
//    }
//    
//    else if ([type isEqualToString:@"quiz"]) {
//        if (parentController.courseToEdit.quizGrades.count == 0)
//            _quizAvg.text = @"-";
//        else {
//            for (int i = 0; i < parentController.courseToEdit.quizGrades.count; i++) {
//                average += [[parentController.courseToEdit.quizGrades objectAtIndex:i] doubleValue];
//            }
//            
//            average /= parentController.courseToEdit.quizGrades.count;
//            
//            _quizAvg.text = [NSString stringWithFormat:@"%.02f", average];
//        }
//    }
//    
//    else if ([type isEqualToString:@"homework"]) {
//        if (parentController.courseToEdit.homeworkGrades.count == 0)
//            _homeworkAvg.text = @"-";
//        else {
//            for (int i = 0; i < parentController.courseToEdit.homeworkGrades.count; i++) {
//                average += [[parentController.courseToEdit.homeworkGrades objectAtIndex:i] doubleValue];
//            }
//            
//            average /= parentController.courseToEdit.homeworkGrades.count;
//            
//            _homeworkAvg.text = [NSString stringWithFormat:@"%.02f", average];
//        }
//    }
}

- (void)setupView:(NSString *)type
{
    //Initialize scrollview
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 520)];
    
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
    }
    
    for (int i = 0; i < gradeCount; i++) {
        
        [self makeGradeTextFieldAndLabel:i forType:type forGradeArray:gradeArray];
        
//        //Create text for label
//        NSString *gradeNumber;
//        
//        if ([type isEqualToString:@"exam"])
//            gradeNumber = [NSString stringWithFormat:@"Exam %d", i+1];
//        else if ([type isEqualToString:@"quiz"])
//            gradeNumber = [NSString stringWithFormat:@"Quiz %d", i+1];
//        else if ([type isEqualToString:@"homework"])
//            gradeNumber = [NSString stringWithFormat:@"Homework %d", i+1];
//        
//        //Create label
//        UILabel *gradeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
//        
//        //Set font size
//        gradeNumberLabel.font = [UIFont systemFontOfSize:17];
//        
//        //Set label text
//        gradeNumberLabel.text = gradeNumber;
//        
//        //Add label to scrollview
//        [self.scroller addSubview:gradeNumberLabel];
//        
//        //Create grade text field
//        UITextField *gradeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 110+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
//        
//        if (arraySize > i) {
//            NSString *grade = [NSString stringWithFormat:@"%@", [gradeArray objectAtIndex:i]];
//            NSLog(@"element: %@", [gradeArray objectAtIndex:i]);
//            gradeTextField.text = grade;
//        }
//        
//        gradeTextField.delegate = self;
//        
//        //Necessary??
//        if ([type isEqualToString:@"exam"])
//            _addExam = gradeTextField;
//        else if ([type isEqualToString:@"quiz"])
//            _addQuiz = gradeTextField;
//        else if ([type isEqualToString:@"homework"])
//            _addHomework = gradeTextField;
//        
//        //Setup grade text field
//        gradeTextField.borderStyle = UITextBorderStyleRoundedRect;
//        gradeTextField.backgroundColor = [UIColor whiteColor];
//        //examGrade.keyboardType = UIKeyboardTypePhonePad;
//        
//        //Assign text field identifier
//        NSString *restID;
//        
//        if ([type isEqualToString:@"exam"])
//            restID = [NSString stringWithFormat:@"Exam %d", i+1];
//        else if ([type isEqualToString:@"quiz"])
//            restID = [NSString stringWithFormat:@"Quiz %d", i+1];
//        else if ([type isEqualToString:@"homework"])
//            restID = [NSString stringWithFormat:@"Homework %d", i+1];
//        
//        gradeTextField.restorationIdentifier = restID;
//        
//        //Add text field to scrollview
//        [self.scroller addSubview:gradeTextField];
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
    
    //_examAvg.frame = CGRectMake(145, (parentController.courseToEdit.numberOfExams + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100);
    
    // ****************************** TO DO **********************************
    // *************************** move avg calc to Course class *************************
    //Assign exam average text
    
    //Add scrollview to view
    [self.view addSubview:_scroller];
    
    //Set content size of exam scrollview
    [_scroller setContentSize:CGSizeMake(320, 700)];
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
    
    gradeTextField.restorationIdentifier = restID;
    
    //Add text field to scrollview
    [self.scroller addSubview:gradeTextField];
}

/*
- (void)setupExamView {
    //Initialize exam scrollview
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 520)];
 
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    for (int i = 0; i < parentController.courseToEdit.numberOfExams; i++) {
        
        //Create text for label
        NSString *examNumber = [NSString stringWithFormat:@"Exam %d", i+1];
        
        //Create label
        UILabel *examLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
        
        //Set font size
        examLabel.font = [UIFont systemFontOfSize:17];
        
        //Set label text
        examLabel.text = examNumber;
        
        //Add label to scrollview
        [self.scroller addSubview:examLabel];
        
        //Create exam grade text field
        UITextField *examGrade = [[UITextField alloc] initWithFrame:CGRectMake(20, 110+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
        
        if (parentController.courseToEdit.examGrades.count > i) {
            NSString *grade = [NSString stringWithFormat:@"%@", [parentController.courseToEdit.examGrades objectAtIndex:i]];
            NSLog(@"element: %@", [parentController.courseToEdit.examGrades objectAtIndex:i]);
            examGrade.text = grade;
        }
        
        examGrade.delegate = self;
        
        _addExam = examGrade;
        
        //Setup exam grade text field
        examGrade.borderStyle = UITextBorderStyleRoundedRect;
        examGrade.backgroundColor = [UIColor whiteColor];
        //examGrade.keyboardType = UIKeyboardTypePhonePad;
        
        //Assign text field identifier
        NSString *restID = [NSString stringWithFormat:@"Exam %d", i+1];
        examGrade.restorationIdentifier = restID;
        
        //Add text field to scrollview
        [self.scroller addSubview:examGrade];
    }
    
    //Create exam average title label
    UILabel *examAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, (parentController.courseToEdit.numberOfExams + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
    
    //Assign exam average label text
    examAverageLabel.text = @"Exam Average";
    
    //Add label to scroller
    [self.scroller addSubview:examAverageLabel];
    
    //Create exam average label
    _examAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, (parentController.courseToEdit.numberOfExams + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
    
    //_examAvg.frame = CGRectMake(145, (parentController.courseToEdit.numberOfExams + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100);

    // ****************************** TO DO **********************************
    // *************************** Calculate average *************************
    //Assign exam average text
    
    [self computeAverage:@"exam"];
    
    //Change exam average font
    _examAvg.font = [UIFont systemFontOfSize:50];
    
    //Add label to scroller
    [self.scroller addSubview:_examAvg];
    
    //Add scrollview to view
    [self.view addSubview:_scroller];
    
    //Set content size of exam scrollview
    [_scroller setContentSize:CGSizeMake(320, 700)];
}

- (void)setupHomeworkView {
    
    NSLog(@"Starting...");
    
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 520)];
    
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    NSLog(@"Parent Controller set...");
    
    if (!parentController.courseToEdit.homeworkGrades) {
        parentController.courseToEdit.homeworkGrades = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"Allocated array...");
    
    for (int i = 0; i < parentController.courseToEdit.homeworkGrades.count + 1; i++) {
        
        //Create text for label
        NSString *homeworkNumber = [NSString stringWithFormat:@"Homework %d", i+1];
        
        //Create label
        UILabel *homeworkLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
        
        //Set font size
        homeworkLabel.font = [UIFont systemFontOfSize:17];
        
        //Set label text
        homeworkLabel.text = homeworkNumber;
        
        //Add label to scrollview
        [self.scroller addSubview:homeworkLabel];
        
        //Create quiz grade text field
        UITextField *homeworkGrade = [[UITextField alloc] initWithFrame:CGRectMake(20, 110+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
        
        if (parentController.courseToEdit.homeworkGrades.count > i) {
            NSString *grade = [NSString stringWithFormat:@"%@", [parentController.courseToEdit.homeworkGrades objectAtIndex:i]];
            NSLog(@"element: %@", [parentController.courseToEdit.homeworkGrades objectAtIndex:i]);
            homeworkGrade.text = grade;
        }
        
        homeworkGrade.delegate = self;
        
        // **************************
        //TODO: Need to make newHomework an array because there will be more fields to fill eventually
        
        //_addHomework = homeworkGrade;
        
        //Setup quiz grade text field
        homeworkGrade.borderStyle = UITextBorderStyleRoundedRect;
        homeworkGrade.backgroundColor = [UIColor whiteColor];
        homeworkGrade.keyboardType = UIKeyboardTypeAlphabet;
        
        //Assign text field identifier
        NSString *restID = [NSString stringWithFormat:@"Homework %d", i+1];
        homeworkGrade.restorationIdentifier = restID;
        
        //Add text field to scrollview
        [self.scroller addSubview:homeworkGrade];
    }
    
    //Create homework average title label
    UILabel *homeworkAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (parentController.courseToEdit.homeworkGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
    
    //Assign homework average label text
    homeworkAverageLabel.text = @"Homework Average";
    
    //Add label to scroller
    [self.scroller addSubview:homeworkAverageLabel];
    
    //Create homework average label
    _homeworkAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, (parentController.courseToEdit.homeworkGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
    
    //Assign homework average text
    [self computeAverage:@"homework"];
    
    //Change homework average font
    _homeworkAvg.font = [UIFont systemFontOfSize:50];
    
    //Add label to scroller
    [self.scroller addSubview:_homeworkAvg];
    
    //Add scrollview to view
    [self.view addSubview:_scroller];
    
    //Set content size of exam scrollview
    [_scroller setContentSize:CGSizeMake(320, 700)];
}

- (void)setupQuizView {
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 520)];
    
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    if (!parentController.courseToEdit.quizGrades) {
        parentController.courseToEdit.quizGrades = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < parentController.courseToEdit.quizGrades.count + 1; i++) {
        
        //Create text for label
        NSString *quizNumber = [NSString stringWithFormat:@"Quiz %d", i+1];
        
        //Create label
        UILabel *quizLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70+SIZE_OF_EXAM_BLOCK*i, 150, 50)];
        
        //Set font size
        quizLabel.font = [UIFont systemFontOfSize:17];
        
        //Set label text
        quizLabel.text = quizNumber;
        
        //Add label to scrollview
        [self.scroller addSubview:quizLabel];
        
        //Create quiz grade text field
        UITextField *quizGrade = [[UITextField alloc] initWithFrame:CGRectMake(20, 110+SIZE_OF_EXAM_BLOCK*i, 280, 30)];
        
        if (parentController.courseToEdit.quizGrades.count > i) {
            NSString *grade = [NSString stringWithFormat:@"%@", [parentController.courseToEdit.quizGrades objectAtIndex:i]];
            NSLog(@"element: %@", [parentController.courseToEdit.quizGrades objectAtIndex:i]);
            quizGrade.text = grade;
        }
        
        quizGrade.delegate = self;
        
        _addQuiz = quizGrade;
        
        //Setup quiz grade text field
        quizGrade.borderStyle = UITextBorderStyleRoundedRect;
        quizGrade.backgroundColor = [UIColor whiteColor];
        quizGrade.keyboardType = UIKeyboardTypePhonePad;
        
        //Assign text field identifier
        NSString *restID = [NSString stringWithFormat:@"Quiz %d", i+1];
        quizGrade.restorationIdentifier = restID;
        
        //Add text field to scrollview
        [self.scroller addSubview:quizGrade];
    }
    
    //Create quiz average title label
    UILabel *quizAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, (parentController.courseToEdit.quizGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 70, 280, 100)];
    
    //Assign quiz average label text
    quizAverageLabel.text = @"Quiz Average";
    
    //Add label to scroller
    [self.scroller addSubview:quizAverageLabel];
    
    //Create quiz average label
    _quizAvg = [[UILabel alloc] initWithFrame:CGRectMake(145, (parentController.courseToEdit.quizGrades.count + 1) * SIZE_OF_EXAM_BLOCK + 130, 280, 100)];
    
    //Assign quiz average text
    [self computeAverage:@"quiz"];
    
    //Change quiz average font
    _quizAvg.font = [UIFont systemFontOfSize:50];
    
    //Add label to scroller
    [self.scroller addSubview:_quizAvg];
    
    //Add scrollview to view
    [self.view addSubview:_scroller];
    
    //Set content size of exam scrollview
    [_scroller setContentSize:CGSizeMake(320, 700)];

}
 */

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
            
            //Get number from textfield
            NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
            
            if ([textField.restorationIdentifier isEqualToString:restID]) {
                
                //If object already exists, modify it
                if (gradeCount > i) {
                    [gradeArray replaceObjectAtIndex:i withObject:grade];
                }
                //If object doesn't exist, add it
                else {
                    NSLog(@"Adding grade...");
                    [gradeArray addObject:grade];
                }
            }
        }
    }
    
    if (gradeCount > 0)
        NSLog(@"Grade 1: %@", [gradeArray objectAtIndex:0]);
    
    //NSLog(@"Exam 1 Grade: %@", [parentController.courseToEdit.examGrades objectAtIndex:0]);
    
}

- (void)addTextFieldForGrade:(UITextField *)textField forType:(NSString *)type {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    int nextGradeNumber = 0;
    NSMutableArray *gradeArray = [[NSMutableArray alloc] init];
    
    if ([type isEqualToString:@"exam"])
        //nextGradeNumber = parentController.courseToEdit.numberOfExams + 1;
        NSLog(@"Shouldn't have to add an exam field...");
    
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
}

/*
- (void)modifyExams:(UITextField *)textField {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    //Get number from textfield
    NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
    
    if (parentController.courseToEdit.examGrades.count == 0) {
        [parentController.courseToEdit.examGrades addObject:grade];
    }
    
    else {
        for (int i = 0; i < parentController.courseToEdit.examWeights.count + 1; i++) {
            NSString *restID = [NSString stringWithFormat:@"Exam %d", i+1];
        
            //Get number from textfield
            NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
        
            if ([textField.restorationIdentifier isEqualToString:restID]) {
            
                //If object already exists, modify it
                if (parentController.courseToEdit.quizGrades.count > i) {
                    [parentController.courseToEdit.examGrades replaceObjectAtIndex:i withObject:grade];
                }
                //If object doesn't exist, add it
                else {
                    NSLog(@"Adding grade...");
                    [parentController.courseToEdit.examGrades addObject:grade];
                }
            }
        }
    }
    
    if (parentController.courseToEdit.examGrades.count > 0)
        NSLog(@"Exam 1 Grade: %@", [parentController.courseToEdit.examGrades objectAtIndex:0]);
    
    //NSLog(@"Exam 1 Grade: %@", [parentController.courseToEdit.examGrades objectAtIndex:0]);
    
}

- (void)modifyQuizzes:(UITextField *)textField {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    //Get number from textfield
    NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
    
    if (parentController.courseToEdit.quizGrades.count == 0) {
        [parentController.courseToEdit.quizGrades addObject:grade];
    }
    
    else {
        NSLog(@"Else case...");
        
        for (int i = 0; i < parentController.courseToEdit.quizGrades.count + 1; i++) {
            NSString *restID = [NSString stringWithFormat:@"Quiz %d", i+1];
        
            NSLog(@"restID: %@", textField.restorationIdentifier);
        
            if ([textField.restorationIdentifier isEqualToString:restID]) {
            
                //If object already exists, modify it
                if (parentController.courseToEdit.quizGrades.count > i) {
                    [parentController.courseToEdit.quizGrades replaceObjectAtIndex:i withObject:grade];
                }
                //If object doesn't exist, add it
                else {
                    NSLog(@"Adding grade...");
                    [parentController.courseToEdit.quizGrades addObject:grade];
                }
            }
        }
    }
    
    if (parentController.courseToEdit.quizGrades.count > 1) {
        NSLog(@"Quiz 1 Grade: %@", [parentController.courseToEdit.quizGrades objectAtIndex:0]);
        NSLog(@"Quiz 2 Grade: %@", [parentController.courseToEdit.quizGrades objectAtIndex:1]);
    }
}

- (void)modifyHomeworks:(UITextField *)textField {
    AddItemTabBarController *parentController = (AddItemTabBarController *)self.tabBarController;
    
    //Get number from textfield
    NSNumber *grade = [NSNumber numberWithFloat:[textField.text floatValue]];
    
    if (parentController.courseToEdit.homeworkGrades.count == 0) {
        [parentController.courseToEdit.homeworkGrades addObject:grade];
    }
    
    else {
        for (int i = 0; i < parentController.courseToEdit.homeworkGrades.count + 1; i++) {
            NSString *restID = [NSString stringWithFormat:@"Homework %d", i+1];
        
            if ([textField.restorationIdentifier isEqualToString:restID]) {
            
                //If object already exists, modify it
                if (parentController.courseToEdit.homeworkGrades.count > i) {
                    [parentController.courseToEdit.homeworkGrades replaceObjectAtIndex:i withObject:grade];
                }
                //If object doesn't exist, add it
                else {
                    [parentController.courseToEdit.homeworkGrades addObject:grade];
                }
            }
        }
    }
    
    if (parentController.courseToEdit.homeworkGrades.count > 0)
        NSLog(@"Homework 1 Grade: %@", [parentController.courseToEdit.homeworkGrades objectAtIndex:0]);
}
 
 */

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
