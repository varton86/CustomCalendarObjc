//
//  CalendarDateCollectionViewCell.h
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 27.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarDateCollectionViewCell : UICollectionViewCell

- (void)configureWith:(Day *)day;

@end

NS_ASSUME_NONNULL_END
