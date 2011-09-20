#import <UIKit/UIKit.h>
#import "Painting.h"

//CONSTANTS:

#define kBrushOpacity		(1.0 / 2.0)
#define kBrushPixelStep		3
#define kBrushScale			2
#define kLuminosity			0.75
#define kSaturation			1.0

//CLASS INTERFACES:

@class Painting;

@interface PaintingView : UIView<PaintingDrawer>
{
@private  
    Painting *painting;
    Brush *lastBrush;
    UIImage *currentDrawing;
}
@property(nonatomic, retain) Painting *painting;

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
