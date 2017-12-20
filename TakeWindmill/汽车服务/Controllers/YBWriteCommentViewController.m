//
//  YBWriteCommentViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/29.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBWriteCommentViewController.h"
#import "LEEStarRating.h"

@interface YBWriteCommentViewController ()
@property (weak, nonatomic) IBOutlet UIView *bacgrouView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *textImageView;
@property (nonatomic, strong) NSString *starsStr;

@end

@implementation YBWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [self addStarCountWithCount:@"5" andEnable:YES];
    
    [self.commentTextView sendSubviewToBack:self.textImageView];
}


- (void)addStarCountWithCount:(NSString *)count andEnable:(BOOL )enable
{
    LEEStarRating *ratingView = [[LEEStarRating alloc] initWithFrame:CGRectMake(YBWidth/2 - 60, 71, 120, 60) Count:5]; //初始化并设置frame和个数
    
    ratingView.spacing = 1.0f; //间距
    ratingView.checkedImage = [UIImage imageNamed:@"star_orange"]; //选中图片
    ratingView.uncheckedImage = [UIImage imageNamed:@"game_evaluate_gray"]; //未选中图片
    ratingView.type = RatingTypeWhole; //评分类型
    ratingView.touchEnabled = enable; //是否启用点击评分 如果纯为展示则不需要设置
    ratingView.slideEnabled = NO; //是否启用滑动评分 如果纯为展示则不需要设置
    ratingView.maximumScore = 5.0f; //最大分数
    ratingView.minimumScore = 0.0f; //最小分数
    ratingView.currentScore = [count intValue];
    
    [ratingView setCurrentScoreChangeBlock:^(CGFloat currentScore) {
        self.starsStr = [NSString stringWithFormat:@"%f",currentScore];
    }];

    [self.bacgrouView addSubview:ratingView];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)upLoadCommentAction:(UIButton *)sender {
    [self uploadCommentDetailsWith:self.commentTextView.text];
}


- (void)uploadCommentDetailsWith:(NSString *)comment
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"shopsysno"] = [NSString stringWithFormat:@"%@",self.sysNum];
    dict[@"commnentcontent"] = comment;
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    dict[@"stars"] = self.starsStr;
    
//    NSLog(@"comment - %@",dict);
    [YBRequest postWithURL:CommentUpload MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSString *errorMe = dic[@"ErrorMessage"];
        NSLog(@"errorMe - %@",errorMe);
        if (errorMe.length > 0) {
            [MBProgressHUD showError:@"请先打电话" toView:self.view];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.labelText = @"评论成功";
            [hud hide:YES afterDelay:0.5];
        }
//        NSLog(@"comment - %@",dataArray);
    } failure:^(id dataArray) {
        
    }];
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
