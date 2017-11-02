//
//  CalendarContentScrollView.m
//  JLC
//
//  Created by hyp on 2017/10/19.
//  Copyright © 2017年 金联储. All rights reserved.
//



#import "CalendarContentScrollView.h"
#define ItemDayWidth  26.0
#define LeftEdgeDistance  15.0
#define RightEdgeDistance  15.0

@implementation ItemModel
@end

//***************************************************//***************************************************







@implementation ItemDayView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.originalType = ItemDayViewSelectTypeInit;
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        _label = [[UILabel alloc] init];
        _label.userInteractionEnabled = YES;
        
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:13];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        [self layoutIfNeeded];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTaped:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)setDidSelectBlock:(didSelectedItemView)didSelectBlock
{
    _didSelectBlock = didSelectBlock;
}

-(void)itemTaped:(UITapGestureRecognizer*)tap{
    if (self.didSelectBlock) {
        self.didSelectBlock(self);
    }
}
-(void)setItemModel:(ItemModel *)itemModel
{
    _itemModel = itemModel;
    
    _label.text = [NSString stringWithFormat:@"%ld",(long)itemModel.day];
}
//-(void)setText:(NSString*)text
//{
//    _label.text = text;
//}
-(void)setSelectType:(ItemDayViewSelectType)type{
    
    if (self.originalType == ItemDayViewSelectTypeInit) {
        self.originalType = type;
    }
    
    
     if (type == ItemDayViewSelectTypeNone) {
         if (self.originalType == ItemDayViewSelectTypeProfitGain || self.originalType == ItemDayViewSelectTypePrincipalGain || self.originalType == ItemDayViewSelectTypeCurrentDay) {
       
            type = self.originalType;
        }
    }
    
    switch (type) {
        case ItemDayViewSelectTypeNone:
        {
            _bgImageView.image = nil;
            _label.textColor = [UIColor blackColor];
        }
            break;
        case ItemDayViewSelectTypeSelected:
        {
            _bgImageView.image = [UIImage imageNamed:@"Selected.png"];
            _label.textColor = [UIColor whiteColor];
        }
            break;
        case ItemDayViewSelectTypeCurrentDay:
        {
            _bgImageView.image = [UIImage imageNamed:@"CurrentDay.png"];
            _label.textColor = [UIColor blueColor];
        }
            break;
        case ItemDayViewSelectTypePrincipalGain:
        {
            _bgImageView.image = [UIImage imageNamed:@"PrincipalGain.png"];
            _label.textColor = [UIColor whiteColor];
        }
            break;
        case ItemDayViewSelectTypeProfitGain:
        {
            _bgImageView.image = [UIImage imageNamed:@"ProfitGain.png"];
            _label.textColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
    

    if (type == ItemDayViewSelectTypeSelected) {
        //创建动画对象
        CABasicAnimation *anim = [CABasicAnimation animation];
        //设置属性
        anim.keyPath = @"transform.scale";
        anim.delegate = self;
        //设置属性值
        anim.toValue = @1.2;
        //设置动画的执行次数
        anim.repeatCount = 1;
        //设置动画的执行时长
        anim.duration = 0.06;
        
//        //自动反转
        anim.autoreverses = YES;
        //添加动画
        [self.layer addAnimation:anim forKey:@"firstAnim"];

    }

    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (anim == [self.layer animationForKey:@"firstAnim"]) {
        //创建动画对象
        CABasicAnimation *animatoin = [CABasicAnimation animation];
        //设置属性
        animatoin.keyPath = @"transform.scale";
        //设置属性值
        animatoin.toValue = @0.9;
        //设置动画的执行次数
        animatoin.repeatCount = 1;
        //设置动画的执行时长
        animatoin.duration = 0.06;
        
        //    //自动反转
        animatoin.autoreverses = YES;
        //添加动画
        [self.layer addAnimation:anim forKey:nil];
    }
    
}


@end
//***************************************************//***************************************************
@interface CalendarContentDaysView ()
{
    CGFloat _width;
    CGFloat _leftToRightGap;
    CGFloat _topToBottomGap;
    NSArray* _dataItemsArr;
    
    UIView* _weekTitleView;
    
    
    NSMutableArray* _tempWeekItems;
    
    
    
}

@property(nonatomic,copy)didSelectedItemView didSelectedItemView;

@end
@implementation CalendarContentDaysView

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray<ItemModel*>*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataItemsArr = [[NSMutableArray alloc] initWithArray:data];
        
        
        _tempWeekItems = [[NSMutableArray alloc] initWithCapacity:0];
        _width = frame.size.width;
        
        
        
        
        [self initWeekTitleView];
        [self initContentDays];
    }
    return self;
}


-(void)initWeekTitleView{
    
    [_tempWeekItems removeAllObjects];
    
    _weekTitleView = [[UIView alloc] init];
    [self addSubview:_weekTitleView];
    [_weekTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ItemDayWidth);
    }];
    
    NSArray* weeks = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    
    _leftToRightGap = (_width - LeftEdgeDistance - RightEdgeDistance - weeks.count* ItemDayWidth)/(weeks.count-1);
    _topToBottomGap = 10;
    
    for(int i = 0;i<weeks.count;i++){
        UILabel* weekItem = [[UILabel alloc] init];
        weekItem.text = weeks[i];
        weekItem.font = [UIFont systemFontOfSize:13];
        weekItem.textAlignment = NSTextAlignmentCenter;
        weekItem.tag = i+1;
        [_weekTitleView addSubview:weekItem];
        weekItem.frame = CGRectMake(LeftEdgeDistance + _leftToRightGap*i + ItemDayWidth*i ,_topToBottomGap, ItemDayWidth, ItemDayWidth);

        
        [_tempWeekItems addObject:weekItem];
    }
}

-(void)initContentDays
{
    
    UIView* contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(_weekTitleView.mas_bottom).offset(_topToBottomGap);
    }];
    ItemModel* item = [_dataItemsArr objectAtIndex:0];
    
    NSInteger diff = item.week - item.day;
    
    ItemDayView* tempLabForFrame = nil;
    
    for (int i = 0; i<_dataItemsArr.count; i++) {
        ItemModel* item = [_dataItemsArr objectAtIndex:i];
        NSInteger row = (item.day-1 + diff)/7;
        NSInteger line = item.week;
        
        
        
        
        ItemDayView* itemView = [[ItemDayView alloc] initWithFrame:CGRectMake(LeftEdgeDistance + (line-1)*_leftToRightGap + line*ItemDayWidth, _topToBottomGap + (row - 1)*_topToBottomGap + row*ItemDayWidth, ItemDayWidth, ItemDayWidth)];
        itemView.itemModel = item;
        [contentView addSubview:itemView];
        [itemView setSelectType:(i+1)%10];
        [itemView setDidSelectBlock:^(ItemDayView *itemView) {
            if (self.didSelectedItemView) {
                self.didSelectedItemView(itemView);
            }
        }];
        
        UILabel* weekLab = (UILabel*)[_tempWeekItems objectAtIndex:item.week-1];
        CGPoint center = itemView.center;
        center.x = weekLab.center.x;
        itemView.center = center;
        
        tempLabForFrame = itemView;
        
    }
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tempLabForFrame.mas_bottom).offset(10);
    }];
    
    
    [self layoutIfNeeded];
    
    
}






@end

//***************************************************//***************************************************


@implementation CalendarContentScrollView
+(instancetype)contentViewWithFrame:(CGRect)rect data:(NSDictionary*)data{
    return [[self alloc] initContentViewWithFrame:rect data:data];
}
-(instancetype)initContentViewWithFrame:(CGRect)rect data:(NSDictionary*)data{
    self = [super initWithFrame:rect];
    if (self) {
        _dataDic = [[NSDictionary alloc] initWithDictionary:data];
        _width = rect.size.width;
        
        
        _currentSelectView = nil;
        _preSelectView = nil;
        
        [self initBackgroundViewWithFrame:rect];
        
        [self initScrollViewWithFrame:rect data:data];
        
    }
    return self;
}

-(void)initBackgroundViewWithFrame:(CGRect)frame{
    UIImage* img = [UIImage imageNamed:@"calendarBG"];
    
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:50 topCapHeight:5]];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(self);
    }];
    [self layoutIfNeeded];
}

-(void)initScrollViewWithFrame:(CGRect)rect data:(NSDictionary*)data
{
    CGRect c = rect;
    c.origin.y = 0;
    _mainScrollView = [[UIScrollView alloc] initWithFrame:c];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(_width * data.count, CGRectGetHeight(rect));
    [self addSubview:_mainScrollView];
    
    NSArray* keys = [self sortArray:data.allKeys];
    
    
    for (int i=0; i<keys.count; i++) {
        
        CalendarContentDaysView* itemView = [[CalendarContentDaysView alloc] initWithFrame:CGRectMake(i*_width, 0, _width, CGRectGetHeight(rect)) items:[data valueForKey:[keys objectAtIndex:i]]];
        itemView.tag = i;
        itemView.didSelectedItemView = ^(ItemDayView *itemView) {
            
            //点击当前的itemView 会把之前的itemview 恢复到原来状态
            _preSelectView = _currentSelectView;
            _currentSelectView = itemView;
            [_preSelectView setSelectType:ItemDayViewSelectTypeNone];
            [_currentSelectView setSelectType:ItemDayViewSelectTypeSelected];
            
            
            //点击itemView通过block回调
            if (self.selectItemDayCallBack) {
                self.selectItemDayCallBack(itemView);
            }
            
            
        };
        [_mainScrollView addSubview:itemView];
        
    }
    
    
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

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray* keys = [self sortArray:_dataDic.allKeys];
    NSInteger index = floorf(scrollView.contentOffset.x / _width);
    NSString* yearAndMonth = [keys objectAtIndex:index];
    NSArray* a = [yearAndMonth componentsSeparatedByString:@"-"];
    NSString* year = (NSString*)a.firstObject;
    NSString* month = (NSString*)a.lastObject;
    
    //用于dayView和monthView的互动
    if ([self.delegate respondsToSelector:@selector(selectContentWithYear:month:)]) {
        [self.delegate selectContentWithYear:year.integerValue month:month.integerValue];
    }
    
}
-(void)selectYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSArray* keys = [self sortArray:_dataDic.allKeys];
    NSString* str = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)month];
    NSInteger index = [keys indexOfObject:str];
    
    [_mainScrollView setContentOffset:CGPointMake(_width*index, _mainScrollView.contentOffset.y) animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
