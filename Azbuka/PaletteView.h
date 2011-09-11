#import <UIKit/UIKit.h>


@interface PaletteView : UIView {
    UIButton *red, *blue, *yellow, *green, *eraser;   
}

-(IBAction)onRed;
-(IBAction)onBlue;
-(IBAction)onYellow;
-(IBAction)onGreen;
-(IBAction)onErase;

@end
