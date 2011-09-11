#import <UIKit/UIKit.h>
#import "AzbukaDeskView.h"
#import "PaletteView.h"

@interface AzbukaViewController : UIViewController<AzbukaDeskViewProto, PaletteViewDelegate> {
    IBOutlet AzbukaDeskView *deskView;
    IBOutlet PaletteView *paletteView;
}

@end
