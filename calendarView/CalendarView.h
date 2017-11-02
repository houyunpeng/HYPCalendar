//
//  CalendarView.h
//  JLC
//
//  Created by hyp on 2017/10/12.
//  Copyright © 2017年 金联储. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonthsScrollView.h"
#import "CalendarContentScrollView.h"
#import "Calendar.h"
@protocol CalendarContentScrollViewDelegate;
@protocol CalendarMonthsScrollViewDelegate;


@interface CalendarView : UIView <UIScrollViewDelegate,CalendarContentScrollViewDelegate,CalendarMonthsScrollViewDelegate>

    
+(instancetype)calendarViewWithFrame:(CGRect)rect;
@end
