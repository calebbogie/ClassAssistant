//
//  CalendarEventsTableViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/9/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "CalendarEventsTableViewController.h"
#import "AddCalendarEventViewController.h"

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.matchingEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier;
    
    UITableViewCell *cell;
    
    cellIdentifier = @"CalendarEventsTableViewID";
    
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    EKEvent *e = [self.matchingEvents objectAtIndex:indexPath.row];
    
    if ([e.title containsString:@"-"]) {
        NSRange range = [e.title rangeOfString:@"-"];
        //Convert "MATH 151 - Homework 1" to "Homework 1"
        cell.textLabel.text = [e.title substringWithRange:NSMakeRange(range.location + 2, e.title.length - range.location - 2)];
    }
    else
        cell.textLabel.text = e.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:e.endDate];
    
    cell.detailTextLabel.text = strDate;
    
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
