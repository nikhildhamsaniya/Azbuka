#import <UIKit/UIKit.h>
#import "AzbukaDeskView.h"

@class PaletteView;

@interface AzbukaViewController : UIViewController<AzbukaDeskViewProto> {
    IBOutlet AzbukaDeskView *azbukaView;
    IBOutlet PaletteView *paletteView;
}

@end
