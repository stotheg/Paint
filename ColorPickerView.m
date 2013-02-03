//
//  ColorPickerView.m
//  Paint
//
//  Created by Lukas Gianinazzi on 18.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "ColorPickerView.h"

@implementation ColorPickerView

const CGFloat color_components[28] =
{
    1, 0, 0, 1,// red
    1, 0, 1, 1, //purple
    0, 0, 1, 1, //blue
    0, 1, 1, 1, //cyan
    0, 1, 0, 1, //green
    1, 1, 0, 1, //yellow
    1, 1, 1, 1 //white
};

const CGFloat color_locations[7] = { 0, 0.25, 0.45, 0.6, 0.75, 0.85, 1.0};

const CGFloat black_transparent_components[8] =
{
    0, 0, 0, 0,
    0, 0, 0, 1
    
};

const CGFloat black_transparent_locations[2] = {0.2, 1};


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


//Attribution: Code was modified from http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics?answertab=active#tab-top
- (UIColor *)colorAtLocation:(CGPoint)location
{
    CGFloat red = 0;
    CGFloat blue = 0;
    CGFloat green = 0;
    
    // First get the gradient into the data buffer
    NSUInteger width = self.frame.size.width*self.contentScaleFactor;
    NSUInteger height = self.frame.size.height*self.contentScaleFactor;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    [self drawColorGradientIntoContext:context scaling:self.contentScaleFactor];
    [self drawBlackGradientIntoContext:context scaling:self.contentScaleFactor invert:YES];//note: why do we have to invert?!!?!: probably coordinate systems are opposite!
    
    CGContextRelease(context);
    
    // Now the rawData contains the data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * location.y*self.contentScaleFactor) + location.x*self.contentScaleFactor * bytesPerPixel;
    red   = (rawData[byteIndex]     * 1.0) / 255.0;
    green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    
    free(rawData);
    
    //create and return uicolor
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)drawColorGradientIntoContext:(CGContextRef)context scaling:(float)factor
{
    //initialize gradient properties
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(self.frame.size.width*factor, 0);
    
    //draw color gradient
    size_t num_locations = 7;
    gradient = CGGradientCreateWithColorComponents (colorspace, color_components,
                                                    color_locations, num_locations);
    
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
}

- (void)drawBlackGradientIntoContext:(CGContextRef)context scaling:(float)factor invert:(BOOL)invert
{
    //initialize gradient properties
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    CGPoint startPoint = CGPointMake(0, 0);
    
    //draw color gradient
    size_t num_locations = 7;
    
    //darken (draw black-transparent gradient)
    CGPoint endPoint = CGPointMake(0, self.frame.size.height*factor);
    num_locations = 2;
    gradient = CGGradientCreateWithColorComponents(colorspace, black_transparent_components, black_transparent_locations, num_locations);
    
    if (!invert) {
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    } else {
        CGContextDrawLinearGradient(context, gradient, endPoint, startPoint, 0);
    }
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
}


//convenience default settings
- (void)drawColorGradientIntoContext:(CGContextRef)context
{
    [self drawColorGradientIntoContext:context scaling:1];
}

- (void)drawBlackGradientIntoContext:(CGContextRef)context
{
    [self drawBlackGradientIntoContext:context scaling:1 invert:NO];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawColorGradientIntoContext:context];
    [self drawBlackGradientIntoContext:context];
    
}


@end
