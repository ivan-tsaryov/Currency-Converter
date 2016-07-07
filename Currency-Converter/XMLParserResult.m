//
//  XMLParserResult.m
//  iOS-3-lesson
//
//  Created by Иван Царев on 30.06.16.
//  Copyright © 2016 Иван Царев. All rights reserved.
//

#import "XMLParserResult.h"

@interface XMLParserResult ()

@property (nonatomic, strong) NSString *lastCharCode;
@property (nonatomic, strong) NSString *lastElementName;

@end

@implementation XMLParserResult

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.result = [[NSMutableDictionary alloc] init];
        [self.result setObject: @1 forKey: @"RUB"];
        
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSNumber *> *)attributeDict {
    NSLog(@"Found elementName: %@, namespace: %@, qualName: %@", elementName, namespaceURI, qName);
    
    self.lastElementName = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"Found end element: %@", elementName);
    self.lastElementName = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"Found characters: %@", string);
    
    if ([self.lastElementName isEqualToString: @"CharCode"]) {
        self.lastCharCode = string;
    } else if ([self.lastElementName isEqualToString: @"Nominal"]) {
        NSNumber *number = [NSNumber numberWithInteger:[string integerValue]];
        
        [self.result setObject: number forKey: self.lastCharCode];
    } else if ([self.lastElementName isEqualToString: @"Value"]) {
        float value = [string floatValue];
        NSNumber *nominal = [self.result objectForKey: self.lastCharCode];
        int simpleNominal = [nominal intValue];
        
        float result = value/simpleNominal;
        
        [self.result setObject: @(result) forKey: self.lastCharCode];
    }
}

-(NSMutableDictionary<NSString *, NSNumber *> *)getResult {
    return self.result;
}

@end
