//
//  CalendarPickerFooterView.h
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 01.11.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockHandlers.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarPickerFooterView : UIView

- (void)setDidTapStartDateCompletionHandler:(Block)handler;
- (void)setDidTapEndDateCompletionHandler:(Block)handler;

@end

NS_ASSUME_NONNULL_END
