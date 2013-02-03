//
//  UIGestureRecognizer+PaintCanvas.m
//  Paint
//
//  Created by Lukas Gianinazzi on 18.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "UIGestureRecognizer+PaintCanvas.h"

@implementation UIGestureRecognizer (PaintCanvas)

- (CGPoint)locationInCanvas:(PaintCanvas*)canvas
{
    return [canvas fromViewToCanvas:[self locationInView:canvas]];
}

@end
