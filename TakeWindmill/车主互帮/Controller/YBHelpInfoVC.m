//
//  YBHelpInfoVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/24.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBHelpInfoVC.h"
#import "YBHelpWithMeVC.h"
#import "YBMyHelpVC.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define pageMenuH 40
#define NaviH (screenH == 812 ? 88 : 64) // 812是iPhoneX的高度
//#define scrollViewHeight (screenH-88-pageMenuH)
#define scrollViewHeight (screenH-NaviH-pageMenuH)

@interface YBHelpInfoVC ()<SPPageMenuDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@end

@implementation YBHelpInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"求助信息";
    
    self.myChildViewControllers = [NSMutableArray array];
    [self setUI];
   
}

-(void)setUI{
    self.dataArr = @[@"求助与我",@"我的求助"];
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, screenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    // 不可滑动的等宽排列
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    // 设置代理
    pageMenu.delegate = self;
    pageMenu.selectedItemTitleColor = BtnBlueColor;
    pageMenu.unSelectedItemTitleColor = kTextGreyColor;
    pageMenu.tracker.backgroundColor = BtnBlueColor;
    //pageMenu.dividingLine.backgroundColor = BtnBlueColor;
    //pageMenu.dividingLine.hidden = YES;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"YBHelpWithMeVC",@"YBMyHelpVC", nil];
    for (int i = 0; i < self.dataArr.count; i++) {
        if (controllerClassNames.count > i) {
            UIViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            [self addChildViewController:baseVc];
            // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
            [self.myChildViewControllers addObject:baseVc];
        }
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,pageMenuH, screenW, scrollViewHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        UIViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, scrollViewHeight);
        scrollView.contentOffset = CGPointMake(screenW*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.dataArr.count*screenW, 0);
    }
}
#pragma mark ==SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton{
    // NSLog(@"%zd",index);
}
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
      NSLog(@"%zd------->%zd",fromIndex,toIndex);
    
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]){

        return;
    }
    
    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

#pragma mark - scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
//    // [self.pageMenu moveTrackerFollowScrollView:scrollView];
//}

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
