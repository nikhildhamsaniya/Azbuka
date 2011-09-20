#import <Foundation/Foundation.h>

@interface Brush : NSObject {
    float r, g, b;
}
- (id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(Brush*)brushWithRed:(CGFloat) red green:(CGFloat)green blue:(CGFloat)blue;
+(void)setAlpha:(CGFloat)alpha;

-(CGColorRef)CGColor;
@end

/////////////////////////////////////////////
@class Painting;

@protocol PaintingDrawer<NSObject>
-(void)painting:(Painting*)painting wantsToDrawPoint:(CGPoint)pt;
-(void)painting:(Painting*)painting wantsToDrawLineFrom:(CGPoint)start to:(CGPoint)end;
@optional
-(void)paintingWantsToBeginDrawing:(Painting *)_painting;
-(void)paintingWantsToEndDrawing:(Painting *)_painting;
@end

@interface Painting : NSObject {
    NSMutableArray *commands;
    int lastCommandIndex;
    Brush *lastBrush;
    CGPoint lastPoint;
    BOOL lastPointSet;
    
    void *userInfo;
}
@property(nonatomic, retain, readonly)Brush *lastBrush;
@property(nonatomic, assign) void* userInfo;

// building
-(void)setBrush:(Brush*)brush;
-(void)addPoint:(CGPoint)pt;
-(void)endLine;

// drawing
-(void)flushOn:(id<PaintingDrawer>)drawer;
-(void)drawOn:(id<PaintingDrawer>)drawer;

@end
