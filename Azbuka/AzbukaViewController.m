#import "AzbukaViewController.h"
#import "CGGeometry+Utils.h"
#import "Azbuka.h"

@implementation AzbukaViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    letterView.delegate = self;
    letterView.dataSource = self;
    [letterView reloadData];
    
    [azbuka addObserver:self
             forKeyPath:@"selectedLetterIndex"
                options:(NSKeyValueObservingOptionNew |
                         NSKeyValueObservingOptionOld)
                context:NULL];
}

- (void)dealloc
{
    [azbuka release];
     
    [navigatorView release];
    [letterView release];
    [super dealloc];
}

#pragma mark UIViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark LeavesViewDelegate/Data source

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)letterView{
    return 33;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG", index+1]];
    CGSize sz = CGSizeFitIntoSize(image.size, letterView.bounds.size);
    CGRect rect = (CGRect){CGPointZero, sz};
    rect = CGRectCenterToRect(rect, letterView.bounds);
    
    CGContextDrawImage(ctx, rect, image.CGImage);
}

- (void) leavesView:(LeavesView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex{
    azbuka.selectedLetterIndex = pageIndex;
}

#pragma mark event handling

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"selectedLetterIndex"]) {
        letterView.currentPageIndex = azbuka.selectedLetterIndex;
    }
}

@end
