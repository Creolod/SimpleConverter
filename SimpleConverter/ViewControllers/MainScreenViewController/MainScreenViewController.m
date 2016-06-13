//
//  MainScreenViewController.m
//  SimpleConverter
//
//  Created by User on 08.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "MainScreenViewController.h"
#import "MainScreenTableViewCell.h"
#import "Currency.h"
#import "Facade.h"

@interface MainScreenViewController (){
    NSArray * convertRates;
    double sum;
    UIToolbar* numberToolbar;
    UITextField * currentTF;
    UIRefreshControl * refreshControl;
}

@end

@implementation MainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sum = 0;
    [self addObservers];
    [self initRefreshControl];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    convertRates = [Facade getCurrenciesWithCheckedStatus:YES];
    [self.tableView reloadData];
    if (refreshControl.isRefreshing) {
        CGPoint offset = self.tableView.contentOffset;
        [refreshControl endRefreshing];
        [refreshControl beginRefreshing];
        self.tableView.contentOffset = offset;
    }
}

-(NSString*)getFormatedStringFromNumber:(double)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setGroupingSeparator:@""];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}

#pragma mark - "Pull To Refresh" Mehods

-(void)initRefreshControl{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Update rates..."];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh{
    [self.tableView reloadData];
    if (![[Facade sharedManager]getInternetStatus]) {
        [refreshControl endRefreshing];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Can't load rates" message:@"Check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action){
                                   }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [Facade updateConvertRates];
            dispatch_async(dispatch_get_main_queue(), ^{
                convertRates = [Facade getCurrenciesWithCheckedStatus:YES];
                [refreshControl endRefreshing];
            });
        });
    }
}

#pragma mark - Keyboard Show/Hide Methods

-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.tableViewBottomConstraint.constant = kbSize.height;
}

-(void)keyboardWillHide:(NSNotification*)aNotification{
    self.tableViewBottomConstraint.constant = 0;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor blackColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Last update: ", nil), [[NSUserDefaults standardUserDefaults] objectForKey:@"SumpleConverterLastUpdate"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return convertRates.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainScreenTableViewCell" forIndexPath:indexPath];
    Currency * currency = convertRates[indexPath.row];
    cell.currencyLabel.text = currency.name;
    cell.descriptionLabel.text = NSLocalizedString(currency.name, nil);
    [cell.sumTextField addTarget:self action:@selector(sumTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [cell.sumTextField addTarget:self action:@selector(sumTextFieldBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
    [cell.sumTextField addTarget:self action:@selector(sumTextFieldEndAction:) forControlEvents:UIControlEventEditingDidEnd];
    cell.sumTextField.tag = indexPath.row;
    
    cell.sumTextField.text = [self getFormatedStringFromNumber: sum * currency.rate.floatValue];
    return cell;
}

#pragma mark - Text Field Selectors

-(void)sumTextFieldBeginAction:(UITextField*)sumTextField{
    MainScreenTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sumTextField.tag inSection:0]];
    cell.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:0.5];
    sumTextField.text = @"0";
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)sumTextFieldEndAction:(UITextField*)sumTextField{
    MainScreenTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sumTextField.tag inSection:0]];
    cell.backgroundColor = [UIColor whiteColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)sumTextFieldChangeAction:(UITextField*)sumTextField{
    Currency * currency = convertRates[sumTextField.tag];
    if ([sumTextField.text length] > 0) {
        if ([sumTextField.text hasPrefix:@"0"]) {
            sumTextField.text = [sumTextField.text substringFromIndex:1];
        }
        if (sumTextField.text.floatValue>0) {
            sum = sumTextField.text.doubleValue / currency.rate.floatValue;
            for (int i = 0; i<convertRates.count; i++){
                if (i != sumTextField.tag)
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } else {
        sumTextField.text = @"0";
    }
}

#pragma mark - Delete Currency Method

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Currency * currency = convertRates[indexPath.row];
        currency.checked = @NO;
        convertRates = [Facade getCurrenciesWithCheckedStatus:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
