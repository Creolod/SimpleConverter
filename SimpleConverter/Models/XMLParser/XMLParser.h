//
//  XMLParser.h
//  SimpleConverter
//
//  Created by User on 07.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate>

-(void)updateConvertRates;

@end
