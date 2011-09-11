#import <UIKit/UIKit.h>


@interface PaletteView : UIView {
    UIView *red, *blue, *yellow, *green;
    UIButton *eraser;   
}

-(IBAction)onRed;
-(IBAction)onBlue;
-(IBAction)onYellow;
-(IBAction)onGreen;
-(IBAction)onErase;

@end
