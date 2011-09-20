#import "PaintingView.h"
#import "CGGeometry+Utils.h"


@interface PaintingView()
@property(nonatomic, retain) UIImage *currentDrawing;
@end

@implementation PaintingView
@synthesize currentDrawing;
@synthesize painting;
#pragma mark private

-(BOOL)privateInit{
    self.backgroundColor = [UIColor clearColor];
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
                                 start.x + (end.x - start.x) * ((CGFloat)i / (CGFloat)count),
                                 start.y + (end.y - start.y) * ((CGFloat)i / (CGFloat)count)
                                 );
        [self drawPointAt:pt on:ctx];
	}
}

-(void)updateAndRedisplayFull:(BOOL)isFull{
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if(currentDrawing)[currentDrawing drawInRect:(CGRect){CGPointZero, currentDrawing.size}];
    
    painting.userInfo = ctx;
    if(isFull)[painting drawOn:self];
    else [painting flushOn:self];
    
    CGContextFlush(ctx);
    self.currentDrawing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

#pragma mark properties

-(void)setPainting:(Painting*)_painting{
    [_painting retain];
    [painting release];
    painting = _painting;
    
    self.currentDrawing = nil;
    [self updateAndRedisplayFull:YES];
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
    [lastBrush release];
    [currentDrawing release];
    [painting release];
	[super dealloc];
}

#pragma mark actions

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    [lastBrush release];
    lastBrush = [[Brush alloc] initWithRed:red green:green blue:blue];
    [painting setBrush:lastBrush];
}

#pragma mark UIView

-(void)drawRect:(CGRect)rect{
    CGRect imageRect = (CGRect){CGPointZero, currentDrawing.size};
    CGContextDrawImage(UIGraphicsGetCurrentContext(), imageRect, currentDrawing.CGImage);
}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*	touch = [[event touchesForView:self] anyObject];
	CGPoint point = [touch locationInView:self];
    
    if(!painting){
        painting = [Painting new];
        [painting setBrush:lastBrush];
    }
    [painting addPoint:point];
    [self updateAndRedisplayFull:NO];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{      
	UITouch*			touch = [[event touchesForView:self] anyObject];
	CGPoint point = [touch locationInView:self];
    [painting addPoint:point];
    [self updateAndRedisplayFull:NO];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*			touch = [[event touchesForView:self] anyObject];
	CGPoint point = [touch locationInView:self];
    [painting addPoint:point];
    [painting endLine];
    [self updateAndRedisplayFull:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [painting endLine];
    [self updateAndRedisplayFull:NO];
}

#pragma mark PaintingDrawer
-(void)paintingWantsToBeginDrawing:(Painting *)_painting{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    CGContextSetFillColorWithColor(ctx, painting.lastBrush.CGColor);
}

-(void)paintingWantsToEndDrawing:(Painting *)_painting{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    CGContextFillPath(ctx);    
}


-(void)painting:(Painting*)_painting wantsToDrawPoint:(CGPoint)pt{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    [self drawPointAt:pt on:ctx];
}

-(void)painting:(Painting*)_painting wantsToDrawLineFrom:(CGPoint)start to:(CGPoint)end{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    [self drawLineFromPoint:start to:end on:ctx];
}

@end
