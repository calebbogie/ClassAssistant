//
//  GradeSetupViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/23/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface GradeSetupViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIStepper* examCount;
@property Course* courseToAdd;

@end
