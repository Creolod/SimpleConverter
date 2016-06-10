//
//  XMLParser.m
//  SimpleConverter
//
//  Created by User on 07.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "XMLParser.h"
#import "Facade.h"
#import "Currency.h"

@implementation XMLParser{
    NSXMLParser * xmlParser;
}

-(void)updateConvertRates{
    
    [Facade saveCurrencyWithName:@"EUR" rate:1];
    
    NSURL * urlWithCurrencyRates = [NSURL URLWithString:@"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:urlWithCurrencyRates];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Cube"]) {
        NSString * currencyName = attributeDict[@"currency"];
        float rate = [attributeDict[@"rate"] floatValue];
        if (currencyName && rate) {
            [Facade saveCurrencyWithName:currencyName rate:rate];
        }
    }
}


@end
