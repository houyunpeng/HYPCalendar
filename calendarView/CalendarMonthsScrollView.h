//
//  CalendarMonthsScrollView.h
//  JLC
//
//  Created by hyp on 2017/10/18.
//  Copyright © 2017年 金联储. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Calendar.h"
typedef void(^DidSelectItemMonthCallBack)(NSString* year,NSString* month);//选择月份的回调



@interface CalendarMonthsScrollView : UIView
{
    NSArray* _monthsData;
    UIScrollView* _monthTitleScrollView;
    UILabel* _currentMonthLabel;
    NSDateComponents* _currentComponents;
    
    CGFloat _viewWidth;
    
    
    
    NSMutableArray* _tempMonthsArr;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,copy)DidSelectItemMonthCallBack selectItemMonthCallBack;


+(instancetype)monthsScrollViewWithFrame:(CGRect)rect monthsData:(NSArray*)monthsData currentCompomemts:(NSDateComponents*)com;


-(void)selectItemWithYear:(NSInteger)year month:(NSInteger)month;
-(void)selectItemWithTag:(NSInteger)tag;
@end
@protocol CalendarMonthsScrollViewDelegate
-(void)selectMonthViewWithYear:(NSInteger)year month:(NSInteger)month;


@end
