//
//  PaintableViewController.m
//  Paint
//
//  Created by Lukas Gianinazzi on 19.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "PaintableViewController.h"

@interface PaintableViewController () <PaintCanvasDatasource>

@end

@implementation PaintableViewController

//get the model, if it doesnt exist yet, create it ("lazy instanciation")
- (CollectionOfPaths*)paths
{
    if (!_paths) {//if it is nil
        //create the model and save them in the instance variable
        _paths = [CollectionOfPaths collectionOfPaths];
    } return _paths;
}

- (void)setCanvas:(PaintCanvas *)canvas
{
    if (canvas != _canvas) {
        //store
        _canvas = canvas;
        
        //configure
        canvas.datasource = self;
        canvas.shouldSmoothenPaths = NO;
        canvas.zoomScale = 1;
    }
}


#pragma mark PaintCanvasDatasource


- (int)numberOfPathsForCanvas:(PaintCanvas *)canvas
{
    return [self.paths count];
}


- (Path*)pathAtIndex:(int)index forCanvas:(PaintCanvas *)canvas
{
    return [self.paths pathAtIndex:index];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
