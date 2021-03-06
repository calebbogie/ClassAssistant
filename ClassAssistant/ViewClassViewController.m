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
#import "AddClassViewController.h"

@interface ViewClassViewController ()

@end

@implementation ViewClassViewController

@synthesize classToView = _classToView;
@synthesize courseGrade = _courseGrade;

- (IBAction)backToClassViewFromCalendarView:(UIStoryboardSegue *)segue {
    NSLog(@"Going back!");
    //Load assignment due dates
    [self getDueDates];
}

- (IBAction)backToViewClassView:(UIStoryboardSegue *) segue {
    NSLog(@"backToViewClassView!");
}

- (IBAction)cancelledBackFromAddOrEdit:(UIStoryboardSegue *) segue {
    //Shouldn't do anything
}

- (IBAction)backFromAddOrEdit:(UIStoryboardSegue *) segue {
    AddClassViewController *source = [segue sourceViewController];
    self.classToView = source.courseToAdd;
}

- (IBAction)backToClassView:(UIStoryboardSegue *) segue {
    AddItemTabBarController *source = [segue sourceViewController];
    //CHANGE
    Course* c = source.courseToEdit;
    
    double examAverage = 0;
    double quizAverage = 0;
    double homeworkAverage = 0;
    double otherAverage = 0;
    
    if (c != nil) {
        
        //[self.studentCourses addObject:c];
        //[self.tableView reloadData];
        
        _courseGrade.text = [NSString stringWithFormat:@"%.02f", [c calculateCurrentGrade]];
        _classToView.data.currentGrade = _courseGrade.text;
        NSLog(@"BackToClassView Current Grade: %@", _classToView.data.currentGrade);
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
        
        // **************************** IBOutlets need to be added to UI
        if (c.otherGrades.count > 0) {
            for (int i = 0; i < c.otherGrades.count; i++) {
                homeworkAverage += [[c.otherGrades objectAtIndex:i] doubleValue];
            }
            
            homeworkAverage /= c.otherGrades.count;
        }
        
        _otherGrade.grade = (otherAverage == 0) ? 0 : (int)otherAverage;
        //_homeworkGrade.grade = (int)homeworkAverage;
        _otherGradeNumber.text = (otherAverage == 0) ? [NSString stringWithFormat:@"%d", 0] : [NSString stringWithFormat:@"%d", (int)otherAverage];
        //_homeworkGradeNumber.text = [NSString stringWithFormat:@"%d", (int)homeworkAverage];
        [_otherGrade setNeedsDisplay];
        
        // **************************** END IBOutlets need to be added to UI
        
        //If grade was entered...
        if (source.updateGraph == TRUE) {
            //Manage graph
            if ( ![self.classToView.data.currentGrade isEqual: @"-"] ) {
                NSString *temp = self.classToView.data.currentGrade;
                NSNumber *tempNum = [NSNumber numberWithInt:[temp intValue]];
                [self.classToView.data.previousGrades addObject:@([tempNum intValue])];
                self.gradeGraphView.graphPoints = self.classToView.data.previousGrades;
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
        destController.courseToEdit = self.classToView.data;
    }
    
    else if ([segue.identifier isEqualToString:@"CalendarViewSegue"]) {
        NSLog(@"CalendarViewSegue triggered");
        CalendarEventsTableViewController *destController = [segue destinationViewController];
        destController.courseForEvents = self.classToView;
    }
    
    else if ([segue.identifier isEqualToString:@"EditCourseSegue"]) {
        NSLog(@"EditCourseSegue triggered!");
        AddClassViewController *destController = [segue destinationViewController];
        destController.courseToAdd = self.classToView;
        destController.editMode = YES;
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
    [_scroller setContentSize:CGSizeMake(320, 800)];
    
    if (self.classToView.data.previousGrades.count > 0 ) {
        //[self.classToView.previousGrades addObject:self.classToView.currentGrade];
        self.gradeGraphView.graphPoints = self.classToView.data.previousGrades;
    }
    
    //self.view.backgroundColor = [UIColor grayColor];
    
    //Manage grade graph view
    self.zeroPercentLabel.hidden = false;
    self.twentyFivePercentLabel.hidden = false;
    self.fiftyPercentLabel.hidden = false;
    self.seventyFivePercentLabel.hidden = false;
    self.oneHundredPercentLabel.hidden = false;
    [self.gradeGraphView setNeedsDisplay];
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.professorName.text = [NSString stringWithFormat:@"Professor Name: %@", self.classToView.data.professorName];
    self.professorOfficeLocation.text = [NSString stringWithFormat:@"Office Location: %@", self.classToView.data.professorOfficeLocation];
    
    UIView *horLineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 180-58, self.view.bounds.size.width, 1)];
    horLineOne.backgroundColor = [UIColor whiteColor];
    [_scroller addSubview:horLineOne];
    
    UIView *vertLineOne = [[UIView alloc] initWithFrame:CGRectMake(140, -200, 1, 322)];
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
    
    self.title = _classToView.data.courseName;
    
    _examGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    _quizGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    _homeworkGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    _otherGradeNumber.text = [NSString stringWithFormat:@"%d", 0];
    
    bool hasGrades = false;
    
    if (_classToView.data.examGrades.count > 0) {
        //Update examGradeNumber with exam average
        _examGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[[_classToView getData] calculateAverageForType:@"exam"]];
        _examGrade.grade = (int)[[_classToView getData] calculateAverageForType:@"exam"];
        hasGrades = true;
    }
    
    if (_classToView.data.quizGrades.count > 0) {
        _quizGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[[_classToView getData] calculateAverageForType:@"quiz"]];
        _quizGrade.grade = (int)[[_classToView getData] calculateAverageForType:@"quiz"];
        hasGrades = true;
    }
    
    if (_classToView.data.homeworkGrades.count > 0) {
        _homeworkGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[[_classToView getData] calculateAverageForType:@"homework"]];
        _homeworkGrade.grade = (int)[[_classToView getData] calculateAverageForType:@"homework"];
        hasGrades = true;
    }
    
    if (_classToView.data.otherGrades.count > 0) {
        _otherGradeNumber.text = [NSString stringWithFormat:@"%d", (int)[[_classToView getData] calculateAverageForType:@"other"]];
        _otherGrade.grade = (int)[[_classToView getData] calculateAverageForType:@"other"];
        hasGrades = true;
    }
    
    if (hasGrades) {
        _courseGrade.text = [NSString stringWithFormat:@"%.02f", [[_classToView getData] calculateCurrentGrade]];
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
        
        if (_classToView.data.professorEmailAddress != nil) {
            NSMutableArray *recipients = [[NSMutableArray alloc] init];
            [recipients addObject:_classToView.data.professorEmailAddress];
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
    
    NSDateComponents *c = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [c day];
    NSInteger month = [c month];
    NSInteger year = [c year];
    
    // Create the start date components
    NSDateComponents *oneYearAgoComponents = [[NSDateComponents alloc] init];
    //Was -1
    oneYearAgoComponents.year = year;
    oneYearAgoComponents.month = month;
    oneYearAgoComponents.day = day;
    
    NSDate *startDate = [calendar dateFromComponents:oneYearAgoComponents];
    //NSDate *oneDayAgo = [calendar dateByAddingComponents:oneYearAgoComponents
      //                                            toDate:[NSDate date]
        //                                         options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate
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
            if ([@"Exam" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]] && e.title.length >= self.classToView.data.courseName.length) {
                //If event title begins with course name...
                if ([self.classToView.data.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.data.courseName.length)]]) {
                    [exams addObject:e.endDate];
                }
            }
            
            //Quiz
            else if ([@"Quiz" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.classToView.data.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.data.courseName.length)]]) {
                    [assignments addObject:e.endDate];
                }
            }
            
            //Homework
            else if ([@"Home" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.classToView.data.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.data.courseName.length)]]) {
                    [assignments addObject:e.endDate];
                }
            }
            
            //Other
            else if ([@"Othe" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.classToView.data.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.classToView.data.courseName.length)]]) {
                    [assignments addObject:e.endDate];
                }
            }
            
        }
    }
    
    if (exams.count > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        //NSString *strDate = [dateFormatter stringFromDate:[exams objectAtIndex:exams.count-1]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        //NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[exams objectAtIndex:exams.count-1]];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[exams objectAtIndex:0]];
        
        //_nextTestOnMonth.text = strDate;
        //NSString *monthWord = [NSString stringWithFormat:@"%ld",(long)[components month]];
        
        NSInteger monthNum = [components month];
        
        if (monthNum == 1)
            _nextTestOnMonth.text = @"JANUARY";
        else if (monthNum == 2)
            _nextTestOnMonth.text = @"FEBRUARY";
        else if (monthNum == 3)
            _nextTestOnMonth.text = @"MARCH";
        else if (monthNum == 4)
            _nextTestOnMonth.text = @"APRIL";
        else if (monthNum == 5)
            _nextTestOnMonth.text = @"MAY";
        else if (monthNum == 6)
            _nextTestOnMonth.text = @"JUNE";
        else if (monthNum == 7)
            _nextTestOnMonth.text = @"JULY";
        else if (monthNum == 8)
            _nextTestOnMonth.text = @"AUGUST";
        else if (monthNum == 9)
            _nextTestOnMonth.text = @"SEPTEMBER";
        else if (monthNum == 10)
            _nextTestOnMonth.text = @"OCTOBER";
        else if (monthNum == 11)
            _nextTestOnMonth.text = @"NOVEMBER";
        else if (monthNum == 12)
            _nextTestOnMonth.text = @"DECEMBER";
        
        _nextTestOnDay.text = [NSString stringWithFormat:@"%ld",(long)[components day]];
    }
    else {
        _nextTestOnDay.text = @"-";
        _nextTestOnMonth.text = @"";
    }
    
    if (assignments.count > 0) {
        NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        NSInteger currentDay = [component day];
        NSInteger currentMonth = [component month];
        NSInteger currentYear = [component year];
        
        //NSString *string = [NSString stringWithFormat:@"%ld.%ld.%ld", (long)day, (long)week, (long)year];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        //NSString *strDate = [dateFormatter stringFromDate:[assignments objectAtIndex:assignments.count-1]];
        //NSString *strDate = [dateFormatter stringFromDate:[assignments objectAtIndex:0]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[assignments objectAtIndex:0]];
        
        NSInteger assignmentDay = [components day];
        NSInteger assignmentMonth = [components month];
        NSInteger assignmentYear = [components year];
        
        //NSInteger daysUntilDue = 0;
        
        if (assignmentYear > currentYear) {
            NSLog(@"Years are different");
        }
        else if (assignmentMonth > currentMonth) {
            _nextAssignmentDueDate.text = [NSString stringWithFormat:@"%ld MONTHS", assignmentMonth - currentMonth];
        }
        else if (assignmentDay > currentDay) {
            if (assignmentDay - currentDay == 1)
                _nextAssignmentDueDate.text = [NSString stringWithFormat:@"%ld DAY", assignmentDay - currentDay];
            else
                _nextAssignmentDueDate.text = [NSString stringWithFormat:@"%ld DAYS", assignmentDay - currentDay];
        }
        
        //_nextAssignmentDueDate.text = strDate;
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
