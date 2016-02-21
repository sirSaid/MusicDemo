
#import "ListViewController.h"
#import "MusicTableViewCell.h"
#import "MusicDataManger.h"
#import "PlayViewController.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong,nonatomic) PlayViewController *playVC;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MusicDataManger sharedMusicHandle] getDataFromNetWorkWithBlock:^(BOOL isFinished) {
        if (isFinished) {
            [self.mainTableView reloadData];
        }else{
            NSLog(@"网络请求失败");
        }
    }];
}

#pragma mark ----- UITableViewDataSource 协议 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MusicDataManger sharedMusicHandle].dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicTableViewCell"];
    MusicModel *model = [MusicDataManger sharedMusicHandle].dataArray[indexPath.row];
    [cell setCellWithMusicModel:model];
    self.mainTableView.rowHeight = 120;
    
    return cell;
}

#pragma mark ----- Cell 的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 获取storyBoard
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    // 根据控制器ID 获取控制器
    self.playVC = [board instantiateViewControllerWithIdentifier:@"PlayViewController"];
    
    // 设置当前播放的音乐
    [[MusicDataManger sharedMusicHandle] setCurrentPlayMusic:[MusicDataManger sharedMusicHandle].dataArray[indexPath.row]];
    
    
    // 调用显示view的方法
    [self.playVC showViewAndPlayMusic];
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
