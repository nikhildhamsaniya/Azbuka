#import "Purchase.h"
#import "NSError+Utils.h"

NSString* kPurchaseBeginEvent = @"kPurchaseBeginEvent";
NSString* kPurchaseEndEvent = @"kPurchaseEndEvent";

@implementation Purchase
@synthesize delegate;

-(void)fireBeginPurchaseEvent{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPurchaseBeginEvent object:self];
}

-(void)fireEndPurchaseEvent{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPurchaseEndEvent object:self];
}


- (id)initWithDelegate:(id)_delegate {
	if(![super init]) return nil;
	delegate = _delegate;
	return self;
}

- (NSError *)errorWithMessage:(NSString *)m {
	return [NSError errorWithDomain:@"In-App Purchase" code:100 description:m];
} 

- (void)makePurchase {
    [self fireBeginPurchaseEvent];
	if(![SKPaymentQueue canMakePayments]) {
        [self fireEndPurchaseEvent];
		[delegate purchaseFailWithError:[self errorWithMessage:@"You can not make payments."]];
		return;
	}
	
	[request release];
	request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.versolab.azbuka.donation1"]];
	request.delegate = self;
	[request start];
}

- (void)dealloc {
	[request release];
	[super dealloc];
}

#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSArray *products = response.products;
	if(!products || products.count == 0) {
        [self fireEndPurchaseEvent];
		[delegate purchaseFailWithError:[self errorWithMessage:@"Product not found."]];
		return;
	}
	
	SKProduct *product = [products objectAtIndex:0];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:product]];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self fireEndPurchaseEvent];
	[delegate purchaseFailWithError:error];
}

#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [self fireEndPurchaseEvent];
    
	SKPaymentTransaction *myTransaction = nil;
	for (SKPaymentTransaction *transaction in transactions) {
		if (transaction.transactionState == SKPaymentTransactionStatePurchased || 
		    transaction.transactionState == SKPaymentTransactionStateFailed) {
			myTransaction = transaction;
		}
		if (transaction.transactionState != SKPaymentTransactionStatePurchasing) {
			[queue finishTransaction:transaction];
		}
	}
	
	if(!myTransaction) { 
		return;
	}
	
	if(myTransaction.transactionState == SKPaymentTransactionStatePurchased) {
		[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
		[delegate purchased];
	} else {
		[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
		[delegate purchaseFailWithError: nil];
	}
}

@end
