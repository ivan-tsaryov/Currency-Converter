//
//  XMLParserResult.h
//  iOS-3-lesson
//
//  Created by Иван Царев on 30.06.16.
//  Copyright © 2016 Иван Царев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParserResult : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *result;

@end
