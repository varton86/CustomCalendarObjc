//
//  CalendarPickerFooterView.m
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 01.11.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import "CalendarPickerFooterView.h"

@interface CalendarPickerFooterView ()
    
@property (strong, nonatomic) UIStackView *buttonStackView;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *endButton;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIView *splitView;

@end

@implementation CalendarPickerFooterView
{
    Block didTapStartDateCompletionHandler;
    Block didTapEndDateCompletionHandler;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    
    [self configure];
    [self configureButtonStackView];
    [self configureStartButton];
    [self configureEndButton];
    [self configureSeparatorView];
    [self configureSplitView];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [NSLayoutConstraint activateConstraints:@[
        [self.separatorView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.separatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.separatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.separatorView.heightAnchor constraintEqualToConstant:0.5],

        [self.buttonStackView.topAnchor constraintEqualToAnchor:self.separatorView.bottomAnchor],
        [self.buttonStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.buttonStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.buttonStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [self.splitView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.splitView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.splitView.heightAnchor constraintEqualToConstant:self.bounds.size.height],
        [self.splitView.widthAnchor constraintEqualToConstant:0.5]
    ]];
}

- (void)configureButtonStackView
{
    self.buttonStackView = [[UIStackView alloc] init];
    self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false;
    self.buttonStackView.distribution = UIStackViewDistributionFillEqually;

    [self addSubview:self.buttonStackView];
}

- (void)configureStartButton
{
    self.startButton = [self makeButton];
    NSAttributedString *buttonTitle = [ self makeAttributedTitleFor:@" Start Date" systemImageNamed:@"smallcircle.fill.circle"];
    [self.startButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(didTapStartDate) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonStackView addArrangedSubview:self.startButton];
}

- (void)setDidTapStartDateCompletionHandler:(Block)handler
{
    didTapStartDateCompletionHandler = handler;
}

- (void)didTapStartDate
{
    NSAttributedString *startButtonTitle = [ self makeAttributedTitleFor:@" Start Date" systemImageNamed:@"smallcircle.fill.circle"];
    [self.startButton setAttributedTitle:startButtonTitle forState:UIControlStateNormal];

    NSAttributedString *endButtonTitle = [ self makeAttributedTitleFor:@" End Date" systemImageNamed:@"circle"];
    [self.endButton setAttributedTitle:endButtonTitle forState:UIControlStateNormal];

    BlockSafeCall(didTapStartDateCompletionHandler);
}

- (void)configureEndButton
{
    self.endButton = [self makeButton];
    NSAttributedString *buttonTitle = [ self makeAttributedTitleFor:@" End Date" systemImageNamed:@"circle"];
    [self.endButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    [self.endButton addTarget:self action:@selector(didTapEndDate) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonStackView addArrangedSubview:self.endButton];
}

- (void)setDidTapEndDateCompletionHandler:(Block)handler
{
    didTapEndDateCompletionHandler = handler;
}

- (void)didTapEndDate
{
    NSAttributedString *startButtonTitle = [ self makeAttributedTitleFor:@" Start Date" systemImageNamed:@"circle"];
    [self.startButton setAttributedTitle:startButtonTitle forState:UIControlStateNormal];

    NSAttributedString *endButtonTitle = [ self makeAttributedTitleFor:@" End Date" systemImageNamed:@"smallcircle.fill.circle"];
    [self.endButton setAttributedTitle:endButtonTitle forState:UIControlStateNormal];

    BlockSafeCall(didTapEndDateCompletionHandler);
}

- (void)configure
{
    self.translatesAutoresizingMaskIntoConstraints = false;
    unsigned unitFlags = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    self.layer.maskedCorners = unitFlags;
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.layer.cornerRadius = 15;
}

- (void)configureSeparatorView;
{
    self.separatorView = [[UIView alloc] init];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = false;
    self.separatorView.backgroundColor = UIColor.blackColor;

    [self addSubview:self.separatorView];
}

- (void)configureSplitView;
{
    self.splitView = [[UIView alloc] init];
    self.splitView.translatesAutoresizingMaskIntoConstraints = false;
    self.splitView.backgroundColor = UIColor.blackColor;

    [self addSubview:self.splitView];
}

- (UIButton *)makeButton
{
    BOOL smallDevice = UIScreen.mainScreen.bounds.size.width <= 350;
    CGFloat fontPointSize = smallDevice ? 14 : 17;

    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.titleLabel.font = [UIFont systemFontOfSize:fontPointSize weight:UIFontWeightMedium];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.textColor = UIColor.systemBlueColor;
    
    return button;
}

- (NSMutableAttributedString *)makeAttributedTitleFor:(NSString *)title systemImageNamed:(NSString *)systemImageNamed
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    UIImage *chevronImage = [UIImage systemImageNamed:systemImageNamed withConfiguration:[UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleLarge]];
    NSTextAttachment *imageAttachment = [NSTextAttachment textAttachmentWithImage:chevronImage];
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:imageAttachment]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:title]];

    return attributedString;
}

@end
