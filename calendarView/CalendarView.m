//
//  CalendarView.m
//  JLC
//
//  Created by hyp on 2017/10/12.
//  Copyright © 2017年 金联储. All rights reserved.
//

#import "CalendarView.h"



#define ItemMonthWidth 39.0

//#define GapDistance = 10





//***************************************************//***************************************************
@interface CalendarMonthView:UIView{
    
}
@end
@implementation CalendarMonthView
    
    +(instancetype)calendarMonthViewWithData:(NSArray*)data{
        
        return [[self alloc] initCalendarMonthViewWithData:data];
        
    }
    -(instancetype)initCalendarMonthViewWithData:(NSArray*)data{
        self = [super init];
        if(self){
            
        }
        
        return self;
    }
    
    
    
    
@end

//***************************************************//***************************************************

@interface CalendarView ()
    {
        CGFloat width;
        NSMutableDictionary* dataArr;
        UIScrollView* monthTitleScrollView;
        UIScrollView* calendarContentScrollView;
        CalendarMonthsScrollView* monthScrollView;
        CalendarContentScrollView* _contentView;
        
        UILabel* currentMonthLabel;
        
        NSDateComponents* currentComponents;
        
        NSArray* _monthsDataArr;
        
    }
    
@end

@implementation CalendarView


+(instancetype)calendarViewWithFrame:(CGRect)rect{
    return [[self alloc] initWithcalendarViewWithFrame:rect];
}


-(instancetype)initWithcalendarViewWithFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if(self){
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
        width = rect.size.width;
        dataArr = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.userInteractionEnabled = YES;
        
        [self initData];
        [self initCalendarView];
    }
    
    return self;
}


    
-(void)initCalendarView{
    [self initMonthTitleView];
    [self initCalendarContentView];
    
}

-(void)initMonthTitleView
{
   monthScrollView  = [CalendarMonthsScrollView monthsScrollViewWithFrame:CGRectMake(0, 0, width, ItemMonthWidth) monthsData:dataArr.allKeys currentCompomemts:currentComponents];
    monthScrollView.selectItemMonthCallBack = ^(NSString *year, NSString *month) {
        
    };
    monthScrollView.delegate = self;
    [self addSubview:monthScrollView];
    
}


-(void)initData{
    
    [dataArr removeAllObjects];
    
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    [currentCalendar setFirstWeekday:2];
    NSDate* now = [NSDate date];
    currentComponents = [currentCalendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:now];
    
    NSDateComponents* c1 = [[NSDateComponents alloc] init];
    c1.month = 12;
    NSDateComponents* c2 = [[NSDateComponents alloc] init];
    c2.month = -6;
    NSDate* firstDate = [currentCalendar dateByAddingComponents:c2 toDate:now options:NSCalendarMatchFirst];
    
    NSDate* tempDate = firstDate;
    for(int i = 0;i<19;i++){
        
        
        NSDate* date = [currentCalendar dateByAddingUnit:NSCalendarUnitMonth value:i toDate:tempDate options:NSCalendarMatchFirst];
        
        NSDateComponents* c = [currentCalendar components:NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:date];
        
        
        NSRange range = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        NSInteger days = range.length;
        
        NSMutableArray* arrItems = [[NSMutableArray alloc] initWithCapacity:0];
        
        for(int j = 1;j <= days;j++){
            
            NSDateComponents* tempCom = [[NSDateComponents alloc] init];
            tempCom.month = c.month;
            tempCom.day = j;
            tempCom.year = c.year;
            NSDate* tempDate = [currentCalendar dateFromComponents:tempCom];
            
            
            
            
            NSDateComponents* reslutCom = [currentCalendar components:NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:tempDate];
            

            NSInteger tempWeek = [currentCalendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:tempDate];
            
            
            
            
            ItemModel* item = [[ItemModel alloc] init];
            item.month = reslutCom.month;
            item.day = reslutCom.day;
            item.week = tempWeek;
            item.year = reslutCom.year;
            
            [arrItems addObject:item];
            
        }
        [dataArr setObject:arrItems forKey:[NSString stringWithFormat:@"%ld-%ld",(long)c.year,(long)c.month]];
        
    }
}
    
-(void)initCalendarContentView{
    
    
    _contentView = [CalendarContentScrollView contentViewWithFrame:CGRectMake(0, ItemMonthWidth, ScreenWidth, CGRectGetHeight(self.frame)) data:dataArr];
    _contentView.delegate = self;
    _contentView.selectItemDayCallBack = ^(ItemDayView *itemDayView) {
        NSLog(@"已选择%ld年%ld月%ld日",(long)itemDayView.itemModel.year,(long)itemDayView.itemModel.month,(long)itemDayView.itemModel.day);
    };
    [self addSubview:_contentView];
    
    
    
}

-(void)selectContentWithYear:(NSInteger)year month:(NSInteger)month
{
    [monthScrollView selectItemWithYear:year month:month];
}
-(void)selectMonthViewWithYear:(NSInteger)year month:(NSInteger)month
{
    [_contentView selectYear:year andMonth:month];
}














    
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
