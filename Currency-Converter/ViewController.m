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

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *valueTextFields;

@property (weak, nonatomic) IBOutlet UILabel *usdLabel;
@property (weak, nonatomic) IBOutlet UILabel *eurLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSelect:) name:@"userSelect" object:nil];
    
    self.currentDate = [NSDate date];
    
    self.parserResult = [[XMLParserResult alloc] init];
    
    self.currencyPVController = [[CurrencyPVController alloc] initWithData: self.parserResult.result];
    [self configureDatePicker];
    
    [self sendGetExchangeRatesRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    NSString *leftCurr = self.currencyPVController.selectedCurrencies[0];
    NSString *rightCurr = self.currencyPVController.selectedCurrencies[1];
    
    NSArray *keys = keys = [[self.parserResult.result allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    [self.currencyPickerView selectRow: [keys indexOfObject: leftCurr] inComponent: 0 animated: false];
    [self.currencyPickerView selectRow: [keys indexOfObject: rightCurr] inComponent: 1 animated: false];
    [self convertCurrenciesWithConvertingID: 0 ResultID: 1 ConvTextField: self.valueTextFields[0] ResTextField: self.valueTextFields[1]];
}

- (IBAction)textFieldValueChanged:(id)sender {
    NSArray *tfs = self.valueTextFields;
    
    int convID = (int) [tfs indexOfObject: (UITextField *) sender];
    int resID = (int) tfs.count - (convID + 1);
    
    [self convertCurrenciesWithConvertingID: convID ResultID: resID ConvTextField: tfs[convID] ResTextField: tfs[resID]];
}

-(void) convertCurrenciesWithConvertingID: (int) convID ResultID: (int) resID ConvTextField: (UITextField*) ctf ResTextField: (UITextField *) rtf  {
    NSMutableDictionary<NSString *, NSNumber *> *currencies = self.currencyPVController.currencies;
    
    NSString *selectedConvertingCurrency = self.currencyPVController.selectedCurrencies[convID];
    NSString *selectedResultCurrency = self.currencyPVController.selectedCurrencies[resID];
    
    float convertingValue = [ctf.text floatValue];

    float convertingRate = [[currencies objectForKey: selectedConvertingCurrency] floatValue];
    float resultRate = [[currencies objectForKey: selectedResultCurrency] floatValue];
    
    float resultValue = resultValue = convertingRate/resultRate*convertingValue;
    
    rtf.text = [[NSNumber numberWithFloat: resultValue] stringValue];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)userSelect:(NSNotification *)notification {
    [self convertCurrenciesWithConvertingID: 0 ResultID: 1 ConvTextField: self.leftValueTextField ResTextField: self.rightValueTextField];
}

@end
