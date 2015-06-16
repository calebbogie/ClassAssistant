//
//  CustomTableCell.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/16/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *grade;
@property (nonatomic, weak) IBOutlet UIImageView *courseImage;

@end
