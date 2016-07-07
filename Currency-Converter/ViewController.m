//
//  ViewController.m
//  Currency-Converter
//
//  Created by Иван Царев on 07.07.16.
//  Copyright © 2016 Иван Царев. All rights reserved.
//

#import "ViewController.h"
#import "XMLParserResult.h"
#import "CurrencyPVController.h"

NSString *const kParserURL = @"http://www.cbr.ru/scripts/XML_daily.asp?date_req=%@";

@interface ViewController ()

@property (strong, nonatomic) CurrencyPVController *currencyPVController;

@property (strong, nonatomic) XMLParserResult *parserResult;
@property (strong, nonatomic) NSXMLParser *xmlParser;

@property (strong, nonatomic) NSDate *currentDate;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *leftValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightValueTextField;

@property (weak, nonatomic) IBOutlet UILabel *usdLabel;
@property (weak, nonatomic) IBOutlet UILabel *eurLabel;


@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentDate = [NSDate date];
    
    self.parserResult = [[XMLParserResult alloc] init];
    
    self.currencyPVController = [[CurrencyPVController alloc] initWithData: self.parserResult.result];
    [self configureDatePicker];
    
    [self sendGetExchangeRatesRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) configureCurrencyPicker {
    self.currencyPickerView.delegate = self.currencyPVController;
}

-(void) configureDatePicker {
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    
    picker.backgroundColor = [UIColor whiteColor];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker setMaximumDate: self.currentDate];
    [picker addTarget: self action: @selector (onDateValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    self.dateTextField.inputAccessoryView = picker;
}

-(void) onDateValueChanged:(id)sender {
    UIDatePicker *dp = (UIDatePicker *) sender;
    
    self.currentDate = dp.date;
    self.dateTextField.text = [self stringFromDate: self.currentDate];
    
    [self sendGetExchangeRatesRequest];
}
                         
- (void)sendGetExchangeRatesRequest {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = [NSString stringWithFormat: kParserURL, [self stringFromDate: self.currentDate]];
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL: url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData: data encoding: NSWindowsCP1251StringEncoding];
        self.xmlParser = [[NSXMLParser alloc] initWithData: data];
        
        NSLog(@"Получен ответ: %@", result);
        
        self.xmlParser.delegate = self.parserResult;
        [self.xmlParser parse];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateViews];
        });
    }];
    
    [task resume];
}

-(NSString *) stringFromDate: (NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat: @"dd/MM/yyyy"];
    
    return [formatter stringFromDate: date];
}

-(void) updateViews {
    [self configureCurrencyPicker];
    self.dateTextField.text = [self stringFromDate: self.currentDate];
    self.usdLabel.text = [[@"USD: " stringByAppendingString: [self.parserResult.result[@"USD"] stringValue]] stringByAppendingString: @" RUB"];
    self.eurLabel.text = [[@"EUR: " stringByAppendingString: [self.parserResult.result[@"EUR"] stringValue]] stringByAppendingString: @" RUB"];
    
}

- (IBAction)valueTextFieldChanged:(id)sender {
    UITextField *convertingTextField = (UITextField *) sender;
    UITextField *resultTextField;
    
    NSString *selectedConvertingCurrency;
    NSString *selectedResultCurrency;
    float convertingValue, resultValue;
    
    if (convertingTextField == self.leftValueTextField) {
        selectedConvertingCurrency = self.currencyPVController.leftSelectedCurrency;
        selectedResultCurrency = self.currencyPVController.rightSelectedCurrency;
        resultTextField = self.rightValueTextField;
        convertingValue = [self.leftValueTextField.text floatValue];
    } else {
        selectedConvertingCurrency = self.currencyPVController.rightSelectedCurrency;
        selectedResultCurrency = self.currencyPVController.leftSelectedCurrency;
        resultTextField = self.leftValueTextField;
        convertingValue = [self.rightValueTextField.text floatValue];
    }
    
//    NSLog(@"Конвертируемая величина: %@", selectedConvertingCurrency);
//    NSLog(@"Результируемая величина: %@", selectedResultCurrency);
    

    float convertingRate = [[self.parserResult.result objectForKey: selectedConvertingCurrency] floatValue];
    float resultRate = [[self.parserResult.result objectForKey: selectedResultCurrency] floatValue];
    
    
//    NSLog(@"Конвертируемое количество: %f", convertingValue);
//    NSLog(@"Конвертируемый курс: %f", convertingRate);
//    NSLog(@"Результативный курс : %f", resultRate);
    
    resultValue = convertingRate/resultRate*convertingValue;
    
    
    resultTextField.text = [[NSNumber numberWithFloat: resultValue] stringValue];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];// this will do the trick
    
    if ([self.leftValueTextField.text  isEqual: @""]) {
        self.leftValueTextField.text = @"0";
    } else if ([self.rightValueTextField.text isEqual: @""]) {
        self.rightValueTextField.text = @"0";
    }
}

@end
