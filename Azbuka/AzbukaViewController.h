#import <UIKit/UIKit.h>
#import "AzbukaDeskView.h"

@class PaletteView;

@interface AzbukaViewController : UIViewController<AzbukaDeskViewProto> {
    IBOutlet AzbukaDeskView *deskView;
    IBOutlet PaletteView *paletteView;
}

@end
