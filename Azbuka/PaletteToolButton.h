#import <Foundation/Foundation.h>

@class PaintingTool;

@interface PaletteToolButton : UIButton {
    PaintingTool *tool;
    
    UIImage *normalImage;
    UIImage *selectedImage;
}
@property(nonatomic, retain) PaintingTool *tool;

@end
