//
//  ViewClassViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/18/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "GradeIndicatorView.h"
#import "ClassAssistant-Swift.h"
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>

@interface ViewClassViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property Course *classToView;

@property (nonatomic, retain) IBOutlet UILabel *courseGrade;
@property (nonatomic, retain) IBOutlet GradeGraphView *gradeGraphView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (nonatomic, retain) IBOutlet UILabel *zeroPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel *twentyFivePercentLabel;
@property (nonatomic, retain) IBOutlet UILabel *fiftyPercentLabel;
@property (nonatomic, retain) IBOutlet UILabel *seventyFivePercentLabel;
@property (nonatomic, retain) IBOutlet UILabel *oneHundredPercentLabel;

//NEEDED??
@property (nonatomic, retain) IBOutlet UILabel *homeworkGradeLabel;
@property (nonatomic, retain) IBOutlet UILabel *quizGradeLabel;
@property (nonatomic, retain) IBOutlet UILabel *examGradeLabel;

@property (nonatomic, retain) IBOutlet UILabel *homeworkGradeNumber;
@property (nonatomic, retain) IBOutlet UILabel *quizGradeNumber;
@property (nonatomic, retain) IBOutlet UILabel *examGradeNumber;

@property (nonatomic, retain) IBOutlet UILabel *nextTestOnDate;
@property (nonatomic, retain) IBOutlet UILabel *nextAssignmentDueDate;

@property (weak, nonatomic) IBOutlet UILabel *professorName;
@property (weak, nonatomic) IBOutlet UILabel *professorOfficeLocation;

@property (nonatomic, retain) IBOutlet GradeIndicatorView *homeworkGrade;
@property (nonatomic, retain) IBOutlet GradeIndicatorView *quizGrade;
@property (nonatomic, retain) IBOutlet GradeIndicatorView *examGrade;

- (IBAction)backToClassView:(UIStoryboardSegue *)segue;
- (IBAction)backToAddClassViewFromCalendarView:(UIStoryboardSegue *)segue;
- (IBAction)emailProfessor:(id)sender;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
- (void)getDueDates;
- (IBAction)backFromAddOrEdit:(UIStoryboardSegue *) segue;


@end
