//
//  CustomTextFieldForCell.m
//  SimpleConverter
//
//  Created by Stanislav on 10.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "CustomTextFieldForCell.h"

@implementation CustomTextFieldForCell

- (UITextPosition *)closestPositionToPoint:(CGPoint)point{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *end = [self positionFromPosition:beginning offset:self.text.length];
    return end;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

@end
