//
//  GradeIndicatorView.m
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/5/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import "GradeIndicatorView.h"
#import <UIKit/UIKit.h>

@implementation GradeIndicatorView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGFloat radius = (CGFloat)fmax(self.bounds.size.width, self.bounds.size.height);
    
    CGFloat arcWidth = 15;
    
    //_grade = 75;
    
    CGFloat startAngle = (CGFloat)(3*M_PI/2);
    CGFloat endAngle = (CGFloat)(M_PI);
    
    UIBezierPath *pathOne = [UIBezierPath bezierPathWithArcCenter:center radius:radius/2 - arcWidth/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    UIBezierPath *pathTwo = [UIBezierPath bezierPathWithArcCenter:center radius:radius/2 - arcWidth/2 startAngle:endAngle endAngle:startAngle clockwise:YES];

    
    pathOne.lineWidth = arcWidth;
    pathTwo.lineWidth = arcWidth;
    [[UIColor whiteColor] setStroke];
    [pathOne stroke];
    [pathTwo stroke];
    
    //CGFloat angleDifference = (CGFloat)(2*M_PI - (startAngle - endAngle) / 2);
    
    //Each point is 1/100 of the total length (which is 2*PI)
    CGFloat arcLengthPerNum = 2*M_PI / (CGFloat)(100);
    
    CGFloat outlineEndAngle = arcLengthPerNum * (CGFloat)(_grade) + startAngle;
    
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width/2 - 2.5 startAngle:startAngle endAngle:outlineEndAngle clockwise:YES];

    [outlinePath addArcWithCenter:center radius:self.bounds.size.width/2 - arcWidth + 2.5 startAngle:outlineEndAngle endAngle:startAngle clockwise:NO];
    
    [outlinePath closePath];
    
    [[UIColor blueColor] setFill];
    
    [outlinePath fill];
    
    [[UIColor blueColor] setStroke];
    outlinePath.lineWidth = 3.0;
    [outlinePath stroke];
}


@end
