//
//  AddItemTabBarController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/14/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface AddItemTabBarController : UITabBarController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property Course *courseToEdit;

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

-(IBAction)addGrade:(id)sender;


@end
