//
//  YBCommentsViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/24.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCommentsViewController.h"
#import "YBCommentTableViewCell.h"
#import "YBTechnicianModel.h"
#import "YBCommentModels.h"

@interface YBCommentsViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *dictArray;

@end

static NSString *commentCell = @"commentCell";

@implementation YBCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论列表";
    self.commentTableView.rowHeight = 80;
    [self.commentTableView registerNib:[UINib nibWithNibName:@"YBCommentTableViewCell" bundle:nil] forCellReuseIdentifier:commentCell];
    self.commentTableView.tableFooterView = [UIView new];
    [self getShopCommentDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)getShopCommentDetails
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"shopsysno"] = [NSString stringWithFormat:@"%@",self.shopModel.SysNo];
    NSLog(@"newDic - - - - %@",dict);

    self.dictArray = [NSMutableArray array];
    [YBRequest postWithURL:ShopCommentDetail MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        NSLog(@"newDic - - - - %@",newDic);
        for (NSDictionary *diction in newDic[@"ShopCommentInfoList"]) {
            YBCommentModels *foldCellModel = [YBCommentModels new];
            [foldCellModel setValuesForKeysWithDictionary:diction];
            [self.dictArray addObject:foldCellModel];
        }
        if (self.dictArray.count < 1) {
            [MBProgressHUD showError:@"暂无评价" toView:self.view];
        }
        [self.commentTableView reloadData];
        NSLog(@"newDic - - - - %@",self.dictArray);
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dictArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
    
    if (!cell) {
        cell = [[YBCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commentCell];
    }
    YBCommentModels *model = self.dictArray[indexPath.row];
    [cell showDetailsWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (IBAction)writeCommentAction:(UIButton *)sender {
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    
    __block UITextField *tf = nil;
    
    [LEEAlert alert].config
    .LeeContent(@"内容")
    .LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        
        textField.placeholder = @"输入框";
        
        textField.textColor = [UIColor darkGrayColor];
        
        tf = textField; //赋值
    })
    .LeeAction(@"好的", ^{
        NSLog(@"text - %@",tf.text);
        
        [self uploadCommentDetailsWith:tf.text];
        [tf resignFirstResponder];
    })
    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
    .LeeShow();
}

- (void)uploadCommentDetailsWith:(NSString *)comment
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"shopsysno"] = [NSString stringWithFormat:@"%@",self.shopModel.SysNo];
    dict[@"commnentcontent"] = comment;
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    
    NSLog(@"comment - %@",dict);
    [YBRequest postWithURL:CommentUpload MutableDict:dict success:^(id dataArray) {

        NSLog(@"comment - %@",dataArray);
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
