//
//  CalendarProtocol.h
//  HYPCalendar
//
//  Created by hyp on 2017/11/2.
//  Copyright © 2017年 hyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CalendarMonthsScrollViewDelegate<NSObject>
-(void)selectMonthViewWithYear:(NSInteger)year month:(NSInteger)month;
@end


@protocol CalendarContentScrollViewDelegate<NSObject>
-(void)selectContentWithYear:(NSInteger)year month:(NSInteger)month;
@end
