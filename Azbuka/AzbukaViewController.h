#import <UIKit/UIKit.h>
#import "AzbukaDeskView.h"
#import "PaletteController.h"
#import "AboutController.h"
#import "Purchase.h"

@interface AzbukaViewController : UIViewController<AzbukaDeskViewProto, PaletteDelegate, AboutControllerDelegate, PurchaseDelegate> {
    IBOutlet AzbukaDeskView *deskView;
    IBOutlet PaletteController *palette;
    
    Purchase *purchase;
}

-(IBAction)onAbout;

@end
