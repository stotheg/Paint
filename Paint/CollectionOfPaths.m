//
//  CollectionOfPaths.m
//  Paint
//
//  Created by Lukas Gianinazzi on 11.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "CollectionOfPaths.h"
#include "CGPoint+Operator.h"
@interface CollectionOfPaths()

@property (nonatomic, strong) NSMutableArray * paths;

@end




@implementation CollectionOfPaths

- (NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    } return _paths;
}


+ (CollectionOfPaths*)collectionOfPaths
{
    CollectionOfPaths * collection = [[CollectionOfPaths alloc] init];
    return collection;
}

- (void)startPathAtPoint:(CGPoint)startPoint color:(UIColor *)color width:(CGFloat)width
{
    Path * path = [[Path alloc] init];
    path.color = color;
    path.width = width;
    [path extendWithPoint:startPoint];
    [self.paths addObject:path];
}

- (void)extendLastPathByMovingX:(float)x movingY:(float)y
{
    CGPoint relativePoint = [[self lastPath] lastPoint];
    [self extendLastPathWithPoint:CGPointMake(relativePoint.x+x, relativePoint.y+y)];
}

- (void)extendLastPathWithPoint:(CGPoint)newPoint
{
    [[self lastPath] extendWithPoint:newPoint];
}

- (void)removeLastPath
{
    [self.paths removeLastObject];
}


- (Path*)lastPath
{
    return self.paths.lastObject;
}

- (Path*)pathAtIndex:(int)index
{
    return [self.paths objectAtIndex:index];
}

- (int)count
{
    return self.paths.count;
}

@end
