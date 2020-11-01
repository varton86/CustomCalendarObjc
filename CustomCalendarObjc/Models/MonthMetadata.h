//
//  MonthMetadata.h
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 29.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthMetadata : NSObject

@property (nonatomic, strong) NSDate *firstDay;
@property (nonatomic, assign) NSInteger numberOfDays;
@property (nonatomic, assign) NSInteger firstDayWeekday;

@end

NS_ASSUME_NONNULL_END
