//
//  CollectionOfPaths.h
//  Paint
//
//  Created by Lukas Gianinazzi on 11.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Path.h"


@interface CollectionOfPaths : NSObject
//paths are stored in the order they are added
//


//create an empty collection of paths
+ (CollectionOfPaths*)collectionOfPaths;

#pragma mark path creation

//adds a new path on top of the old paths
//the new path will be returned by lastPath, count will be increased by 1
- (void)startPathAtPoint:(CGPoint)startPoint color:(UIColor *)color width:(CGFloat)width;

//add a new point to the last path
//does not change the number of paths
- (void)extendLastPathWithPoint:(CGPoint)newPoint;

//add a new point to the last path
//does not change the number of paths
- (void)extendLastPathByMovingX:(float)x movingY:(float)y;


#pragma mark removing paths

//removes the topmost path
//reduces count by 1
//if count will be greater than 0, then lastPath will be the path underneath lastPath
//if count will be 0, lastPath will be nil
- (void)removeLastPath;

#pragma mark access

//the path at this index
//the index must be valid: if your index is too large or negative, there is an exception
- (Path*)pathAtIndex:(int)index;

//the last path (path with the highest index)
//if there are no paths, this is nil
- (Path*)lastPath;


//the number of paths in the collection
- (int)count;

@end
