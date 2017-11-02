//
//  CalendarMonthsScrollView.m
//  JLC
//
//  Created by hyp on 2017/10/18.
//  Copyright © 2017年 金联储. All rights reserved.
//


#define ItemMonthWidth 39.0

#import "CalendarMonthsScrollView.h"

@implementation CalendarMonthsScrollView


+(instancetype)monthsScrollViewWithFrame:(CGRect)rect monthsData:(NSArray*)monthsData currentCompomemts:(NSDateComponents *)com{
    return [[self alloc] initMonthsScrollViewWithFrame:rect monthsData:monthsData currentCompomemts:com];
}
-(instancetype)initMonthsScrollViewWithFrame:(CGRect)rect monthsData:(NSArray*)monthsData currentCompomemts:(NSDateComponents*)com;{
    self = [super initWithFrame:rect];
    if (self) {
        _monthsData = [[NSArray alloc] initWithArray:monthsData];
        _tempMonthsArr = [[NSMutableArray alloc] initWithCapacity:0];
        _currentComponents = com;
        _viewWidth = CGRectGetWidth(rect);
        [self initMonthTitleView];
    }
    return self;
}
-(void)initMonthTitleView
{
    UIView* monthBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, ItemMonthWidth)];
    monthBGView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:1];
    monthBGView.userInteractionEnabled = YES;
    [self addSubview:monthBGView];
    [monthBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self);
        make.height.mas_equalTo(ItemMonthWidth);
    }];
    _currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, ItemMonthWidth)];
    _currentMonthLabel.text = [NSString stringWithFormat:@"%ld年",(long)_currentComponents.year];
    _currentMonthLabel.textColor = [UIColor whiteColor];
    [self addSubview:_currentMonthLabel];
//    [currentMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(monthBGView);
//        make.left.equalTo(monthBGView.mas_left).offset(15);
//    }];
    
    _monthTitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15+60+10, 0, _viewWidth - (15+60+10), ItemMonthWidth)];
    _monthTitleScrollView.showsVerticalScrollIndicator = NO;
    _monthTitleScrollView.showsHorizontalScrollIndicator = NO;
    NSInteger items = _monthsData.count;
    _monthTitleScrollView.contentSize = CGSizeMake(items*ItemMonthWidth, 0);
//    __weak CalendarMonthsScrollView* self_weak = self;
    _monthTitleScrollView.delegate = self;
    _monthTitleScrollView.scrollEnabled = YES;
    _monthTitleScrollView.userInteractionEnabled = YES;
    [self addSubview:_monthTitleScrollView];
    
    
    
    
//    [monthTitleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(currentMonthLabel.mas_right);
//        make.top.bottom.equalTo(monthBGView);
//        make.right.equalTo(monthBGView.mas_right).offset(-15);
//    }];
    NSArray* tempArr = [self sortArray:_monthsData];
    
    [_tempMonthsArr removeAllObjects];;
    
    for (int i = 0 ;i < tempArr.count;i++) {
        
        NSString* itemMonth = [tempArr objectAtIndex:i];
        NSArray* t = [itemMonth componentsSeparatedByString:@"-"];
        
        UILabel* monthLabItem = [[UILabel alloc] initWithFrame:CGRectMake(ItemMonthWidth * i, 0, ItemMonthWidth, ItemMonthWidth)];
        monthLabItem.font = [UIFont systemFontOfSize:14];
        monthLabItem.tag = i;
        monthLabItem.textAlignment = NSTextAlignmentCenter;
        monthLabItem.textColor = [UIColor whiteColor];
        [_monthTitleScrollView addSubview:monthLabItem];
        monthLabItem.text = [NSString stringWithFormat:@"%@月",t.lastObject];
        monthLabItem.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthItemTap:)];
        [monthLabItem addGestureRecognizer:tap];
        
        [_tempMonthsArr addObject:monthLabItem];
    }
    
    
    NSString* text = [NSString stringWithFormat:@"%ld-%ld",(long)_currentComponents.year,(long)_currentComponents.month];
 
    
    [self selectItemWithTag:[_monthsData indexOfObject:text]];
    
}

-(NSArray*)sortArray:(NSArray*)tempArr
{
    NSArray* keys = tempArr;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* s1 = (NSString*)obj1;
        NSString* s2 = (NSString*)obj2;
        
        if (s1.length == 6) {
            s1 = [s1 stringByReplacingOccurrencesOfString:@"-" withString:@"0"];
        }else if (s1.length == 7){
            s1 = [s1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        if (s2.length == 6) {
            s2 = [s2 stringByReplacingOccurrencesOfString:@"-" withString:@"0"];
        }else if (s2.length == 7){
            s2 = [s2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        NSComparisonResult result = [s1 compare:s2];
        return result;
    }];
    
    return keys;
}


#pragma mark - 点击monthView事件
-(void)monthItemTap:(UITapGestureRecognizer*)tap
{
    UILabel* l = (UILabel*)tap.view;
    NSInteger tag = l.tag;
    
    [self selectItemWithTag:tag];
    
    NSArray* tempArr = [self sortArray:_monthsData];
    NSString* t = [tempArr objectAtIndex:tag];
    NSArray* a = [t componentsSeparatedByString:@"-"];
    NSString* year = (NSString*)a.firstObject;
    NSString* month = (NSString*)a.lastObject;
    
    _currentMonthLabel.text = [NSString stringWithFormat:@"%@年",year];
    
    //点击月份的对内回调  用于monthView和dayView的互动
    if ([self.delegate respondsToSelector:@selector(selectMonthViewWithYear:month:)]) {
        [self.delegate selectMonthViewWithYear:year.integerValue month:month.integerValue];
    }
    
    //点击月份的对外回调
    if (self.selectItemMonthCallBack) {
        self.selectItemMonthCallBack(year, month);
    }
    
    
//    [monthTitleScrollView scrollRectToVisible:l.frame animated:YES];
    
}


#pragma 标签从0开始
-(void)selectItemWithTag:(NSInteger)tag
{
    UILabel* selectLab = nil;
    for (int i = 0; i<_tempMonthsArr.count; i++) {
        UILabel* tempL = (UILabel*)[_tempMonthsArr objectAtIndex:i];
        tempL.textColor = [UIColor whiteColor];
        tempL.layer.cornerRadius = ItemMonthWidth/2;
        tempL.backgroundColor = [UIColor blueColor];
        tempL.clipsToBounds = YES;
        if (tempL.tag == tag) {
            tempL.textColor = [UIColor blueColor];
            tempL.layer.cornerRadius = ItemMonthWidth/2;
            tempL.backgroundColor = [UIColor whiteColor];
            selectLab = tempL;
        }
    }
    CGPoint point = CGPointMake(_viewWidth - CGRectGetWidth(_monthTitleScrollView.frame)/2, 0);
    
    CGPoint offset = _monthTitleScrollView.contentOffset;
    
    CGPoint toOffset = CGPointMake(offset.x + (selectLab.center.x-offset.x+CGRectGetMinX(_monthTitleScrollView.frame)-point.x), offset.y);
    if (toOffset.x >= 412) {
        toOffset.x = 412;
    }else if (toOffset.x <= 0){
        toOffset.x = 0;
    }
    
    [_monthTitleScrollView setContentOffset:toOffset animated:YES];
}

-(void)selectItemWithYear:(NSInteger)year month:(NSInteger)month
{
    NSString* t = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)month];
    
    NSArray* tempArr = [self sortArray:_monthsData];
    
    NSInteger tag = [tempArr indexOfObject:t];
    
    [self selectItemWithTag:tag];
    _currentMonthLabel.text = [NSString stringWithFormat:@"%ld年",(long)year];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}



-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
