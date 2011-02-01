//
//  G6Pay.h
//  
//
//  Created by Rangel Spasov on 10/4/10.
//  Copyright 2011 G6 Media. All rights reserved.



#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface G6Pay : NSObject {
	
	NSURLConnection *connection;
	NSMutableData* data;
	
}



@property (retain) NSURLConnection *connection;
@property (retain) NSMutableData* data;


@end
