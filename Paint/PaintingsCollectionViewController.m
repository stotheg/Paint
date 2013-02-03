//
//  PaintingsCollectionViewController.m
//  Paint
//
//  Created by Lukas Gianinazzi on 12.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "PaintingsCollectionViewController.h"

@interface PaintingsCollectionViewController ()

@end

@implementation PaintingsCollectionViewController


- (int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
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
