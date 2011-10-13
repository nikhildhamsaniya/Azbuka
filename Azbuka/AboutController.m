#import "AboutController.h"
#import "UIAlertView+Utils.h"
#import "NSError+Utils.h"
#import "CGGeometry+Utils.h"
#import "Purchase.h"

@implementation AboutController
@synthesize delegate;

#pragma mark private

-(void)sendMailTo:(NSString*)mail name:(NSString*)name{
    if(![MFMailComposeViewController canSendMail]) {
        [UIAlertView showAlertViewErrorMessage:@"В данный момент отсылка почты невозможна =("];
    }
    
    MFMailComposeViewController *ctrl = [[MFMailComposeViewController alloc] init];
    ctrl.mailComposeDelegate = self;
    [ctrl setToRecipients:[NSArray arrayWithObject:mail]];
    [ctrl setSubject:@"Азбука Детячья"];
    [ctrl setMessageBody:[NSString stringWithFormat:@"Добрый день, %@.\n", name] isHTML:NO];
    
    [self presentModalViewController:ctrl animated:YES];
    [ctrl release];
    
}

#pragma mark lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPurchaseBegin:) name:kPurchaseBeginEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPurchaseEnd:) name:kPurchaseEndEvent object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [supportButton release];
    [indicator release];
    [super dealloc];
}


#pragma mark UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

#pragma mark actions

-(IBAction)onBack{
    [delegate aboutControllerWantToDismiss:self];
}

-(IBAction)onSupport{   
    [delegate aboutControllerWantToPurchase:self]; 
}

-(IBAction)onVersalab{
    WebViewController *ctrl = [WebViewController webViewControllerForUrl:@"http://www.versolab.com"];
    ctrl.view.frame = CGRectInset(self.view.bounds, 20, 20);
    ctrl.delegate = self;
    [self presentModalViewController:ctrl animated:YES];
}

-(IBAction)onGriffin{
    [self sendMailTo:@"griffin@front.ru" name:@"Сергей"];
}

-(IBAction)onLokivoid{
    [self sendMailTo:@"chill.waters@gmail.com" name:@"Илья"];
}

-(IBAction)onSafka{
    [self sendMailTo:@"artsafka@gmail.com" name:@"Аня"];
}


-(void)onPurchaseBegin:(NSNotification*)ignore{
    supportButton.enabled = NO;
    [indicator startAnimating];
}

-(void)onPurchaseEnd:(NSNotification*)ignore{
    supportButton.enabled = YES;
    [indicator stopAnimating];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error{
    if(error){
     [error display];   
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark WebViewControllerDelegate
-(void)webViewControllerDidDismiss:(WebViewController*)ctrl{
    [self dismissModalViewControllerAnimated:YES];
}

@end