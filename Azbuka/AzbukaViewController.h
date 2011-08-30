#import <UIKit/UIKit.h>
#import "LeavesView.h"
#import "LettersNavigatorView.h"
@class Azbuka;

@interface AzbukaViewController : UIViewController<LeavesViewDelegate, LeavesViewDataSource> {
    IBOutlet Azbuka* azbuka;
    
    IBOutlet LeavesView *letterView;
    IBOutlet LettersNavigatorView *navigatorView;
}

@end
