//
//  PaintCanvas.h
//  Paint
//
//  Created by Lukas Gianinazzi on 09.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CollectionOfPaths.h"
#import "UIGestureRecognizer+PaintCanvas.h"
/*
@protocol CanvasItem <NSObject>

@end*/

@class PaintCanvas;

@protocol PaintCanvasDatasource <NSObject>
//paths with higher indeces are painted on top
- (int)numberOfPathsForCanvas:(PaintCanvas*)canvas;
- (Path*)pathAtIndex:(int)index forCanvas:(PaintCanvas*)canvas ;

@end


@interface PaintCanvas : UIView

//Paths with 1 point are rendered as circles
//Paths with 2 points are rendered as streight lines
//Paths with more than 2 points are rendered as smooth curves if shouldSmoothenPaths is YES

@property (nonatomic, weak) id <PaintCanvasDatasource> datasource;

//with this set to YES, the points in the paths will be connected by smooth curves, otherwise by streight lines
@property (nonatomic) BOOL shouldSmoothenPaths;


//zoom the canvas
@property (nonatomic) float zoomScale;
//translate the canvas
@property (nonatomic) CGPoint contentOffset;


//converts from view coordinates to canvas coordinates

//canvas coordinates are relative to the picture presented
//view coordinates are relative to the frame of the view (this disregards zoomScale and contentOffset)
//changing the contentOffset will change the canvas coordinates, but not the view coordinates

- (CGPoint)fromViewToCanvas:(CGPoint)point;

@end
