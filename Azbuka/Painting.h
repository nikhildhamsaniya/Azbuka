#import <Foundation/Foundation.h>

@class SoundEffect;

@class Painting;
@class Brush;
@class Eraser;

@protocol PaintingDrawer<NSObject>
-(void)painting:(Painting*)painting wantsToDrawPoint:(CGPoint)pt;
-(void)painting:(Painting*)painting wantsToDrawLineFrom:(CGPoint)start to:(CGPoint)end;
-(void)painting:(Painting *)_painting wantsToUseBrush:(Brush*)brush;
-(void)painting:(Painting *)_painting wantsToUseEraser:(Eraser*)eraser;

@optional
-(void)painting:(Painting *)_painting wantsToBeginDrawingAtPoint:(CGPoint)pt;
-(void)paintingWantsToEndDrawing:(Painting *)_painting;
@end

/////////////////////////////////////////////

@interface PaintingTool : NSObject
-(void)setInPainting:(Painting*)painting;
-(void)configureDrawer:(id<PaintingDrawer>)drawer forPainting:(Painting*)painting;
@property(nonatomic, readonly) SoundEffect* soundEffect;
@end

@interface Eraser : PaintingTool
+(Eraser*)eraser;
@end

@interface Brush : PaintingTool {
    float r, g, b;
}
- (id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(Brush*)brushWithRed:(CGFloat) red green:(CGFloat)green blue:(CGFloat)blue;
+(void)setAlpha:(CGFloat)alpha;

-(CGColorRef)CGColor;
@end

/////////////////////////////////////////////

@interface Painting : NSObject {
    NSMutableArray *commands;
    int lastCommandIndex;
    PaintingTool *lastTool;
    CGPoint lastPoint;
    BOOL lastPointSet;
    
    void *userInfo;
}
@property(nonatomic, retain, readonly)PaintingTool *lastTool;;
@property(nonatomic, assign) void* userInfo;

// constructing
-(void)setTool:(PaintingTool*)tool;
-(void)setBrush:(Brush*)brush;
-(void)setEraser:(Eraser*)eraser;
-(void)addPoint:(CGPoint)pt;
-(void)endLine;

// drawing
-(void)configureToolIn:(id<PaintingDrawer>)drawer;
-(void)flushOn:(id<PaintingDrawer>)drawer;
-(void)drawOn:(id<PaintingDrawer>)drawer;

@end
