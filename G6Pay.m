//
//  G6Pay.m
//  
//
//
//  Copyright 2011 G6 Media Inc. All rights reserved.
//

#import "G6Pay.h"

const NSString *secret_key=@"REPLACE_WITH_YOUR_APP_SECRET_CODE";
const NSString *application_id=@"REPLACE_WITH_YOUR_ADVERTISER_APP_ID";
const NSString *pay_per_install_url=@"http://g6pay.com/api/installconfirm";

@implementation G6Pay

@synthesize connection, data;

//function to be called to initiate the asynchronous installation confirmation call

-(void)track {
	
	[self payPerInstall:application_id];
	
}

//generates the SHA256 hash

-(NSString *) hashGen:(NSString*)input
{
	
	const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *localdata = [NSData dataWithBytes:cstr length:input.length];
	uint8_t hashGen[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(localdata.bytes, localdata.length, hashGen);
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", hashGen[i]];
	
	return output;
	
}

-(void)payPerInstall:(NSString *) appId {
	
	UIDevice *device = [UIDevice currentDevice];
	NSString *uniqueIdentifier = [device uniqueIdentifier];
	
	//prepare the string for SHzA256 conversion
	NSString *toHash = [NSString stringWithFormat:@"%@%@%@", appId, uniqueIdentifier, secret_key];
	//send for conversion, generate hash
	NSString *hash = [self hashGen:toHash];
	
	//prepare the URL for the asynchronous request to confirm the app install
	NSString* url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",pay_per_install_url,@"?app_id=",appId,@"&phone_id=",uniqueIdentifier, @"&signature=", hash];
	NSLog(@"%@",url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
}


- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
	
   self.data = [[NSMutableData alloc] initWithCapacity:2048];
    [self.data appendData:incrementalData];

}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
	
	//ASCII Method
    NSString *result= [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
	
	

}



@end
