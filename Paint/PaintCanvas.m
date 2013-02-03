//
//  PaintCanvas.m
//  Paint
//
//  Created by Lukas Gianinazzi on 09.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "PaintCanvas.h"
#import "Path.h"

#define MAXIMUM_PATH_LENGTH 30
#define DEFAULT_PATH_WIDTH 2
#define DEFAULT_CIRCLE_DIAMETER 40

#define MAX_TRANSLATION 140
@interface PaintCanvas()

@property (nonatomic, strong) NSMutableArray * lineSegments;

@property (nonatomic) CGLayerRef renderedLayer;

@property (nonatomic) int numberOfRenderedPaths;

@property (nonatomic) CGAffineTransform currentTransformation;

@property (nonatomic) CGSize contentSize;

@end


@implementation PaintCanvas

- (NSMutableArray *)lineSegments
{
    if (!_lineSegments) {
        _lineSegments = [NSMutableArray array];
    } return _lineSegments;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfRenderedPaths = 0;
        self.contentSize = CGSizeMake(self.frame.size.width*self.contentScaleFactor, self.frame.size.height*self.contentScaleFactor);
        self.contentOffset = CGPointZero;
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.numberOfRenderedPaths = 0;
    self.contentOffset = CGPointZero;
}

- (void)setZoomScale:(float)zoomScale
{
    if (zoomScale != _zoomScale) {
        _zoomScale = zoomScale;
        [self setNeedsDisplay];
    }
}


- (void)setContentOffset:(CGPoint)contentOffset
{
    //CGPoint inCanvas = [self fromViewToCanvas:contentOffset];
    if (contentOffset.x != _contentOffset.x || contentOffset.y != _contentOffset.y) {
        if (contentOffset.x > MAX_TRANSLATION) {
            contentOffset.x = MAX_TRANSLATION;
        } else if (contentOffset.x < -self.contentSize.width/self.contentScaleFactor-MAX_TRANSLATION) {
            contentOffset.x = -self.contentSize.width/self.contentScaleFactor-MAX_TRANSLATION;
        }
        _contentOffset = contentOffset;
        [self setNeedsDisplay];
    }
}

#pragma mark drawing

- (CGPoint)pointBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    return CGPointMake(0.5*(p1.x+p2.x), 0.5*(p1.y+p2.y));
}

//precondition: path.numberOfPoints > 0
- (void)addLinesFromPath:(Path*)path toContext:(CGContextRef)context
{
    CGContextMoveToPoint(context, [path pointAtIndex:0].x, [path pointAtIndex:0].y);
    
    for (int i=1; i < path.numberOfPoints; i++) {
        CGContextAddLineToPoint(context, [path pointAtIndex:i].x, [path pointAtIndex:i].y);
    }
}

- (void)addSmoothCurveFromPath:(Path*)path toContext:(CGContextRef)context
{
    //construct a smooth path using quaratic bezier curves
    
    //algorithm:
    //we calculate the midpoints and use them as start and endpoint for the quad curves
    //the original points are used as control points
    
    //CGContextBeginPath(context);
    
    CGPoint mid;
    CGPoint old;
    mid = [self pointBetweenPoint:[path pointAtIndex:0] andPoint:[path pointAtIndex:1]];
    CGContextMoveToPoint(context, mid.x, mid.y);
    //CGContextAddLineToPoint(context, mid.x, mid.y);
    for (int i = 1; i < [path numberOfPoints]-1; i++) {
        old = mid;
        
        mid = [self pointBetweenPoint:[path pointAtIndex:i] andPoint:[path pointAtIndex:i+1]];
        float eps = 0.2;
        if ([self distanceBetweenPoint:old andPoint:mid] > eps) {
            CGContextAddQuadCurveToPoint(context, [path pointAtIndex:i].x, [path pointAtIndex:i].y, mid.x, mid.y);
        }
        
    }
    /*
     if (path.numberOfPoints >= MAXIMUM_PATH_LENGTH) {
     CGContextAddLineToPoint(context, [path pointAtIndex:path.numberOfPoints-1].x, [path pointAtIndex:path.numberOfPoints-1].y);
     }*/
}

- (void)strokePath:(Path*)path inContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, path.width);
    //CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, path.color.CGColor);
    CGContextStrokePath(context);
}


- (void)renderCircleWithColor:(UIColor *)color diameter:(float) width center:(CGPoint)center toContext:(CGContextRef)context
{
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect bounds = CGRectMake(center.x-width/2, center.y-width/2, width, width);
    CGContextAddEllipseInRect(context, bounds);
    CGContextFillEllipseInRect(context, bounds);
}

- (void)renderPath:(Path*)path intoContext:(CGContextRef)context
{
    
    if (path.numberOfPoints > 2) {
        if (self.shouldSmoothenPaths) {
            [self addSmoothCurveFromPath:path toContext:context];
        } else {
            [self addLinesFromPath:path toContext:context];
        }
    
    } else if (path.numberOfPoints > 1) {
        //construct path: create a line
        [self addLinesFromPath:path toContext:context];
        
    }
    
    if (path.numberOfPoints == 1) {
        //create and fill a circle
        [self renderCircleWithColor:path.color diameter:path.width center:path.lastPoint toContext:context];
    } else {
        //stroke the path
        [self strokePath:path inContext:context];
    }
}





- (float)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    return sqrtf(powf((p1.x-p2.x), 2) + powf((p1.y-p2.y), 2));
}


- (void)renderPrerenderedLayerInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextScaleCTM(context, self.zoomScale/(self.contentScaleFactor), self.zoomScale/(self.contentScaleFactor));//notice that scaling needs to be applied for retina devices
    CGContextDrawLayerAtPoint(context, CGPointZero, self.renderedLayer);
    CGContextRestoreGState(context);
}

- (void)dealloc
{
    CGLayerRelease(self.renderedLayer);
}

- (void)initRenderedLayerWithContext:(CGContextRef)context
{
    //notice that scaling needs to be applied for retina devices
    //create layer
    //get context
    CGContextRef layerContext;
    self.contentSize = CGSizeMake(self.frame.size.width*self.contentScaleFactor, self.frame.size.height*self.contentScaleFactor);
    self.renderedLayer = CGLayerCreateWithContext(context, self.contentSize, NULL);
    layerContext = CGLayerGetContext(self.renderedLayer);
    CGContextScaleCTM(layerContext, self.contentScaleFactor, self.contentScaleFactor);
}

- (void)renderPathsInContext:(CGContextRef)context
{
    int count = [self.datasource numberOfPathsForCanvas:self];
    
    if (self.numberOfRenderedPaths >= count) {
        self.numberOfRenderedPaths = 0;
        CGLayerRelease(self.renderedLayer);
        [self initRenderedLayerWithContext:context];
    } else if (self.numberOfRenderedPaths == 0 && count> 1) {
        CGLayerRelease(self.renderedLayer);
        [self initRenderedLayerWithContext:context];
    }
    
    //if necessary render previous paths to the rendereLayer
    if ([self.datasource numberOfPathsForCanvas:self]-1 > self.numberOfRenderedPaths) {
        CGContextRef layerContext = CGLayerGetContext(self.renderedLayer);
        CGContextSaveGState(layerContext);
        //CGContextScaleCTM(layerContext, self.zoomScale, self.zoomScale);
        //render inactive paths into layer to reuse
        for (int i = self.numberOfRenderedPaths; i < count-1; i++) {
            
            Path * path = [self.datasource pathAtIndex:i forCanvas:self];
            [self renderPath:path intoContext:layerContext];
            
        }
        CGContextRestoreGState(layerContext);
        
        self.numberOfRenderedPaths = count-1;
    }
    
    //render the inactive paths from self.renderedLayer
    
    
    [self renderPrerenderedLayerInContext:context];
    
    
    CGContextScaleCTM(context, self.zoomScale, self.zoomScale);
    //render the active path
    if (count > 0) {
        Path * path = [self.datasource pathAtIndex:count-1 forCanvas:self];
        [self renderPath:path intoContext:context];
    }

}

- (CGPoint)fromViewToCanvas:(CGPoint)point
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-self.contentOffset.x, -self.contentOffset.y);
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(1/self.zoomScale, 1/self.zoomScale));
    CGPoint result = CGPointApplyAffineTransform(point, transform);
    return result;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, self.contentOffset.x, self.contentOffset.y);
    //self.currentTransformation = CGContextGetCTM(context);
    //clear
    [self.backgroundColor setFill];
    CGContextFillRect(context, rect);
    
    [self renderPathsInContext:context];
    
    CGContextRestoreGState(context);
    
    
}


@end
