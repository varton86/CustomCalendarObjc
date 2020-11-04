//
//  CalendarPickerHeaderView.m
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 01.11.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import "CalendarPickerHeaderView.h"

@interface CalendarPickerHeaderView ()
    
@property (strong, nonatomic) UIStackView *dayOfWeekStackView;
@property (strong, nonatomic) UIButton *previousMonthButton;
@property (strong, nonatomic) UIButton *nextMonthButton;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *monthLabel;

@end

@implementation CalendarPickerHeaderView
{
    NSDateFormatter *dateFormatter;
    Block didTapRefreshCompletionHandler;
    Block didTapLastMonthCompletionHandler;
    Block didTapNextMonthCompletionHandler;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    
    [self configure];
    [self configureDayOfWeekStackView];
    [self configurePreviousMonthButton];
    [self configureRefreshButton];
    [self configureNextMonthButton];
    [self configureMonthLabel];
    [self configureSeparatorView];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.previousMonthButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
        [self.previousMonthButton.centerYAnchor constraintEqualToAnchor:self.monthLabel.centerYAnchor],
        [self.previousMonthButton.heightAnchor constraintEqualToConstant:28],
        [self.previousMonthButton.widthAnchor constraintEqualToConstant:28],

        [self.monthLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:14],
        [self.monthLabel.leadingAnchor constraintEqualToAnchor:self.previousMonthButton.trailingAnchor constant:10],

        [self.refreshButton.trailingAnchor constraintEqualToAnchor:self.nextMonthButton.leadingAnchor constant:-10],
        [self.refreshButton.centerYAnchor constraintEqualToAnchor:self.monthLabel.centerYAnchor],
        [self.refreshButton.heightAnchor constraintEqualToConstant:28],
        [self.refreshButton.widthAnchor constraintEqualToConstant:28],

        [self.nextMonthButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [self.nextMonthButton.centerYAnchor constraintEqualToAnchor:self.monthLabel.centerYAnchor],
        [self.nextMonthButton.heightAnchor constraintEqualToConstant:28],
        [self.nextMonthButton.widthAnchor constraintEqualToConstant:28],

        [self.separatorView.topAnchor constraintEqualToAnchor:self.monthLabel.bottomAnchor constant:14],
        [self.separatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.separatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.separatorView.heightAnchor constraintEqualToConstant:0.5],

        [self.dayOfWeekStackView.topAnchor constraintEqualToAnchor:self.separatorView.bottomAnchor constant:12],
        [self.dayOfWeekStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.dayOfWeekStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
}

- (void)setFor:(NSDate *)baseDate
{
    self.monthLabel.text = [dateFormatter stringFromDate:baseDate];
}

- (void)setDidTapRefreshCompletionHandler:(Block)handler
{
    didTapRefreshCompletionHandler = handler;
}

- (void)setDidTapLastMonthCompletionHandler:(Block)handler
{
    didTapLastMonthCompletionHandler = handler;
}

- (void)setDidTapNextMonthCompletionHandler:(Block)handler
{
    didTapNextMonthCompletionHandler = handler;
}

- (void)configure
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"MMMM y"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    
    self.translatesAutoresizingMaskIntoConstraints = false;
    unsigned unitFlags = kCALayerMinXMinYCorner | kCALayerMaxXMaxYCorner;
    self.layer.maskedCorners = unitFlags;
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.layer.cornerRadius = 15;
}

- (void)configureSeparatorView;
{
    self.separatorView = [[UIView alloc] init];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = false;
    self.separatorView.backgroundColor = UIColor.separatorColor;

    [self addSubview:self.separatorView];
}

- (void)configureMonthLabel
{
    self.monthLabel = [[UILabel alloc] init];
    self.monthLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.monthLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightMedium];

    [self addSubview:self.monthLabel];
}

- (UIButton *)makeButtonFor:(NSString *)systemImageNamed
{
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.tintColor = UIColor.systemBlueColor;
    button.contentMode = UIViewContentModeScaleAspectFill;

    UIImage *leftImage = [UIImage systemImageNamed:systemImageNamed withConfiguration:[UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleLarge]];
    [button setImage:leftImage forState:UIControlStateNormal];
    
    return button;
}

- (void)configurePreviousMonthButton
{
    self.previousMonthButton = [self makeButtonFor:@"chevron.left.circle.fill"];
    [self.previousMonthButton addTarget:self action:@selector(didTapPreviousMonthButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previousMonthButton];
}

- (void)didTapPreviousMonthButton
{
    BlockSafeCall(didTapLastMonthCompletionHandler);
}

- (void)configureNextMonthButton
{
    self.nextMonthButton = [self makeButtonFor:@"chevron.right.circle.fill"];
    [self.nextMonthButton addTarget:self action:@selector(didTapNextMonthButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextMonthButton];
}

- (void)didTapNextMonthButton
{
    BlockSafeCall(didTapNextMonthCompletionHandler);
}

- (void)configureRefreshButton
{
    self.refreshButton = [self makeButtonFor:@"arrow.2.circlepath.circle.fill"];
    [self.refreshButton addTarget:self action:@selector(didTapRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.refreshButton];
}

- (void)didTapRefreshButton
{
    BlockSafeCall(didTapRefreshCompletionHandler);
}

- (void)configureDayOfWeekStackView
{
    self.dayOfWeekStackView = [[UIStackView alloc] init];
    self.dayOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false;
    self.dayOfWeekStackView.distribution = UIStackViewDistributionFillEqually;

    [self addSubview:self.dayOfWeekStackView];
    
    for (NSUInteger index = 1; index <= 7; index++) {
        UILabel *dayLabel = [self makeDayLabelFor:index];
        [self.dayOfWeekStackView addArrangedSubview:dayLabel];
    }
}

- (UILabel *)makeDayLabelFor:(NSInteger)dayNumber
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.secondaryLabelColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    label.text = [self dayOfWeekStringFor:dayNumber];

    return label;
}

- (NSString *)dayOfWeekStringFor:(NSInteger)dayNumber
{
    switch (dayNumber) {
        case 1:
            return @"SUN";
            break;
        case 2:
            return @"MON";
            break;
        case 3:
            return @"TUE";
            break;
        case 4:
            return @"WED";
            break;
        case 5:
            return @"THU";
            break;
        case 6:
            return @"FRI";
            break;
        case 7:
            return @"SAT";
            break;
        default:
            return @"";
            break;
    }
}

@end
