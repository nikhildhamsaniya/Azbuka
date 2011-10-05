#import "AzbukaViewController.h"
#import "CGGeometry+Utils.h"
#import "AzbukaDeskView.h"
#import "LetterView.h"
#import "Painting.h"
#import "CGGeometry+Utils.h"
#import "AboutController.h"

@implementation AzbukaViewController

#pragma mark private

-(void)updatePaletteViewAnimated:(BOOL)animated{
    BOOL hidden = palette.view.hidden;
    float alpha = palette.view.alpha;
    [palette.view removeFromSuperview];    
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){        
        [palette loadHorizontalView];
        palette.view.center = CGPointMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(palette.view.bounds)/2 - 20,
                                          CGRectGetHeight(self.view.bounds) - CGRectGetHeight(palette.view.bounds)/2 - 15);
    }else{
        [palette loadVerticalView];
        palette.view.center = CGPointMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(palette.view.bounds)/2 - 15,
                                          CGRectGetHeight(palette.view.bounds)/2 + 5);
    }
    palette.view.hidden = hidden;
    palette.view.alpha = alpha;
    [self.view addSubview:palette.view];
    [self.view bringSubviewToFront:palette.view];
}

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    deskView.delegate = self;
    palette.delegate = self;
    palette.view.hidden = YES;
    palette.view.alpha = 0;
    [self updatePaletteViewAnimated:NO];    
}


- (void)dealloc
{
    [palette release];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self updatePaletteViewAnimated:YES];
}


#pragma mark AzbukaLayoutViewProto

-(void)willExposeLetter:(int)index view:(UIView*)view{
    palette.view.hidden = NO;
    [UIView animateWithDuration:1 animations:^(void){palette.view.alpha = 1;}];    
}

-(void)didExposeLetter:(int)index view:(UIView*)view{
    [deskView.exposedLetter setPaintingTool:palette.selectedTool];
}


-(void)allLettersWillUnexposed{
    [UIView animateWithDuration:0.3 animations:^(void){
        palette.view.alpha = 0;
    } completion:^(BOOL ignore){
        palette.view.hidden = YES;
    }];
}

-(void)allLettersDidUnexposed{
    
}


#pragma mark PaletteDelegate

-(void)paletteDidSelectTool:(PaintingTool*)tool{
    [deskView.exposedLetter setPaintingTool:tool];
}

#pragma mark AboutControllerDelegate

-(void)aboutControllerWantToDismiss:(AboutController*)ctrl{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark actions

-(IBAction)onAbout{
    AboutController *ctrl = [AboutController new];
    ctrl.delegate = self;
    ctrl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:ctrl animated:YES];
}

@end
