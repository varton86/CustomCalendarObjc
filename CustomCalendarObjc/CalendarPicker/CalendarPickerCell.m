//
//  CalendarPickerCell.m
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 27.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import "CalendarPickerCell.h"

@interface CalendarPickerCell ()
    
@property (strong, nonatomic) CalendarPickerHeaderView *headerView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CalendarPickerFooterView *footerView;

@end

@implementation CalendarPickerCell
{
    NSCalendar *calendar;
    BOOL startDate;
    NSDate *baseDate;
    NSDate *startSelectedDate;
    NSDate *endSelectedDate;
    NSDateFormatter *dateFormatter;
    
    NSArray<Day *> *days;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    [self configure];
    [self configureCollectionView];
    [self configureHeaderView];
    [self configureFooterView];

    return self;
}

- (void)configure
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    startDate = true;
    baseDate = [calendar startOfDayForDate:[NSDate date]];
    startSelectedDate = baseDate;
    endSelectedDate = baseDate;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    
    days = [self generateDaysInMonthFor:baseDate];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [NSLayoutConstraint deactivateConstraints:self.headerView.constraints];
    [NSLayoutConstraint deactivateConstraints:self.collectionView.constraints];
    [NSLayoutConstraint deactivateConstraints:self.footerView.constraints];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerView.heightAnchor constraintEqualToConstant:90],
        
        [self.collectionView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:5],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.heightAnchor constraintEqualToConstant:295],
        
        [self.footerView.topAnchor constraintEqualToAnchor:self.collectionView.bottomAnchor constant:10],
        [self.footerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.footerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.footerView.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)traitCollectionDidChange:(UITraitCollection *) previousTraitCollection
{
    [super traitCollectionDidChange: previousTraitCollection];
    if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
        || (self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)) {

        [self.collectionView reloadData];
        [self layoutSubviews];
    }
}

- (void)configureHeaderView
{
    self.headerView = [[CalendarPickerHeaderView alloc] init];
    self.headerView.backgroundColor = self.backgroundColor;
    [self.headerView setFor:baseDate];
    __auto_type __weak weakSelf = self;
    [self.headerView setDidTapRefreshCompletionHandler:^(void)
    {
        __auto_type __strong strongSelf = weakSelf;
        NSDate * date = [strongSelf->calendar startOfDayForDate:[NSDate date]];
        strongSelf->startSelectedDate = date;
        strongSelf->endSelectedDate = date;
        strongSelf->baseDate = date;
        [strongSelf setBase:date];
    }];
    [self.headerView setDidTapLastMonthCompletionHandler:^(void)
    {
        __auto_type __strong strongSelf = weakSelf;
        NSDate *date = [strongSelf->calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:strongSelf->baseDate options:NSCalendarMatchStrictly];
        strongSelf->baseDate = date;
        [strongSelf setBase:date];
    }];
    [self.headerView setDidTapNextMonthCompletionHandler:^(void)
    {
        __auto_type __strong strongSelf = weakSelf;
        NSDate *date = [strongSelf->calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:strongSelf->baseDate options:NSCalendarMatchStrictly];
        strongSelf->baseDate = date;
        [strongSelf setBase:date];
    }];
    [self addSubview:self.headerView];
}

- (void)configureFooterView
{
    self.footerView = [[CalendarPickerFooterView alloc] init];
    self.footerView.backgroundColor = self.backgroundColor;
    __auto_type __weak weakSelf = self;
    [self.footerView setDidTapStartDateCompletionHandler:^(void)
    {
        __auto_type __strong strongSelf = weakSelf;
        strongSelf->startDate = true;
    }];
    [self.footerView setDidTapEndDateCompletionHandler:^(void)
    {
        __auto_type __strong strongSelf = weakSelf;
        strongSelf->startDate = false;
    }];
    [self addSubview:self.footerView];
}

- (void)configureCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = self.backgroundColor;
    [self.collectionView setScrollEnabled:false];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerClass:[CalendarDateCollectionViewCell self] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self addSubview:self.collectionView];
}

- (void)setBase:(NSDate *)date
{
    baseDate = date;
    days = [self generateDaysInMonthFor:baseDate];
    [self.collectionView reloadData];
    [self.headerView setFor:baseDate];
}

- (MonthMetadata *)monthMetadataFor:(NSDate *)baseDate
{
    NSInteger numberOfDaysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:baseDate].length;
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDate *firstDayOfMonth = [calendar dateFromComponents:[calendar components:unitFlags fromDate:baseDate]];
    NSInteger firstDayWeekday = [calendar component:NSCalendarUnitWeekday fromDate:firstDayOfMonth];

    MonthMetadata *monthMetadata = [[MonthMetadata alloc] init];
    monthMetadata.numberOfDays = numberOfDaysInMonth;
    monthMetadata.firstDay = firstDayOfMonth;
    monthMetadata.firstDayWeekday = firstDayWeekday;

    return monthMetadata;
}

- (Day *)generateDayOffsetBy:(NSInteger)dayOffset forBaseDate:(NSDate *)baseDate isWithinDisplayedMonth:(BOOL)isWithinDisplayedMonth
{
    NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitDay value:dayOffset toDate:baseDate options:NSCalendarMatchStrictly];
    
    Day *day = [[Day alloc] init];
    day.date = date;
    day.number = [dateFormatter stringFromDate:date];
    day.isSelected = ([date compare: startSelectedDate] == NSOrderedDescending || [date compare: startSelectedDate] == NSOrderedSame) &&
    ([date compare: endSelectedDate] == NSOrderedAscending || [date compare: endSelectedDate] == NSOrderedSame);
    day.isWithinDisplayedMonth = isWithinDisplayedMonth;

    return day;
}

- (NSArray<Day *> *)generateStartOfNextMonthUsing:(NSDate *)firstDayOfDisplayedMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    dateComponents.month = 1;
    
    NSDate *lastDayInMonth = [calendar dateByAddingComponents:dateComponents toDate:firstDayOfDisplayedMonth options:NSCalendarMatchStrictly];
    NSInteger additionalDays = 7 - [calendar component:NSCalendarUnitWeekday fromDate:lastDayInMonth];
    NSMutableArray *days = [[NSMutableArray alloc] init];
    if (additionalDays <= 0)
    {
        return days;
    }

    for (NSUInteger index = 1; index <= additionalDays; index++)
    {
        Day *day = [self generateDayOffsetBy:index forBaseDate:lastDayInMonth isWithinDisplayedMonth:false];
        [days addObject:day];
    }

    return days;
}

- (NSArray<Day *> *)generateDaysInMonthFor:(NSDate *)baseDate
{
    MonthMetadata *metadata = [self monthMetadataFor:baseDate];

    NSInteger numberOfDaysInMonth = metadata.numberOfDays;
    NSInteger offsetInInitialRow = metadata.firstDayWeekday;
    NSDate *firstDayOfMonth = metadata.firstDay;
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (NSUInteger index = 1; index < (numberOfDaysInMonth + offsetInInitialRow); index++)
    {
        BOOL isWithinDisplayedMonth = index >= offsetInInitialRow;
        NSInteger dayOffset = isWithinDisplayedMonth ? index - offsetInInitialRow : -(offsetInInitialRow - index);
        
        [days addObject:[self generateDayOffsetBy:dayOffset forBaseDate:firstDayOfMonth isWithinDisplayedMonth:isWithinDisplayedMonth]];
    }

    [days addObjectsFromArray:[self generateStartOfNextMonthUsing:firstDayOfMonth]];
    return days;
}

- (void)selectedDateChangedFor:(NSDate *)date
{
    if (startDate)
    {
        startSelectedDate = date;
        endSelectedDate = date;
    }
    else
    {
        if ([date compare: startSelectedDate] == NSOrderedDescending || [date compare: startSelectedDate] == NSOrderedSame)
        {
            endSelectedDate = date;
        }
        else if ([date compare: startSelectedDate] == NSOrderedAscending)
        {
            startSelectedDate = date;
        }
    }
    
    days = [self generateDaysInMonthFor:baseDate];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfWeeksInBaseDate
{
    NSInteger result = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:baseDate].length;
    
    return result;
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return days.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = days[indexPath.row];
    
    CalendarDateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    [cell configureWith:day];
    return cell;
}

// MARK: - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Day *day = days[indexPath.row];
    [self selectedDateChangedFor:day.date];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = (collectionView.frame.size.width / 7);
    NSInteger height = (collectionView.frame.size.height) / [self numberOfWeeksInBaseDate];
    
    return CGSizeMake(width, height);
}

@end

