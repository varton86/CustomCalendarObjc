//
//  ViewController.m
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 27.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController
{
    NSString *cellIdentifier;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleInsetGrouped];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI
{
    cellIdentifier = @"CellIdentifier";
    self.title = @"Custom Calendar";
    [self.tableView registerClass:[CalendarPickerCell self] forCellReuseIdentifier:cellIdentifier];
    self.tableView.rowHeight = 450;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Dates";
}

@end
