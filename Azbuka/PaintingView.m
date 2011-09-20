#import "PaintingView.h"
#import "CGGeometry+Utils.h"

@interface PaintingView()
@property(nonatomic, retain) UIImage *currentDrawing;
@end

@implementation PaintingView
@synthesize currentDrawing;
@synthesize painting;
#pragma mark private

-(void)privateInit{
    self.backgroundColor = [UIColor clearColor];
    self.contentScaleFactor = 1.0;    
    [Brush setAlpha:kBrushOpacity];
}


-(void)drawPointAt:(CGPoint)pt on:(CGContextRef)ctx{
    CGRect brushRect = (CGRect){CGPointZero, CGSizeMake(kBrushSize, kBrushSize)};
    brushRect = CGRectCenterToPoint(brushRect, pt);
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, 0);
    CGContextAddEllipseInRect(ctx, brushRect);   
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}

//-(void)drawLineFromPoint:(CGPoint)start to:(CGPoint)end on:(CGContextRef)ctx{
//	int count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
//	for(int i = 0; i < count; ++i) {
//        CGPoint pt = CGPointMake(
//                                 start.x + (end.x - start.x) * ((CGFloat)i / (CGFloat)count),
//                                 start.y + (end.y - start.y) * ((CGFloat)i / (CGFloat)count)
//                                 );
//        [self drawPointAt:pt on:ctx];
//	}
//}

-(void)drawLineFromPoint:(CGPoint)start to:(CGPoint)end on:(CGContextRef)ctx{
    CGContextAddLineToPoint(ctx, end.x, end.y);
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
        [self privateInit];
	}
	return self;
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self privateInit];
    }    
    return self;
}


- (void) dealloc
{
    [lastTool release];
    [currentDrawing release];
    [painting release];
	[super dealloc];
}

#pragma mark accessing

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    [lastTool release];
    lastTool = [[Brush alloc] initWithRed:red green:green blue:blue];
    [painting setTool:lastTool];
}

-(void)setEraser{
    [lastTool release];
    lastTool = [Eraser new];
    [painting setTool:lastTool];    
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
        [painting setTool:lastTool];
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
-(void)painting:(Painting *)_painting wantsToBeginDrawingAtPoint:(CGPoint)pt{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextMoveToPoint(ctx, pt.x, CGRectGetHeight(self.bounds) - pt.y);
}

-(void)painting:(Painting *)_painting wantsToUseBrush:(Brush*)brush{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    CGContextSetLineWidth(ctx, kBrushSize);
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    CGContextSetStrokeColorWithColor(ctx, brush.CGColor);
    CGContextSetFillColorWithColor(ctx, brush.CGColor);    
}

-(void)painting:(Painting *)_painting wantsToUseEraser:(Eraser*)eraser{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    CGContextSetLineWidth(ctx, kBrushSize * 2);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
}

-(void)paintingWantsToEndDrawing:(Painting *)_painting{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    CGContextStrokePath(ctx);
//    CGContextFillPath(ctx);
}


-(void)painting:(Painting*)_painting wantsToDrawPoint:(CGPoint)pt{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    pt.y = CGRectGetHeight(self.bounds) - pt.y;
    [self drawPointAt:pt on:ctx];
}

-(void)painting:(Painting*)_painting wantsToDrawLineFrom:(CGPoint)start to:(CGPoint)end{
    CGContextRef ctx = (CGContextRef)_painting.userInfo;
    start.y = CGRectGetHeight(self.bounds) - start.y;
    end.y = CGRectGetHeight(self.bounds) - end.y;
    [self drawLineFromPoint:start to:end on:ctx];
}

@end
