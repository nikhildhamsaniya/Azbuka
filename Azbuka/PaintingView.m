#import "PaintingView.h"
#import "CGGeometry+Utils.h"


@interface PaintingView()
@property(nonatomic, retain) UIImage *currentDrawing;
@property(nonatomic, retain) UIColor *curColor;
@end

@implementation PaintingView
@synthesize currentDrawing;
@synthesize curColor;
@synthesize data;
#pragma mark private

-(BOOL)privateInit{
    self.backgroundColor = [UIColor clearColor];
    brush = [[UIImage imageNamed:@"Particle.png"] retain];
    self.contentScaleFactor = 1.0;
    
    return YES;
}


-(void)drawPointAt:(CGPoint)pt on:(CGContextRef)ctx{
    pt.y = CGRectGetHeight(self.bounds) - pt.y;
    CGRect brushRect = (CGRect){CGPointZero, CGSizeMake(64, 64)};
    brushRect = CGRectCenterToPoint(brushRect, pt);
    CGContextAddEllipseInRect(ctx, brushRect);    
}

-(void)drawLineFromPoint:(CGPoint)start to:(CGPoint)end on:(CGContextRef)ctx{
	int count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
	for(int i = 0; i < count; ++i) {
        CGPoint pt = CGPointMake(
                                 start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count),
                                 start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count)
                                 );
        [self drawPointAt:pt on:ctx];
	}
    
}

-(void)updateDrawingWithPoints:(NSArray*)pts{
    if(pts.count == 0)return;
    
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, curColor.CGColor);

    if(currentDrawing)[currentDrawing drawInRect:(CGRect){CGPointZero, currentDrawing.size}];
    
    if (pts.count == 1) {
        [self drawPointAt: ((NSValue*)[pts objectAtIndex:0]).CGPointValue on:ctx];
    }else{
        NSValue *lastPointValue = nil;
        for (NSValue* pointValue in pts) {
            if(lastPointValue){
                CGPoint last = lastPointValue.CGPointValue;
                CGPoint cur = pointValue.CGPointValue;
                [self drawLineFromPoint:last to:cur on:ctx];
            }
            lastPointValue = pointValue;        
        }        
    }
    
    
    CGContextFillPath(ctx);
    CGContextFlush(ctx);
    self.currentDrawing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)updateDrawingWithPoint:(CGPoint)pt{
    [self updateDrawingWithPoints:[NSArray arrayWithObject:[NSValue valueWithCGPoint:pt]]];
}


// Drawings a line onscreen based on where the user touches
//- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end in:(CGContextRef)ctx
//{	
//	// Convert locations from Points to Pixels
//	CGFloat scale = self.contentScaleFactor;
//	start.x *= scale;
//	start.y *= scale;
//	end.x *= scale;
//	end.y *= scale;
//	
//	
//	// Add points to the buffer so there are drawing points every X pixels
//	int count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
//	for(int i = 0; i < count; ++i) {
//		CGFloat x = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
//		CGFloat y = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
//        CGRect imageRect = (CGRect){CGPointZero, CGSizeScale(brush.size, kBrushScale)};
//        imageRect = CGRectCenterToPoint(imageRect, CGPointMake(x, y));
//        CGContextDrawImage(ctx, imageRect, brush.CGImage);
//	}
//	
//}

#pragma mark properties

-(void)setData:(NSMutableArray *)_data{
    [data release];
    data = [_data mutableCopy];
    
    self.currentDrawing = nil;
    for (NSArray *curLine in data) {
        [self updateDrawingWithPoints:curLine];
    }
    
    [self setNeedsDisplay];
}

#pragma mark lifecycle

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        if(![self privateInit]){
            [self release];
            self = nil;
        }
	}
	return self;
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        if(![self privateInit]){
            [self release];
            self = nil;
        }
    }
    
    return self;
}


- (void) dealloc
{
    [curColor release];
    [currentDrawing release];
    [data release];
    [brush release];
	[super dealloc];
}

#pragma mark actions

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    self.curColor = [UIColor colorWithRed:red green:green blue:blue alpha:kBrushOpacity];
}

#pragma mark UIView

-(void)drawRect:(CGRect)rect{
    CGRect imageRect = (CGRect){CGPointZero, currentDrawing.size};
    CGContextDrawImage(UIGraphicsGetCurrentContext(), imageRect, currentDrawing.CGImage);
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    for (NSArray* curLine in data) {
//        for (NSValue* pointValue in curLine) {
//            CGPoint cur = [pointValue CGPointValue];
//            CGRect imageRect = (CGRect){CGPointZero, CGSizeScale(brush.size, kBrushScale)};
//            imageRect = CGRectCenterToPoint(imageRect, cur);
//            CGContextDrawImage(ctx, imageRect, brush.CGImage);
//        }
//    }
}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*	touch = [[event touchesForView:self] anyObject];
	CGPoint location = [touch locationInView:self];
    
    if(!data) data = [NSMutableArray new];
    [data insertObject:[NSMutableArray array] atIndex:0];
    [[data objectAtIndex:0] addObject:[NSValue valueWithCGPoint:location]];
    [self updateDrawingWithPoint:location];
    [self setNeedsDisplay];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{      
	UITouch*			touch = [[event touchesForView:self] anyObject];
	CGPoint cur = [touch locationInView:self];
    CGPoint last = [((NSValue*)[[data objectAtIndex:0] lastObject]) CGPointValue];
    
    [[data objectAtIndex:0] addObject:[NSValue valueWithCGPoint:cur]];
    [self updateDrawingWithPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:last], [NSValue valueWithCGPoint:cur], nil]];
    [self setNeedsDisplay];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*			touch = [[event touchesForView:self] anyObject];
	CGPoint cur = [touch locationInView:self];
    CGPoint last = [((NSValue*)[[data objectAtIndex:0] lastObject]) CGPointValue];
    
    [[data objectAtIndex:0] addObject:[NSValue valueWithCGPoint:cur]];
    [self updateDrawingWithPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:last], [NSValue valueWithCGPoint:cur], nil]];
    [self setNeedsDisplay];
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}


@end
