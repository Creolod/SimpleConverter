//
//  MainScreenTableViewCell.m
//  SimpleConverter
//
//  Created by User on 08.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "MainScreenTableViewCell.h"

@implementation MainScreenTableViewCell

-(void) setupFromXib: (NSString*) identifier{
    UIView* view = [self loadFromNib:identifier];
    view.frame = self.frame;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
}

-(UIView*) loadFromNib:(NSString*) idendifer {
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    UINib* nib = [UINib nibWithNibName:idendifer bundle:bundle];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { [self setupFromXib:@"MainScreenTableViewCell"]; }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if (self) {
        [self setupFromXib:@"MainScreenTableViewCell"]; }
    return self;
}

@end
