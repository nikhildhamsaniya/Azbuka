#import <UIKit/UIKit.h>
#import "AzbukaLayoutView.h"

@class PaletteView;

@interface AzbukaViewController : UIViewController<AzbukaLayoutViewProto> {
    IBOutlet AzbukaLayoutView *azbukaView;
    IBOutlet PaletteView *paletteView;
}

@end
