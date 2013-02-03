//
//  Path.h
//  Paint
//
//  Created by Lukas Gianinazzi on 09.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Path : NSObject


- (void)extendWithPoint:(CGPoint)point;



@property (nonatomic, strong) UIColor * color;

@property (nonatomic) CGFloat width;



@property (readonly) NSUInteger numberOfPoints;

- (CGPoint)pointAtIndex:(NSUInteger)index;

@property (nonatomic) CGPoint lastPoint;

@end
