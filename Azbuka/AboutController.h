#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WebViewController.h"

@class AboutController;

@protocol AboutControllerDelegate
-(void)aboutControllerWantToDismiss:(AboutController*)ctrl;
@end


@interface AboutController : UIViewController<MFMailComposeViewControllerDelegate, WebViewControllerDelegate> {
    id<AboutControllerDelegate> delegate;
}
@property(nonatomic, assign) id<AboutControllerDelegate> delegate;

-(IBAction)onBack;
-(IBAction)onSupport;
-(IBAction)onVersalab;
-(IBAction)onGriffin;
-(IBAction)onLokivoid;
-(IBAction)onSafka;
@end
