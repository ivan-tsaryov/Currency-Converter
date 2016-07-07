//
//  CurrencyPickerView.m
//  iOS-3-lesson
//
//  Created by Иван Царев on 07.07.16.
//  Copyright © 2016 Иван Царев. All rights reserved.
//

#import "CurrencyPVController.h"

NSString *const kDefaultCurrency = @"KGS";

@interface CurrencyPVController ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *currencies;

@end

@implementation CurrencyPVController

- (id)initWithData: (NSMutableDictionary<NSString *, NSNumber *> *) currencies_ {
    self = [super init];
    if (self) {
        self.currencies = currencies_;
        self.leftSelectedCurrency = kDefaultCurrency;
        self.rightSelectedCurrency = kDefaultCurrency;
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currencies.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray * keys = [[self.currencies allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    return keys[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray * keys = [[self.currencies allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    if (component == 0) {
        self.leftSelectedCurrency = keys[row];
    } else {
        self.rightSelectedCurrency = keys[row];
    }
}

@end
