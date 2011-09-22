#import <UIKit/UIKit.h>
#import "AzbukaDeskView.h"
#import "PaletteController.h"

@interface AzbukaViewController : UIViewController<AzbukaDeskViewProto, PaletteDelegate> {
    IBOutlet AzbukaDeskView *deskView;
    IBOutlet PaletteController *palette;
}

@end
