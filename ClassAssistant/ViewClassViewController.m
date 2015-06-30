//
//  ViewClassViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/18/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "ViewClassViewController.h"
#import "AddItemTabBarController.h"
#import "CalendarEventsTableViewController.h"
#import "TableViewController.h"
#import "ClassAssistant-Swift.h"

@interface ViewClassViewController ()

@end

@implementation ViewClassViewController

@synthesize classToView = _classToView;
@synthesize courseGrade = _courseGrade;

- (IBAction)backToAddClassViewFromCalendarView:(UIStoryboardSegue *)segue {
    
}

- (IBAction)backToClassView:(UIStoryboardSegue *) segue {
    AddItemTabBarController *source = [segue sourceViewController];
    
    Course* c = source.courseToEdit;
    
    double examAverage = 0;
    double quizAverage = 0;
    double homeworkAverage = 0;
    
    if (c != nil) {
        
        //[self.studentCourses addObject:c];
        //[self.tableView reloadData];
        
        _courseGrade.text = [NSString stringWithFormat:@"%.02f", [c calculateCurrentGrade]];
        _classToView.currentGrade = _courseGrade.text;
        NSLog(@"BackToClassView Current Grade: %@", _classToView.currentGrade);
        [_courseGrade setFont:[UIFont systemFontOfSize:24]];
        
        if (c.examGrades.count > 0) {
            for (int i = 0; i < c.examGrades.count; i++) {
                examAverage += [[c.examGrades objectAtIndex:i] doubleValue];
            }
            
            examAverage /= c.examGrades.count;
        }
        
        _examGrade.grade = (examAverage == 0) ? 0 : (int)examAverage;
        //_examGrade.grade = (int)examAverage;
        _examGradeNumber.text = (examAverage == 0) ? [NSString stringWithFormat:@"%d", 0] : [NSString stringWithFormat:@"%d", (int)examAverage];
        [_examGrade setNeedsDisplay];
        
        if (c.quizGrades.count > 0) {
            for (int i = 0; i < c.quizGrades.count; i++) {
                quizAverage += [[c.quizGrades objectAtIndex:i] doubleValue];
            }
            
            quizAverage /= c.quizGrades.count;
        }
        
        _quizGrade.grade = (quizAverage == 0) ? 0 : (int)quizAverage;
        //_quizGrade.grade = (int)quizAverage;
        //_quizGradeNumber.text = [NSString stringWithFormat:@"%d", (int)quizAverage];
        _quizGradeNumber.text = (quizAverage == 0) ? [NSString stringWithFormat:@"%d", 0] : [NSString stringWithFormat:@"%d", (int)quizAverage];
        [_quizGrade setNeedsDisplay];
        
        if (c.homeworkGrades.count > 0) {
            for (int i = 0; i < c.homeworkGrades.count; i++) {
                homeworkAverage += [[c.homeworkGrades objectAtIndex:i] doubleValue];
            }
            
            homeworkAverage /= c.homeworkGrades.count;
        }
        
        _homeworkGrade.grade = (homeworkAverage == 0) ? 0 : (int)homeworkAverage;
        //_homeworkGrade.grade = (int)homeworkAverage;
        _homeworkGradeNumber.text = (homeworkAverage == 0) ? [NSString stringWithFormat:@"%d", 0] : [NSString stringWithFormat:@"%d", (int)homeworkAverage];
        //_homeworkGradeNumber.text = [NSString stringWithFormat:@"%d", (int)homeworkAverage];
        [_homeworkGrade setNeedsDisplay];
        
        
        //If grade was entered...
        if (source.updateGraph == TRUE) {
            //Manage graph
            if ( ![self.classToView.currentGrade isEqual: @"-"] ) {
                NSString *temp = self.classToView.currentGrade;
                NSNumber *tempNum = [NSNumber numberWithInt:[temp intValue]];
                [self.classToView.previousGrades addObject:@([tempNum intValue])];
                self.gradeGraphView.graphPoints = self.classToView.previousGrades;
                NSLog(@"Count: %lu", self.gradeGraphView.graphPoints.count);
            }
        
            //Manage grade graph view
            self.gradeGraphView.hidden = false;
                self.zeroPercentLabel.hidden = false;
                self.twentyFivePercentLabel.hidden = false;
                self.fiftyPercentLabel.hidden = false;
                self.seventyFivePercentLabel.hidden = false;
                self.oneHundredPercentLabel.hidden = false;
            [self.gradeGraphView setNeedsDisplay];
            //End manage graph
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddGradeSegue"]) {
        AddItemTabBarController *destController = [segue destinationViewController];
        destController.courseToEdit = self.classToView;
    }
    
    else if ([segue.identifier isEqualToString:@"CalendarViewSegue"]) {
        NSLog(@"CalendarViewSegue triggered");
        CalendarEventsTableViewController *destController = [segue destinationViewController];
        destController.courseForEvents = self.classToView;
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

//TODO: Load view from previously entered data in Class object
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view addSubview:_gradeGraphView];
    [self.view addSubview:_scroller];
    [_scroller setScrollEnabled:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_scroller.contentSize = [self.view sizeThatFits:CGSizeZero];
    [_scroller setContentSize:CGSizeMake(320, 740)];
    
    if (self.classToView.previousGrades.count > 0 ) {
        //[self.classToView.previousGrades addObject:self.classToView.currentGrade];
        self.gradeGraphView.graphPoints = self.classToView.previousGrades;
    }
    
    //self.view.backgroundColor = [UIColor grayColor];
    
    //Manage grade graph view
        self.zeroPercentLabel.hidden = false;
        self.twentyFivePercentLabel.hidden = false;
        self.fiftyPercentLabel.hidden = false;
        self.seventyFivePercentLabel.hidden = false;
        self.oneHundredPercentLabel.hidden = false;
    [self.gradeGraphView setNeedsDisplay];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.professorName.text = [NSString stringWithFormat:@"Professor Name: %@", self.classToView.professorName];
    self.professorOfficeLocation.text = [NSString stringWithFormat:@"Office Location: %@", self.classToView.professorOfficeLocation];
    
    UIView *horLineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 180-58, self.view.bounds.size.width, 1)];
    horLineOne.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:horLineOne];
    
    UIView *vertLineOne = [[UIView alloc] initWithFrame:CGRectMake(140, 0-58, 1, 180)];
    vertLineOne.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:vertLineOne];
    
    UIView *horLineTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 320-58, self.view.bounds.size.width, 1)];
    horLineTwo.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:horLineTwo];
    
    UIView *vertLineTwo = [[UIView alloc] initWithFrame:CGRectMake(100, 320-58, 1, 80)];
    vertLineTwo.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:vertLineTwo];
    
    UIView *vertLineThree = [[UIView alloc] initWithFrame:CGRectMake(220, 320-58, 1, 80)];
    vertLineThree.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:vertLineThree];
    
    UIView *horLineThree = [[UIView alloc] initWithFrame:CGRectMake(0, 400-58, self.view.bounds.size.width, 1)];
    horLineThree.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:horLineThree];
    
    UILabel *nextTestOn = [[UILabel alloc] initWithFrame:CGRectMake(6, 325-58, 100, 20)];
    [nextTestOn setText:@"NEXT TEST ON"];
    [nextTestOn setFont:[UIFont systemFontOfSize:12]];
    nextTestOn.textColor = [UIColor whiteColor];
    [_scroller addSubview:nextTestOn];
    
    UILabel *calender = [[UILabel alloc] initWithFrame:CGRectMake(125, 325-58, 100, 20)];
    [calender setText:@"CALENDAR"];
    [calender setFont:[UIFont systemFontOfSize:12]];
    calender.textColor = [UIColor whiteColor];
    [_scroller addSubview:calender];
    
    UILabel *addItem = [[UILabel alloc] initWithFrame:CGRectMake(235, 325-58, 100, 20)];
    [addItem setText:@"ADD GRADE"];
    [addItem setFont:[UIFont systemFontOfSize:12]];
    addItem.textColor = [UIColor whiteColor];
    [_scroller addSubview:addItem];
    
    self.title = _classToView.courseName;
    
    _examGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    _quizGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    _homeworkGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    
    bool hasGrades = false;
    
    if (_classToView.examGrades.count > 0) {
        //Update examGradeNumber with exam average
        _examGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[_classToView calculateAverageForType:@"exam"]];
        _examGrade.grade = (int)[_classToView calculateAverageForType:@"exam"];
        hasGrades = true;
    }
    
    if (_classToView.quizGrades.count > 0) {
        _quizGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[_classToView calculateAverageForType:@"quiz"]];
        _quizGrade.grade = (int)[_classToView calculateAverageForType:@"quiz"];
        hasGrades = true;
    }
    
    if (_classToView.homeworkGrades.count > 0) {
        _homeworkGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[_classToView calculateAverageForType:@"homework"]];
        _homeworkGrade.grade = (int)[_classToView calculateAverageForType:@"homework"];
        hasGrades = true;
    }
    
    if (hasGrades) {
        _courseGrade.text = [NSString stringWithFormat:@"%.02f", [_classToView calculateCurrentGrade]];
        [_courseGrade setFont:[UIFont systemFontOfSize:15]];
    }
    
    //Load assignment due dates
    [self getDueDates];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIViewController *tableVC = self.navigationController.topViewController;
    
    if ([TableViewController class] == [tableVC class]) {
        [self performSegueWithIdentifier:@"backToTableViewFromClassViewSegue" sender:self];
    }
}

- (IBAction)emailProfessor:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        if (_classToView.professorEmailAddress != nil) {
            NSMutableArray *recipients = [[NSMutableArray alloc] init];
            [recipients addObject:_classToView.professorEmailAddress];
            [mailer setToRecipients:recipients];
        }
        else
            [mailer setSubject:@""];
        
        [mailer setMessageBody:@"" isHTML:NO];
        [mailer setSubject:@""];
        
        [self presentViewController:mailer animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//Populate UI elements for "Next test on..." and "Next assignment due..."
- (void)getDueDates {
    EKEventStore *store = [[EKEventStore alloc] init];
    
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    BOOL needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);
    
    //Not authorized yet
    if (needsToRequestAccessToEventStore) {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSLog(@"Access granted!");
            } else {
                // Denied
            }
        }];
    } else {
        //Previously authorized
        BOOL granted = (authorizationStatus == EKAuthorizationStatusAuthorized);
        if (granted) {
            // Granted
        } else {
            // Denied
        }
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *oneYearAgoComponents = [[NSDateComponents alloc] init];
    oneYearAgoComponents.year = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneYearAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    NSMutableArray *exams = [[NSMutableArray alloc] init];
    NSMutableArray *assignments = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < events.count; i++) {
        EKEvent *e = [events objectAtIndex:i];
        
        //If notes begin with "ClassAssistant"...                                                  If notes has at least 4 letters for type...
        if ([@"ClassAssistant" isEqualToString:[e.notes substringWithRange:NSMakeRange(0, 14)]] && e.notes.length >= 19) {
            
            //Only examining first 4 letters to avoid segmentation faults
            //Exam
            if ([@"Exam" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]] && e.title.length >= self.classToView.courseName.length) {
                //If event title begins with course name...
                if ([self.classToView.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.courseName.length)]]) {
                    [exams addObject:e.endDate];
                }
            }
            
            //Quiz
            else if ([@"Quiz" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.classToView.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.courseName.length)]]) {
                    [assignments addObject:e.endDate];
                }
            }
            
            //Homework
            else if ([@"Home" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.classToView.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.courseName.length)]]) {
                    [assignments addObject:e.endDate];
                }
            }
            
            //Other
            else if ([@"Othe" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.classToView.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.courseName.length)]]) {
                    [assignments addObject:e.endDate];
                }
            }
            
        }
    }
    
    if (exams.count > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:[exams objectAtIndex:exams.count-1]];
        _nextTestOnDate.text = strDate;
    }
    else
        _nextTestOnDate.text = @"-";
    
    if (assignments.count > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:[assignments objectAtIndex:assignments.count-1]];
        _nextAssignmentDueDate.text = strDate;
    }
    else
        _nextAssignmentDueDate.text = @"-";
    
}

- (void)viewWillAppear:(BOOL)animated {
    
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
