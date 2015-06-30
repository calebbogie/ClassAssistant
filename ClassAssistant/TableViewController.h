//
//  TableTableViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property NSMutableArray* studentCourses;

- (IBAction)backFromAddOrEdit:(UIStoryboardSegue *) segue;
- (IBAction)backToTableViewFromClassView:(UIStoryboardSegue *) segue;

- (void)loadDummyData;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
