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

@property (nonatomic, strong) UITextField *activeTextField;
@property (nonatomic, strong) NSString *leftSelectedCurrency;
@property (nonatomic, strong) NSString *rightSelectedCurrency;

- (id)initWithData: (NSMutableDictionary<NSString *, NSNumber *> *) currencies_;

@end
