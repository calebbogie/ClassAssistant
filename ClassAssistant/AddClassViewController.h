//
//  AddClassViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "iCarousel.h"

@interface AddClassViewController : UIViewController <UITextFieldDelegate, iCarouselDataSource, iCarouselDelegate>

//iCarousel-specific things
@property (nonatomic, strong) IBOutlet iCarousel *carouselView;
@property NSMutableArray *images;

@property (weak, nonatomic) IBOutlet UITextField *courseNameField;
//@property (weak, nonatomic) IBOutlet UITextField *creditHoursField;
@property (weak, nonatomic) IBOutlet UISlider *creditHoursSlider;
@property (weak, nonatomic) IBOutlet UILabel *creditHoursLabel;
@property (weak, nonatomic) IBOutlet UITextField *professorName;
@property (weak, nonatomic) IBOutlet UITextField *professorEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *professorOfficeLocation;
//@property (weak, nonatomic) IBOutlet UITextField *numberOfExams;
@property (weak, nonatomic) IBOutlet UISlider *numberOfExamsSlider;
@property (weak, nonatomic) IBOutlet UILabel *numberOfExamsLabel;
//@property (weak, nonatomic) IBOutlet UITextField *homeworkWeight;
@property (weak, nonatomic) IBOutlet UISlider *homeworkWeightSlider;
@property (weak, nonatomic) IBOutlet UILabel *homeworkWeightLabel;
//@property (weak, nonatomic) IBOutlet UITextField *quizWeight;
@property (weak, nonatomic) IBOutlet UISlider *quizWeightSlider;
@property (weak, nonatomic) IBOutlet UILabel *quizWeightLabel;
@property (weak, nonatomic) IBOutlet UISlider *otherWeightSlider;
@property (weak, nonatomic) IBOutlet UILabel *otherWeightLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scroller;
//@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
//@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
//@property (weak, nonatomic) IBOutlet UIImageView *courseImage;

@property NSMutableArray *examTitleLabels;
@property NSMutableArray *examWeightTextFields;

@property CGFloat animatedDistance;
@property BOOL editMode;

@property Course* courseToAdd;
@property NSInteger imageNum;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
//- (IBAction)forwardButtonPressed:(id)sender;
//- (IBAction)backwardButtonPressed:(id)sender;
- (IBAction)homeworkWeightSliderChanged:(id)sender;
- (IBAction)quizWeightSliderChanged:(id)sender;
- (IBAction)numberOfExamsSliderChanged:(id)sender;
- (IBAction)creditHoursSliderChanged:(id)sender;

@end
