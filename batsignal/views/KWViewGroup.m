//
//  KWViewGroup.m
//  batsignal
//
//  Created by Kyle Warren on 5/3/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "KWViewGroup.h"

@implementation KWViewGroup

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

@end
