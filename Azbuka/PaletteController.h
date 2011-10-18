#import <UIKit/UIKit.h>

@class PaintingTool;
@class PaletteButtonModel;

@protocol PaletteDelegate
-(void)paletteDidSelectTool:(PaintingTool*)tool;
@end

@interface PaletteController : UIViewController {
    IBOutlet UIButton* lightblueBtnHor;
    IBOutlet UIButton* lightblueBtnVert;
    IBOutlet UIButton* blueBtnHor;
    IBOutlet UIButton* blueBtnVert;
    IBOutlet UIButton* violetBtnHor;
    IBOutlet UIButton* violetBtnVert;
    IBOutlet UIButton* greenBtnHor;
    IBOutlet UIButton* greenBtnVert;
    IBOutlet UIButton* redBtnHor;
    IBOutlet UIButton* redBtnVert;
    IBOutlet UIButton* orangeBtnHor;
    IBOutlet UIButton* orangeBtnVert;
    IBOutlet UIButton* yellowBtnHor;
    IBOutlet UIButton* yellowBtnVert;
    IBOutlet UIButton* brownBtnHor;
    IBOutlet UIButton* brownBtnVert;
    IBOutlet UIButton* blackBtnHor;
    IBOutlet UIButton* blackBtnVert;
    IBOutlet UIButton* eraseBtnHor;
    IBOutlet UIButton* eraseBtnVert;
    
    NSMutableArray *buttonModels;
    PaletteButtonModel *selectedButton;
    
    IBOutlet UIView* horPalette;
    IBOutlet UIView* vertPalette;
    
    id<PaletteDelegate> delegate;
}
@property(nonatomic, readonly) PaintingTool *selectedTool;
@property(nonatomic, assign) id<PaletteDelegate> delegate;

-(void)loadHorizontalView;
-(void)loadVerticalView;

-(IBAction)onToolSelected:(id)toolButton;

@end
