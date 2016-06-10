//
//  AddNewCurrenciesViewController.m
//  SimpleConverter
//
//  Created by User on 10.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "AddNewCurrenciesViewController.h"
#import "Facade.h"
#import "Currency.h"

@interface AddNewCurrenciesViewController (){
    NSArray * convertRates;
}

@end

@implementation AddNewCurrenciesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    convertRates = [Facade getCurrenciesWithCheckedStatus:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return convertRates.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    Currency * currency = convertRates[indexPath.row];
    cell.textLabel.text = currency.name;
    cell.detailTextLabel.text = NSLocalizedString(currency.name, nil);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Currency * currency = convertRates[indexPath.row];
    currency.checked = @YES;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
