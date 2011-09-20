#import <UIKit/UIKit.h>

@protocol PaletteViewDelegate
-(void)paletteDidChooseColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
-(void)paletteDidChooseEraser;
@end

@interface PaletteView : UIView {
    UIView *red, *blue, *yellow, *green;
    UIButton *eraser;   
    
    id<PaletteViewDelegate> delegate;
    
    int selectedColorIndex;
}
@property(nonatomic, assign) id<PaletteViewDelegate> delegate;

-(void)updateSelectedColor;

@end
