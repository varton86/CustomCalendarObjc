//
//  Day.h
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 29.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Day : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isWithinDisplayedMonth;

@end

NS_ASSUME_NONNULL_END
