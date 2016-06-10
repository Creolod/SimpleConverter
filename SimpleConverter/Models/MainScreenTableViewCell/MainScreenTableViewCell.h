//
//  MainScreenTableViewCell.h
//  SimpleConverter
//
//  Created by User on 08.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextFieldForCell.h"

@interface MainScreenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet CustomTextFieldForCell *sumTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
