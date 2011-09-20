#import "Painting.h"

@interface Painting()
@property(nonatomic, retain, readwrite)Brush *lastBrush;
@end

// commands
@interface PaintingCommand : NSObject{
}
@end

@interface BrushCommand : PaintingCommand{
    Brush *brush;
}
@property(nonatomic, readonly) Brush* brush;
@end

@interface PointCommand : PaintingCommand{
    CGPoint pt;
}
@property(nonatomic, readonly) CGPoint pt;
@end

@interface EndLineCommand : PaintingCommand{
}
@end

////////////////////////////////////////////////

// brush implementation
static CGFloat brushAlpha = 0.5f;

@implementation Brush
+(void)setAlpha:(CGFloat)alpha{
    brushAlpha = alpha;
}

- (id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    self = [super init];
    if (self) {
        r = red;
        g = green;
        b = blue;
    }
    return self;
}

+(Brush*)brushWithRed:(CGFloat) red green:(CGFloat)green blue:(CGFloat)blue{
    return [[[self alloc] initWithRed:red green:green blue:blue] autorelease];
}

-(CGColorRef)CGColor{
    return [UIColor colorWithRed:r green:g blue:b alpha:brushAlpha].CGColor;
}

@end

// commands implementation
////////////////////////////////////////////////
@implementation PaintingCommand

@end


////////////////////////////////////////////////
@implementation BrushCommand
@synthesize brush;

- (id)initWithBrush:(Brush*)_brush {
    self = [super init];
    if (self) {
        brush = [_brush retain];
    }
    return self;
}

- (void)dealloc {
    [brush release];
    [super dealloc];
}

+(BrushCommand*)brushCommandWith:(Brush*)brush{
    return [[[self alloc] initWithBrush:brush] autorelease];  
}

@end

////////////////////////////////////////////////
@implementation PointCommand
@synthesize pt;

- (id)initWithPoint:(CGPoint)_pt {
    self = [super init];
    if (self) {
        pt = _pt;
    }
    return self;
}

+(PointCommand*)pointCommandWith:(CGPoint)pt{
    return [[[self alloc] initWithPoint:pt] autorelease];
}

@end

////////////////////////////////////////////////
@implementation EndLineCommand

+(EndLineCommand*)endLine{
    return [[self new] autorelease];
}

@end

////////////////////////////////////////////////

@implementation Painting
@synthesize lastBrush;
@synthesize userInfo;

#pragma mark private

-(void)pushCommand:(PaintingCommand*)command{
    [commands addObject:command];
}

-(void)drawFrom:(int)index on:(id<PaintingDrawer>)drawer{
    BOOL wasBegun = NO;
    BOOL wasEnded = NO;
    BOOL pointsAdded = NO;
    
    for(int i = index; i < commands.count; i++){
        wasEnded = NO;
        PaintingCommand *command = [commands objectAtIndex:i];
        if([command isKindOfClass:[BrushCommand class]]){
            BrushCommand* brushCommand = (BrushCommand*)command;
            self.lastBrush = brushCommand.brush;
        }else if([command isKindOfClass:[PointCommand class]]){
            PointCommand *pointCommand = (PointCommand*)command;
            if(lastPointSet){
                if(!wasBegun){
                    if([drawer respondsToSelector:@selector(paintingWantsToBeginDrawing:)]) [drawer paintingWantsToBeginDrawing:self];
                    wasBegun = YES;
                }
                [drawer painting:self wantsToDrawLineFrom:lastPoint to:pointCommand.pt];
            }            
            lastPoint = pointCommand.pt;
            lastPointSet = YES;
            pointsAdded = YES;
        }else if([command isKindOfClass:[EndLineCommand class]]){
            if(pointsAdded && !wasBegun){
                if([drawer respondsToSelector:@selector(paintingWantsToBeginDrawing:)]) [drawer paintingWantsToBeginDrawing:self];
                wasBegun = YES;
                [drawer painting:self wantsToDrawPoint:lastPoint];
            }
            if([drawer respondsToSelector:@selector(paintingWantsToEndLine:)]) [drawer paintingWantsToEndDrawing:self];
            lastPoint = CGPointZero;
            lastPointSet = NO;
            wasEnded = YES;
        }
    }
    if(pointsAdded && !wasBegun){
        if([drawer respondsToSelector:@selector(paintingWantsToBeginDrawing:)]) [drawer paintingWantsToBeginDrawing:self];
        wasBegun = YES;
        [drawer painting:self wantsToDrawPoint:lastPoint];
    }
    if(wasBegun && !wasEnded){
        [drawer paintingWantsToEndDrawing:self];
    }
}

#pragma mark lifecycle

- (id)init {
    self = [super init];
    if (self) {
        commands = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    [lastBrush release];
    [commands release];
    [super dealloc];
}

#pragma mark accessing

-(void)setBrush:(Brush*)brush{
    [self pushCommand:[BrushCommand brushCommandWith:brush]];
}

-(void)addPoint:(CGPoint)pt{
    [self pushCommand:[PointCommand pointCommandWith:pt]];
}
-(void)endLine{
    [self pushCommand:[EndLineCommand endLine]];
}

-(void)flushOn:(id<PaintingDrawer>)drawer{
    [self drawFrom:lastCommandIndex on:drawer];
    lastCommandIndex = commands.count;
}

-(void)drawOn:(id<PaintingDrawer>)drawer{
    [self drawFrom:0 on:drawer];
}


@end
