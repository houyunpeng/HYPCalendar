//
//  CalendarContentScrollView.h
//  JLC
//
//  Created by hyp on 2017/10/19.
//  Copyright © 2017年 金联储. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calendar.h"
//***************************************************//***************************************************
@interface ItemModel:NSObject

@property(nonatomic,assign)NSInteger month;
@property(nonatomic,assign)NSInteger day;
@property(nonatomic,assign)NSInteger week;
@property(nonatomic,assign)NSInteger year;

@end

//***************************************************//***************************************************
@class ItemDayView;


typedef enum : NSUInteger {
    ItemDayViewSelectTypeInit = 0,
    ItemDayViewSelectTypeNone,               //未选中状态
    ItemDayViewSelectTypeSelected,           //选中状态
    ItemDayViewSelectTypeCurrentDay,             //当天状态
    ItemDayViewSelectTypePrincipalGain,          //有本金回款
    ItemDayViewSelectTypeProfitGain,             //只有收益，没有本金
} ItemDayViewSelectType;



typedef void(^didSelectedItemView)(ItemDayView*itemView);



@interface ItemDayView : UIView<CAAnimationDelegate>
{
    UILabel* _label;
    UIImageView* _bgImageView;
    
    
    
}
@property(nonatomic,assign)ItemDayViewSelectType originalType;
@property(nonatomic,copy)didSelectedItemView didSelectBlock;
@property(nonatomic, strong)ItemModel* itemModel;
@end
//***************************************************//***************************************************




@interface CalendarContentDaysView : UIView



@end


//***************************************************//***************************************************






typedef void(^DidSelectItemDayCallBack)(ItemDayView* itemDayView);//选择天的回调


@interface CalendarContentScrollView : UIView<UIScrollViewDelegate>
{
    CGFloat _width;
    UIScrollView* _mainScrollView;
    NSDictionary* _dataDic;
    
    
    ItemDayView* _currentSelectView;
    ItemDayView* _preSelectView;
}
@property(nonatomic,assign)id delegate;

@property(nonatomic,copy)DidSelectItemDayCallBack selectItemDayCallBack;

+(instancetype)contentViewWithFrame:(CGRect)rect data:(NSDictionary*)data;

-(void)selectYear:(NSInteger)year andMonth:(NSInteger)month;

@end
