//
//  ClassView.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/18/14.
//  Copyright (c) 2014 Caleb Bogenschutz. All rights reserved.
//

#import "ClassViewSegue.h"

@implementation ClassViewSegue

-(void)perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}

@end
