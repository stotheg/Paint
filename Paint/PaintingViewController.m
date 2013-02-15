//
//  PaintingViewController.m
//  Paint
//
//  Created by Lukas Gianinazzi on 11.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "PaintingViewController.h"
#import "ColorPickerView.h"


@interface PaintingViewController()

@end

@implementation PaintingViewController



#pragma mark lifecycle

//the view will appear method is similar to 'run()' in karel
//it gets called for you just before the view is displayed
- (void)viewWillAppear:(BOOL)animated
{
    //call the superclass implementation
    [super viewWillAppear:animated];
    

    //update the view
    [self.canvas setNeedsDisplay];

}


@end
