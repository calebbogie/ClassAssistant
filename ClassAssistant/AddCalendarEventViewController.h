//
//  CalendarViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/6/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface AddCalendarEventViewController : UIViewController <UITextFieldDelegate>

@property EKEventStore *store;
@property NSDate *eventDate;
@property NSString *courseName;

@property (nonatomic, retain) IBOutlet UITextField *assignmentName;
@property (nonatomic, retain) IBOutlet UIDatePicker *date;
@property (nonatomic, retain) IBOutlet UISegmentedControl *type;

- (IBAction)addEvent:(id)sender;
- (IBAction)pickerValueChanged:(UIDatePicker *)datePicker;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
