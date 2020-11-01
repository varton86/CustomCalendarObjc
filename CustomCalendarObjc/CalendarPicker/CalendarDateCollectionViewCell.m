//
//  CalendarDateCollectionViewCell.m
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 27.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import "CalendarDateCollectionViewCell.h"

@interface CalendarDateCollectionViewCell ()
    
@property (strong, nonatomic) UIView *selectionBackgroundView;
@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation CalendarDateCollectionViewCell
{
    Day *day;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self configureSelectionBackgroundView];
    [self configureNumberLabel];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [NSLayoutConstraint deactivateConstraints:self.selectionBackgroundView.constraints];
    CGFloat size;
    if ([UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact]) {
        size = MIN(MIN(self.frame.size.width, self.frame.size.height) - 10, 60);
    }
    else
    {
        size = 38;
    }

    [self.numberLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
    [self.numberLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;

    [self.selectionBackgroundView.centerYAnchor constraintEqualToAnchor:self.numberLabel.centerYAnchor].active = true;
    [self.selectionBackgroundView.centerXAnchor constraintEqualToAnchor:self.numberLabel.centerXAnchor].active = true;
    [self.selectionBackgroundView.widthAnchor constraintEqualToConstant:size].active = true;
    [self.selectionBackgroundView.heightAnchor constraintEqualToConstant:size].active = true;
    
    self.selectionBackgroundView.layer.cornerRadius = size / 2;
}

- (void)traitCollectionDidChange:(UITraitCollection *) previousTraitCollection
{
    [super traitCollectionDidChange: previousTraitCollection];
    if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
        || (self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)) {

        [self layoutSubviews];
    }
}

- (void)configureWith:(Day *)aDay
{
    day = aDay;
    self.numberLabel.text = day.number;
    [self updateSelectionStatus];
}

- (void)configureSelectionBackgroundView
{
    self.selectionBackgroundView = [[UIView alloc] init];
    self.selectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
    self.selectionBackgroundView.clipsToBounds = true;
    self.selectionBackgroundView.backgroundColor = UIColor.systemGray2Color;
    
    [self.contentView addSubview:self.selectionBackgroundView];
}

- (void)configureNumberLabel
{
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = UIColor.labelColor;
    self.numberLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];

    [self.contentView addSubview:self.numberLabel];
}

- (void)updateSelectionStatus
{
    if (day != nil)
    {
        if (day.isSelected)
        {
            [self applySelectedStyle];
        }
        else
        {
            [self applyDefaultStyle:day.isWithinDisplayedMonth];
        }
    }
}

- (void) applySelectedStyle
{
    self.numberLabel.textColor = UIColor.whiteColor;
    [self.selectionBackgroundView setHidden:false];
}

- (void) applyDefaultStyle:(BOOL)isWithinDisplayedMonth
{
    if (isWithinDisplayedMonth)
    {
        self.numberLabel.textColor = UIColor.labelColor;
    }
    else
    {
        self.numberLabel.textColor = UIColor.secondaryLabelColor;
    }

    [self.selectionBackgroundView setHidden:true];
}

@end
