#import "AzbukaViewController.h"
#import "LetterLister.h"
#import "CGGeometry+Utils.h"

@implementation AzbukaViewController

#pragma mark private

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    azbukaView.delegate = self;
}


- (void)dealloc
{
    azbukaView.delegate = nil;
    [azbukaView release];    
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
    if(azbukaView.exposedLetter) {
        if(view != azbukaView.exposedLetter) [azbukaView unexpose];
    } else{
        [azbukaView exposeLetter:index uponCompletionDo:nil];  
    }
}

@end
