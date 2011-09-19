#import <Foundation/Foundation.h>

@interface Brush : NSObject {
    float r, g, b;
}
+(Brush*)brushWithRed:(CGFloat) red green:(CGFloat)green blue:(CGFloat)blue;
+(void)setAlpha:(CGFloat)alpha;

-(CGColorRef)CGColor;
@end

/////////////////////////////////////////////
@class Painting;

@protocol PaintingDrawer<NSObject>
-(void)painting:(Painting*)painting wantsToDrawPoint:(CGPoint)pt;
-(void)painting:(Painting*)painting wantsToDrawLineFrom:(CGPoint)start to:(CGPoint)end;
@end

@interface Painting : NSObject {
    NSMutableArray *commands;
    int lastCommandIndex;
    Brush *lastBrush;
    CGPoint lastPoint;
    BOOL lastPointSet;
}
@property(nonatomic, retain, readonly)Brush *lastBrush;

// building
-(void)setBrush:(Brush*)brush;
-(void)addPoint:(CGPoint)pt;
-(void)endLine;

// drawing
-(void)flushOn:(id<PaintingDrawer>)drawer;
-(void)drawOn:(id<PaintingDrawer>)drawer;

@end
