//
//  CalendarPickerCell.h
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 27.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDateCollectionViewCell.h"
#import "MonthMetadata.h"
#import "Day.h"
#import "CalendarPickerHeaderView.h"
#import "CalendarPickerFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarPickerCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

NS_ASSUME_NONNULL_END
