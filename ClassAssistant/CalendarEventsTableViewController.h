//
//  CalendarEventsTableViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/9/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "Course.h"
#import <UIKit/UIKit.h>

@interface CalendarEventsTableViewController : UITableViewController

@property NSMutableArray *matchingEvents;
@property NSMutableArray *quizzes;
@property NSMutableArray *homeworks;
@property NSMutableArray *exams;
@property NSMutableArray *other;
@property Course *courseForEvents;

- (IBAction)backToCalendarTableView:(UIStoryboardSegue *)segue;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)fetchCalendarEvents;

@end
