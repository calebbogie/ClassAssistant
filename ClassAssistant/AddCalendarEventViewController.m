//
//  CalendarViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/6/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "AddCalendarEventViewController.h"
#import "CalendarEventsTableViewController.h"

@interface AddCalendarEventViewController ()

@end

@implementation AddCalendarEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _store = [[EKEventStore alloc] init];
    
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    BOOL needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);
    
    //Not authorized yet
    if (needsToRequestAccessToEventStore) {
        [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
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
    
    _date = [[UIDatePicker alloc] init];
    _assignmentName.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addEvent:(id)sender {
    //If done button was pressed...
    if ([sender tag] == 2) {
        NSLog(@"Adding event...");
        //CalendarEventsTableViewController *parentController = (CalendarEventsTableViewController *)self.navigationController;
    
        NSString *courseName = self.courseName;
    
        NSLog(@"courseName: %@", courseName);
    
        EKEventStore *newEventStore = [[EKEventStore alloc] init];
    
        EKEvent *eventToAdd = [EKEvent eventWithEventStore:newEventStore];
    
        eventToAdd.startDate = _eventDate;
        eventToAdd.endDate = _eventDate;
        eventToAdd.title = [NSString stringWithFormat:@"%@ - %@", courseName, _assignmentName.text];
    
        NSLog(@"Title %@", eventToAdd.title);
        
        if (_type.selectedSegmentIndex == 0) {
            eventToAdd.notes = @"ClassAssistant Exam";
        }
        else if (_type.selectedSegmentIndex == 1) {
            eventToAdd.notes = @"ClassAssistant Quiz";
        }
        else if (_type.selectedSegmentIndex == 2) {
            eventToAdd.notes = @"ClassAssistant Homework";
        }
        else {
            eventToAdd.notes = @"ClassAssistant Other";
        }
    
        [eventToAdd setCalendar:[newEventStore defaultCalendarForNewEvents]];
    
        NSError *err;
        [newEventStore saveEvent:eventToAdd span:EKSpanThisEvent commit:YES error:&err];
    
        //Unwind segue. Segue is named on LHS of storyboard under segue action
        //[self performSegueWithIdentifier:@"backToCalendarTableView" sender:self];
    }
    
    //Perform unwind segue. Segue identifier is set in storyboard on left hand side under view controller properties
    [self performSegueWithIdentifier:@"backToCalendarTableSegue" sender:self];

}

- (IBAction)pickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    NSLog(@"Date: %@", strDate);
    _eventDate = [dateFormatter dateFromString:strDate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"backToCalendarTableSegue"])
        NSLog(@"going back!");
}


@end
