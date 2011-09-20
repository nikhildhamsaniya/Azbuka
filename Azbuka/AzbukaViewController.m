#import "AzbukaViewController.h"
#import "CGGeometry+Utils.h"
#import "AzbukaDeskView.h"
#import "LetterView.h"

@implementation AzbukaViewController

#pragma mark private

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    deskView.delegate = self;
    
    paletteView.delegate = self;
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

-(void)willExposeLetter:(int)index view:(UIView*)view{
    paletteView.hidden = NO;
    [UIView animateWithDuration:1 animations:^(void){paletteView.alpha = 1;}];    
}

-(void)didExposeLetter:(int)index view:(UIView*)view{
    [paletteView updateSelectedColor];
}


-(void)allLettersWillUnexposed{
    [UIView animateWithDuration:0.3 animations:^(void){paletteView.alpha = 0;} completion:^(BOOL ignore){paletteView.hidden = YES;}];
}

-(void)allLettersDidUnexposed{
    
}


#pragma mark PaletteViewDelegate

-(void)paletteDidChooseColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    [deskView.exposedLetter setPaintingBrushColorWithRed:red  green:green blue:blue];
}

-(void)paletteDidChooseEraser{
    [deskView.exposedLetter setEraser];
}

@end
