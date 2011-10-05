#import <UIKit/UIKit.h>

@class WebViewController;

@protocol WebViewControllerDelegate
-(void)webViewControllerDidDismiss:(WebViewController*)ctrl;
@end


@interface WebViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIActivityIndicatorView *indicator;
    
    NSString *url;
    
    id<WebViewControllerDelegate> delegate;
}
@property(nonatomic, assign) id<WebViewControllerDelegate> delegate;

+(WebViewController*)webViewControllerForUrl:(NSString*)url;

-(IBAction)onBack;

@end
