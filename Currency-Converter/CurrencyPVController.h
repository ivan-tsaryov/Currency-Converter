//
//  CurrencyPVController.h
//  Currency-Converter
//
//  Created by Иван Царев on 07.07.16.
//  Copyright © 2016 Иван Царев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kDefaultCurrency;

@interface CurrencyPVController : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *currencies;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *selectedCurrencies;

- (id)initWithData: (NSMutableDictionary<NSString *, NSNumber *> *) currencies_;

@end
