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
    Painting *painting;
    UIImage *renderedPainting;
}
@property(nonatomic, retain) UIImage *renderedPainting;

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (void)setEraser;

@end
