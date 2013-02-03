//
//  PaintingViewController.m
//  Paint
//
//  Created by Lukas Gianinazzi on 11.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "PaintingViewController.h"
#import "ColorPickerView.h"

@interface PaintingViewController ()



@end


@implementation PaintingViewController


- (void)addSquareWithWidth:(float)width height:(float)height color:(UIColor*)color startPoint:(CGPoint)bottomLeft
{
    
    [self.paths startPathAtPoint:bottomLeft color:color width:2];
    [self.paths extendLastPathByMovingX:width movingY:0];
    [self.paths extendLastPathByMovingX:0 movingY:-height];
    [self.paths extendLastPathByMovingX:-width movingY:0];
    [self.paths extendLastPathByMovingX:0 movingY:height];
    
}


- (void)addRowOfBricks:(int)numberOfBricks widthOfBricks:(float)brickWidth heightOfBricks:(float)brickHeight color:(UIColor*)color startPoint:(CGPoint)startPoint
{
    CGPoint squareOrigin = startPoint;
    
    for (int i = 0; i < numberOfBricks; i++) {
        
        [self addSquareWithWidth:brickWidth height:brickHeight color:color startPoint:squareOrigin];
        
        squareOrigin.x = squareOrigin.x + brickWidth;
        
    }
    
}


- (void)addPyramidWithNumberOfBricksInBase:(int)numberOfBricks widthOfBricks:(float)brickWidth heightOfBricks:(float)brickHeight color:(UIColor*)color startPoint:(CGPoint)startPoint
{
    CGPoint startPointForRow = startPoint;
    
    for (int i = 0; i < numberOfBricks; i++) {
        
        [self addRowOfBricks:numberOfBricks-i widthOfBricks:brickWidth heightOfBricks:brickHeight color:color startPoint:startPointForRow];
        
        startPointForRow.y = startPointForRow.y - brickHeight;
        startPointForRow.x = startPointForRow.x + brickWidth/2;
        
    }
    
}


#pragma mark lifecycle

//the view will appear method is similar to 'run()' in karel
//it gets called for you just before the view is displayed
- (void)viewWillAppear:(BOOL)animated
{
    //call the superclass implementation
    [super viewWillAppear:animated];
    
    self.canvas.backgroundColor = [UIColor purpleColor];
    
    //custom drawing
    CGPoint startPoint = CGPointMake(38, 290);
    [self addPyramidWithNumberOfBricksInBase:8 widthOfBricks:30 heightOfBricks:10 color:[UIColor blueColor] startPoint:startPoint];
    [self.canvas setNeedsDisplay];

}


@end
