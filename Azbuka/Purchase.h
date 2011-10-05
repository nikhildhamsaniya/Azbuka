#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

extern  NSString* kPurchaseBeginEvent;
extern  NSString* kPurchaseEndEvent;

@class Purchase;
@protocol PurchaseDelegate
- (void)purchaseFailWithError:(NSError *)error;
- (void)purchased;
@end


@interface Purchase : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	id<PurchaseDelegate> delegate;
	SKProductsRequest *request;
}
@property(nonatomic, assign) id<PurchaseDelegate> delegate;

- (void)makePurchase;
- (id)initWithDelegate:(id)_delegate;
@end
