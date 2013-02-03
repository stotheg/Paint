//
//  Path.m
//  Paint
//
//  Created by Lukas Gianinazzi on 09.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "Path.h"

@interface Path()
@property (nonatomic, strong) NSMutableArray * points;
@end

@implementation Path

- (NSArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    } return _points;
}


- (NSUInteger)numberOfPoints
{
    return self.points.count;
}

- (CGPoint)pointAtIndex:(NSUInteger)index
{
    return [[self.points objectAtIndex:index] CGPointValue];
}

- (CGPoint)lastPoint
{
    return [self pointAtIndex:self.numberOfPoints-1];
}

- (void)setLastPoint:(CGPoint)lastPoint
{
    [self.points setObject:[NSValue valueWithCGPoint:lastPoint] atIndexedSubscript:self.numberOfPoints-1];
}

- (void)extendWithPoint:(CGPoint)point
{
    NSValue * value = [NSValue valueWithCGPoint:point];
    [self.points addObject:value];
}


- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"count: %d", self.points.count];
    
}
@end
