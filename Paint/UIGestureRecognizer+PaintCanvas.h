//
//  UIGestureRecognizer+PaintCanvas.h
//  Paint
//
//  Created by Lukas Gianinazzi on 18.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintCanvas.h"

@class PaintCanvas;

@interface UIGestureRecognizer (PaintCanvas)

- (CGPoint)locationInCanvas:(PaintCanvas*)canvas;

@end
