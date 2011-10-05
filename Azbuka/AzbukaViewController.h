#import <UIKit/UIKit.h>
#import "AzbukaDeskView.h"
#import "PaletteController.h"
#import "AboutController.h"

@interface AzbukaViewController : UIViewController<AzbukaDeskViewProto, PaletteDelegate, AboutControllerDelegate> {
    IBOutlet AzbukaDeskView *deskView;
    IBOutlet PaletteController *palette;
}

-(IBAction)onAbout;

@end
