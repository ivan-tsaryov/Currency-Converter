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

@end

@implementation CurrencyPVController

- (id)initWithData: (NSMutableDictionary<NSString *, NSNumber *> *) currencies_ {
    self = [super init];
    if (self) {
        self.currencies = currencies_;
        self.selectedCurrencies = [[NSMutableArray alloc] init];
        
        self.selectedCurrencies[0] = @"USD";
        self.selectedCurrencies[1] = @"RUB";
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
    self.keys = [[self.currencies allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    return self.keys[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.keys = [[self.currencies allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.selectedCurrencies[component] = self.keys[row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userSelect" object: nil];
}

@end
