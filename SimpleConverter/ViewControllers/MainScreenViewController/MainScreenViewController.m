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
    float sum;
    UIToolbar* numberToolbar;
    UITextField * currentTF;
}

@end

@implementation MainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sum = 0;
    [self addObservers];
    [self addRefreshControl];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    convertRates = [Facade getCurrenciesWithCheckedStatus:YES];
    [self.tableView reloadData];
}

-(NSString*)getFormatedStringFromNumber:(float)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setGroupingSeparator:@""];
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:number]];
}

#pragma mark - "Pull To Refresh" Mehods

-(void)addRefreshControl{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Update rates..."];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    if (![[Facade sharedManager]getInternetStatus]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Can't load rates" message:@"Check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action){
                                   }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else
        [Facade updateConvertRates];
    [refreshControl endRefreshing];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return convertRates.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainScreenTableViewCell" forIndexPath:indexPath];
    Currency * currency = convertRates[indexPath.row];
    cell.currencyLabel.text = currency.name;
    [cell.sumTextField addTarget:self action:@selector(sumTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [cell.sumTextField addTarget:self action:@selector(sumTextFieldBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
    [cell.sumTextField addTarget:self action:@selector(sumTextFieldEndAction:) forControlEvents:UIControlEventEditingDidEnd];
    cell.sumTextField.tag = indexPath.row;
    
    cell.sumTextField.text = [self getFormatedStringFromNumber:sum * currency.rate.floatValue];
    return cell;
}

#pragma mark - Text Field Selectors

-(void)sumTextFieldBeginAction:(UITextField*)sumTextField{
    MainScreenTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sumTextField.tag inSection:0]];
    cell.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1];
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
    if (sumTextField.text.floatValue>0) {
        sum = sumTextField.text.floatValue / currency.rate.floatValue;
        for (int i = 0; i<convertRates.count; i++){
            if (i != sumTextField.tag)
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
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
