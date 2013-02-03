//
//  CGPoint+Operator.c
//  Paint
//
//  Created by Lukas Gianinazzi on 11.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#include <stdio.h>
#include <CoreGraphics/CoreGraphics.h>
#include "CGPoint+Operator.h"

CGPoint CGAdd(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x+p2.x, p2.y+p2.y);
}