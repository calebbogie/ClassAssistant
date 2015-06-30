//
//  TableTableViewController.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "TableViewController.h"
#import "AddClassViewController.h"
#import "Course.h"
#import "CustomTableCell.h"
#import "ViewClassViewController.h"
#import <Parse/Parse.h>

@interface TableViewController ()


@property NSInteger selectedClassNumber;

@end

@implementation TableViewController

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackground];
    [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
}

- (IBAction)backToTableViewFromClassView:(UIStoryboardSegue *) segue {
    ViewClassViewController *source = [segue sourceViewController];
    
    Course *c = source.classToView;
    
    if (c != nil) {
        
        bool foundCourse = false;
        
        for (int i = 0; i < self.studentCourses.count; i++) {
            Course *temp = [self.studentCourses objectAtIndex:i];
            if ([temp.courseName isEqualToString:c.courseName]) {
                //Course already exists, so replace it
                [self.studentCourses replaceObjectAtIndex:i withObject:c];
                foundCourse = true;
                NSLog(@"Found it!");
                break;
            }
        }
        
        //Course didn't already exist, so add it
        if (!foundCourse) {
            [self.studentCourses addObject:c];
        }
        
        [self.tableView reloadData];
    }
}

- (IBAction)cancelledBackFromAddOrEdit:(UIStoryboardSegue *) segue {
    //Shouldn't do anything
}

- (IBAction)backFromAddOrEdit:(UIStoryboardSegue *) segue {
    
    AddClassViewController *source = [segue sourceViewController];
    
    Course *c = source.courseToAdd;
    
    NSLog(@"BackToTableView Current Grade: %@", c.currentGrade);
    
    if (c != nil) {
        
//        for (int i = 0; i < self.studentCourses.count; i++) {
//            Course *temp = [self.studentCourses objectAtIndex:i];
//            if ([temp.courseName isEqualToString:c.courseName]) {
//                [self.studentCourses replaceObjectAtIndex:i withObject:c];
//            } else {
//                [self.studentCourses addObject:c];
//            }
//        }
        
        bool foundCourse = false;
        
        for (int i = 0; i < self.studentCourses.count; i++) {
            Course *temp = [self.studentCourses objectAtIndex:i];
            if ([temp.courseName isEqualToString:c.courseName]) {
                //Course already exists, so replace it
                [self.studentCourses replaceObjectAtIndex:i withObject:temp];
                foundCourse = true;
                break;
            }
        }
        
        //Course didn't already exist, so add it
        if (!foundCourse) {
            [self.studentCourses addObject:c];
        }
        
        [self.tableView reloadData];
    }
}

- (void)loadDummyData {
    NSLog(@"Loading dummy data...");
    
    //Add course 1
    Course* course1 = [[Course alloc] init];
    course1.courseName = @"MATH 151";
    course1.creditHours = [NSNumber numberWithInt:4];
    course1.currentGrade = @"-";
    [self.studentCourses addObject:course1];
    course1.quizWeight = [NSNumber numberWithDouble:.2];
    course1.homeworkWeight = [NSNumber numberWithDouble:.2];
    course1.numberOfExams = [NSNumber numberWithInt:3];
    [course1.examWeights addObject:[NSNumber numberWithDouble:.2]];
    [course1.examWeights addObject:[NSNumber numberWithDouble:.2]];
    [course1.examWeights addObject:[NSNumber numberWithDouble:.2]];
    course1.professorName = @"Some Professor";
    course1.professorOfficeLocation = @"Some Location";
    
    //Add course 2
    Course* course2 = [[Course alloc] init];
    course2.courseName = @"CHEM 107";
    course2.creditHours = [NSNumber numberWithInt:3];
    course2.currentGrade = @"-";
    [self.studentCourses addObject:course2];
    
    ////////////////////// Retrieving all objects stored in database for user /////////////////////////
    
    //Move this closure to viewDidLoad and add for-loop to retrieve all classes
    /*PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query whereKey:@"User" equalTo:@"Test User"];
    //[query whereKey:@"CourseName" equalTo:@"csce 121"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //NSLog(@"Successfully retrieved: %@", objects);
            
            //NSLog(@"Course name: %@", [[objects objectAtIndex:0] objectForKey:@"CourseName"]);
            
            NSLog(@"Number of courses: %lu", objects.count);
            
            for (int i = 0; i < objects.count; i++) {
                
                Course *courseFromServer = [[Course alloc] init];
            
                courseFromServer.courseName = [NSString stringWithFormat:@"%@", [[objects objectAtIndex:i] objectForKey:@"CourseName"]];
                courseFromServer.creditHours = [NSNumber numberWithInteger:[[[objects objectAtIndex:i] objectForKey:@"CreditHours"] integerValue]];
                courseFromServer.examGrades = [NSMutableArray arrayWithArray:[[objects objectAtIndex:i] objectForKey:@"ExamGrades"]];
                courseFromServer.examWeights = [NSMutableArray arrayWithArray:[[objects objectAtIndex:i] objectForKey:@"ExamWeights"]];
                courseFromServer.homeworkGrades = [NSMutableArray arrayWithArray:[[objects objectAtIndex:i] objectForKey:@"HomeworkGrades"]];
                
                //FLOAT OR DOUBLE??
                courseFromServer.homeworkWeight = [NSNumber numberWithInteger:[[[objects objectAtIndex:i] objectForKey:@"HomeworkWeight"] integerValue]];
                courseFromServer.numberOfExams = [NSNumber numberWithInteger:[[[objects objectAtIndex:i] objectForKey:@"NumberOfExams"] integerValue]];
                courseFromServer.professorEmailAddress = [NSString stringWithFormat:@"%@", [[objects objectAtIndex:i] objectForKey:@"ProfessorEmailAddress"]];
                courseFromServer.professorName = [NSString stringWithFormat:@"%@", [[objects objectAtIndex:i] objectForKey:@"ProfessorName"]];
                courseFromServer.professorOfficeLocation = [NSString stringWithFormat:@"%@", [[objects objectAtIndex:i] objectForKey:@"ProfessorOfficeLocation"]];
                courseFromServer.quizGrades = [NSMutableArray arrayWithArray:[[objects objectAtIndex:i] objectForKey:@"QuizGrades"]];
                
                //FLOAT OR DOUBLE??
                courseFromServer.quizWeight = [NSNumber numberWithInteger:[[[objects objectAtIndex:i] objectForKey:@"QuizWeight"] integerValue]];
            
                NSLog(@"Credit hours: %@", courseFromServer.creditHours);
            
                NSLog(@"%@", [NSString stringWithFormat:@"%@", [[objects objectAtIndex:0] objectForKey:@"CourseName"]]);
            
                courseFromServer.currentGrade = @"-";
            
                [self.studentCourses addObject:courseFromServer];
                [self.tableView reloadData];
            }
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
     */
    
    //Add course 3
    Course* course3 = [[Course alloc] init];
    course3.courseName = @"ENGR 112";
    course3.creditHours = [NSNumber numberWithInt:2];
    course3.currentGrade = @"-";
    [self.studentCourses addObject:course3];
    
    /*PFObject *course = [PFObject objectWithClassName:@"Course"];
    [course setObject:@"Test User" forKey:@"User"];
    [course setObject:course1.courseName forKey:@"CourseName"];
    [course setObject:course1.creditHours forKey:@"CreditHours"];
    [course setObject:course1.numberOfExams forKey:@"NumberOfExams"];
    [course addObjectsFromArray:course1.examWeights forKey:@"ExamWeights"];
    [course addObjectsFromArray:course1.examGrades forKey:@"ExamGrades"];
    
    [course saveInBackground];
     */
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)enteredBackground{
    NSLog(@"Count: %lu", self.studentCourses.count);
    
    for (int i = 0; i < self.studentCourses.count; i++) {
        Course *c = [self.studentCourses objectAtIndex:i];
        PFQuery *query = [PFQuery queryWithClassName:@"Course"];
        [query whereKey:@"User" equalTo:@"Test User"];
        [query whereKey:@"CourseName" equalTo:c.courseName];
        
        //Look for object in database.  If it isn't found, add it.
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object == nil) {
                PFObject *course = [PFObject objectWithClassName:@"Course"];
                [course setObject:c.courseName forKey:@"CourseName"];
                [course setObject:c.creditHours forKey:@"CreditHours"];
                [course setObject:c.examGrades forKey:@"ExamGrades"];
                [course setObject:c.examWeights forKey:@"ExamWeights"];
                [course setObject:c.homeworkGrades forKey:@"HomeworkGrades"];
                [course setObject:c.homeworkWeight forKey:@"HomeworkWeight"];
                [course setObject:c.numberOfExams forKey:@"NumberOfExams"];
                [course setObject:c.professorEmailAddress forKey:@"ProfessorEmailAddress"];
                [course setObject:c.professorName forKey:@"ProfessorName"];
                [course setObject:c.professorName forKey:@"ProfessorOfficeLocation"];
                [course setObject:c.quizGrades forKey:@"QuizGrades"];
                [course setObject:c.quizWeight forKey:@"QuizWeight"];
                [course setObject:@"Test User" forKey:@"User"];
                [course save];
            }
            else {
                NSLog(@"%@ is already there", c.courseName);
            }
        }];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register this class to respond to the applicationDidEnterBackground notification.  This allows data to be saved in this class when app enters background.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground) name:@"didEnterBackground" object:nil];
    
    self.studentCourses = [[NSMutableArray alloc] init];
    
    // ******************* Delete before final build **********************
    [self loadDummyData];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.studentCourses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TableViewPrototype";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Course *course = [_studentCourses objectAtIndex:indexPath.row];
    
    if (!cell) {
        NSLog(@"Cell is nil");
    }
    
    cell.textLabel.text = course.courseName;
    
    cell.imageView.image = [UIImage imageNamed:@"calendar.png"];
    
    NSLog(@"Grade in update: %@", course.currentGrade);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Grade: %@", course.currentGrade];
    //cell.detailTextLabel.text = @"Test";
    
    //NSLog(@"cell.name.text: %@", cell.name.text);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Transition from Table View to Class View
    if([segue.identifier isEqualToString:@"ClassViewSegue"]) {
        
        self.selectedClassNumber = [self.tableView indexPathForSelectedRow].row;
        
        ViewClassViewController *destController = [segue destinationViewController];
        destController.classToView = [self.studentCourses objectAtIndex:_selectedClassNumber];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
