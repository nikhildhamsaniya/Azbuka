#import "AzbukaViewController.h"
#import "CGGeometry+Utils.h"
#import "PaletteView.h"

@implementation AzbukaViewController

#pragma mark private

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    deskView.delegate = self;
    
    paletteView.hidden = YES;
    paletteView.alpha = 0;
}


- (void)dealloc
{
    [paletteView release];
    deskView.delegate = nil;
    [deskView release];    
    [super dealloc];
}



#pragma mark UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark AzbukaLayoutViewProto

-(void)tappedLetter:(int)index view:(UIView*)view{
    if(deskView.hasExposedLetter) {
        if(view != deskView.exposedLetter) {
            [deskView unexpose];
            [UIView animateWithDuration:0.3 animations:^(void){paletteView.alpha = 0;} completion:^(BOOL ignore){paletteView.hidden = YES;}];
        }
    } else{
        [deskView exposeLetter:index uponCompletionDo:nil];  
        paletteView.hidden = NO;
        [UIView animateWithDuration:1 animations:^(void){paletteView.alpha = 1;}];
    }
}

@end
