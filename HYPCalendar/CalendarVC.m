//
//  CalendarVC.m
//  JLC
//
//  Created by hyp on 2017/10/12.
//  Copyright © 2017年 金联储. All rights reserved.
//

#import "CalendarVC.h"
#import "CalendarView.h"
@interface CalendarVC ()

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.userInteractionEnabled = YES;
    CalendarView* calendarView = [CalendarView calendarViewWithFrame:CGRectMake(0, 0, ScreenWidth, 235)];
    [self.view addSubview:calendarView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"回款日历";
    [self setNavigationBar];
    
}

-(void)setNavigationBar
    {
        [self.navigationController.navigationBar setBackgroundImage:[self imageFromColor:DefaultBlueColor frame:CGRectMake( 0, 0, ScreenWidth,64)] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        
    }
    
- (UIImage *)imageFromColor:(UIColor *)color frame:(CGRect)frame{
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
