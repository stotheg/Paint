//
//  PaintableViewController.h
//  Paint
//
//  Created by Lukas Gianinazzi on 19.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintCanvas.h"
#import "ColorPickerView.h"
@interface PaintableViewController : UIViewController 


/*  
 
    Usage:
    
    To paint something to the screen:
 
    1. modify the model: call some of the methods of CollectionOfPaths on self.paths
    for example [self.paths startPathAtPoint:startPoint color:red width:30];
 
    2. call [self.canvas setNeedsDisplay] to update the view
 
*/


//view
@property (weak, nonatomic) IBOutlet PaintCanvas * canvas;

@property (weak, nonatomic) IBOutlet UIView * currentColorIndicatorView;

@property (weak, nonatomic) IBOutlet ColorPickerView * colorPickerView;

//model
@property (nonatomic, strong) CollectionOfPaths * paths;


@end