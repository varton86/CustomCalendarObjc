//
//  BlockHandlers.h
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 02.11.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

typedef void (^Block)(void);

static inline void BlockSafeCall(Block action)
{
    if( NULL != action )
    {
        action();
    }
}
