#import <UIKit/UIKit.h>
#import "Painting.h"

//CONSTANTS:

#define kBrushOpacity		(5.0 / 6.0)
#define kBrushPixelStep		3
#define kBrushSize          64

//CLASS INTERFACES:

@class Painting;

@interface PaintingView : UIView<PaintingDrawer>
{
@private  
    Painting *painting;
    PaintingTool *lastTool;
    UIImage *currentDrawing;
}
@property(nonatomic, retain) Painting *painting;

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (void)setEraser;

@end
