#import "WebViewController.h"
#import "NSError+Utils.h"

@implementation WebViewController
@synthesize delegate;

#pragma mark private


#pragma mark lifecycle

-(id)initWithSiteURL:(NSString*)_url{
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    if (self) {
        url = [_url retain];
    }
    return self;
}

+(WebViewController*)webViewControllerForUrl:(NSString*)url{
    return [[[self alloc] initWithSiteURL:url] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];    
    navBar.topItem.title = request.URL.host;    
    webView.delegate = self;
   
    [webView loadRequest:request];
}

- (void)dealloc
{
    webView.delegate = nil;
    [webView release];
    [indicator release];
    [url release];
    [super dealloc];
}


#pragma mark UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark actions

-(IBAction)onBack{
    [delegate webViewControllerDidDismiss:self];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [indicator stopAnimating];
    [error display];
}


@end