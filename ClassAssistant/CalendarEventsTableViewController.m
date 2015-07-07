//
//  CalendarEventsTableViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/9/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "CalendarEventsTableViewController.h"
#import "AddCalendarEventViewController.h"
#import "CustomCellBackground.h"

@interface CalendarEventsTableViewController ()

@end

@implementation CalendarEventsTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Transition from Table View to Class View
    if([segue.identifier isEqualToString:@"CalendarEventSegue"]) {
        
        //self.selectedClassNumber = [self.tableView indexPathForSelectedRow].row;
        
        //ViewClassViewController *destController = [segue destinationViewController];
        //destController.classToView = [self.studentCourses objectAtIndex:_selectedClassNumber];
    }
    
    else if ([segue.identifier isEqualToString:@"AddCalendarEventSegue"]) {
        UINavigationController *navController = [segue destinationViewController];
        AddCalendarEventViewController *destViewController = (AddCalendarEventViewController *)([navController viewControllers][0]);
        
        destViewController.courseName = self.courseForEvents.courseName;
    }
}

- (void)fetchCalendarEvents {
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
    
    if (_matchingEvents == nil)
        _matchingEvents = [[NSMutableArray alloc] init];
    else
        [_matchingEvents removeAllObjects];
    
    NSString *courseName = self.courseForEvents.courseName;
    NSLog(@"Course Name: %@", courseName);
    
    //Populate matchingEvents array
    for (int i = 0; i < events.count; i++) {
        EKEvent *e = [events objectAtIndex:i];
        NSString *note = [e.notes substringWithRange:NSMakeRange(0, 14)];
        if ([note isEqualToString:@"ClassAssistant"] && [courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, courseName.length)]]) {
            [_matchingEvents addObject:e];
            
            NSLog(@"Notes: %@", e.notes);
            
            //Only examining first 4 letters to avoid segmentation faults
            //Exam
            if ([@"Exam" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]] && e.title.length >= self.courseForEvents.courseName.length) {
                //If event title begins with course name...
                if ([self.courseForEvents.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.courseForEvents.courseName.length)]]) {
                    [_exams addObject:e];
                }
            }
            
            //Quiz
            else if ([@"Quiz" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.courseForEvents.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.courseForEvents.courseName.length)]]) {
                    [_quizzes addObject:e];
                }
            }
            
            //Homework
            else if ([@"Home" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.courseForEvents.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.courseForEvents.courseName.length)]]) {
                    [_homeworks addObject:e];
                }
            }
            
            //Other
            else if ([@"Othe" isEqualToString:[e.notes substringWithRange:NSMakeRange(15, 4)]]) {
                //If event title begins with course name...
                if ([self.courseForEvents.courseName isEqualToString:[e.title substringWithRange:NSMakeRange(0, self.courseForEvents.courseName.length)]]) {
                    [_other addObject:e];
                }
            }
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    //ViewClassViewController *vc = self.navigationController.topViewController;
    [self performSegueWithIdentifier:@"backToClassViewFromCalendarView" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.exams = [[NSMutableArray alloc] init];
    self.quizzes = [[NSMutableArray alloc] init];
    self.homeworks = [[NSMutableArray alloc] init];
    self.other = [[NSMutableArray alloc] init];
    
    //Set up table to accept "CalenderEventsTableViewID" identifiers for cells
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CalendarEventsTableViewID"];
    
    [self fetchCalendarEvents];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToCalendarTableView:(UIStoryboardSegue *)segue {
    //AddCalendarEventViewController *source = [segue sourceViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0) {
        NSLog(@"Exam count: %lu", self.exams.count);
        return self.exams.count;
    }
    else if (section == 1) {
        NSLog(@"quiz count: %lu", self.quizzes.count);
        return self.quizzes.count;
    }
    else if (section == 2) {
        NSLog(@"homework count: %lu", self.homeworks.count);
        return self.homeworks.count;
    }
    else if (section == 3) {
        NSLog(@"other count: %lu", self.other.count);
        return self.other.count;
    }
    return self.matchingEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    cellIdentifier = @"CalendarEventsTableViewID";
    
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (![cell.backgroundView isKindOfClass:[CustomCellBackground class]]) {
        cell.backgroundView = [[CustomCellBackground alloc] init];
    }
    
    if (![cell.selectedBackgroundView isKindOfClass:[CustomCellBackground class]]) {
        cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    }
    
    EKEvent *e;
    
    if (indexPath.section == 0) {
        e = [self.exams objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        e = [self.quizzes objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        e = [self.homeworks objectAtIndex:indexPath.row];
    } else if (indexPath.section == 3) {
        e = [self.other objectAtIndex:indexPath.row];
    }
    
    if ([e.title containsString:@"-"]) {
        NSRange range = [e.title rangeOfString:@"-"];
        //Convert "MATH 151 - Homework 1" to "Homework 1"
        cell.textLabel.text = [e.title substringWithRange:NSMakeRange(range.location + 2, e.title.length - range.location - 2)];
    }
    else
        cell.textLabel.text = e.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSString *strDate = [dateFormatter stringFromDate:e.endDate];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate2 = [dateFormatter stringFromDate:e.endDate];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Due on %@ at %@", strDate, strDate2];
    
    //NSLog(@"cell.name.text: %@", cell.name.text);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"CalendarEventSegue" sender:nil];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Exams";
    } else if (section == 1) {
        return @"Quizzes";
    } else if (section == 2) {
        return @"Homeworks";
    } else if (section == 3) {
        return @"Other";
    } else {
        return @"";
    }
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
 */


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
 */


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
