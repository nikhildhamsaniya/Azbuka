#import <UIKit/UIKit.h>

@class PaintingTool;

@protocol PaletteDelegate
-(void)paletteDidSelectTool:(PaintingTool*)tool;
@end

@interface PaletteController : UIViewController {
    IBOutlet UIView* horPalette;
    IBOutlet UIView* vertPalette;
    
    PaintingTool *selectedTool;
    id<PaletteDelegate> delegate;
}
@property(nonatomic, retain, readonly) PaintingTool *selectedTool;
@property(nonatomic, assign) id<PaletteDelegate> delegate;

-(void)loadHorizontalView;
-(void)loadVerticalView;

-(IBAction)onLightBlue;
-(IBAction)onBlue;
-(IBAction)onViolet;
-(IBAction)onGreen;
-(IBAction)onRed;
-(IBAction)onOrange;
-(IBAction)onYellow;
-(IBAction)onBrown;
-(IBAction)onBlack;
-(IBAction)onErase;

@end
