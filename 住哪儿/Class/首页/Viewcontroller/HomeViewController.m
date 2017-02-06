
//
//  HomeViewController.m
//  住哪儿
//
//  Created by geek on 2016/10/10.
//  Copyright © 2016年 Fantasticbaby. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchHotelVC.h"
#import "SDCycleScrollView.h"
#import "SelectConditionCell.h"
#import "HotPopularHotelAdCell.h"
#import "SpecialHotelCell.h"
#import "HotelDescriptionCell.h"
#import "ConditionPickerView.h"
#import "HotelDetailVC.h"
#import "SalePromotionImageView.h"
#import "PrivilegeHotelVC.h"
#import "TimerPickerVC.h"
#import "LBPNavigationController.h"
#import "JFCityViewController.h"
#import "PriceAndStarLevelPickerView.h"


#import "YYFPSLabel.h"

#define SalePromotionImageWidth 49
#define SalePromotionImageHeight 54
static NSString *SelectConditionCellID = @"SelectConditionCell";
static NSString *HotPopularHotelAdCellID = @"HotPopularHotelAdCell";
static NSString *SpecialHotelCellID = @"SpecialHotelCell";
static NSString *HotelDescriptionCellID = @"HotelDescriptionCell";

@interface HomeViewController ()<SDCycleScrollViewDelegate,
                                UITableViewDelegate,UITableViewDataSource,SelectConditionCellDelegate,SalePromotionImageViewDelegate,
                                    ConditionPickerViewDelegate,
                                    PriceAndStarLevelPickerViewDelegate,
                                    TimerPickerVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) SDCycleScrollView *advertiseView;
@property (nonatomic, strong) NSMutableArray *condtions;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) ConditionPickerView *conditionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SalePromotionImageView *saleImageView;
@property (nonatomic, strong) PriceAndStarLevelPickerView *starView;
@end

@implementation HomeViewController

#pragma mark -- life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preData];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saleImageView];
    [self testFPSLabel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [SVProgressHUD dismiss];
}

- (BOOL)prefersStatusBarHidden { //设置隐藏显示
    return YES;
}

#pragma mark - PriceAndStarLevelPickerViewDelegate
-(void)priceAndStarLevelPickerView:(PriceAndStarLevelPickerView *)view didClickWithhButtonType:(PriceAndStarLevel_Operation)type withData:(NSMutableDictionary *)data{
    switch (type) {
        case PriceAndStarLevel_Operation_clearCondition:{
            [view refreshUI];
            break;
        }
        case PriceAndStarLevel_Operation_OK:{
            self.conditionView.datas = data;
            [self.starView removeFromSuperview];
            break;
        }
        default:
            break;
    }
}

#pragma mark - TimerPickerVCDelegate
-(void)timerPickerVC:(TimerPickerVC *)vc didPickedTime:(NSString *)period{
    self.conditionView.pickedEndTime = period;
}

#pragma mark - ConditionPickerViewDelegate
-(void)conditionPickerView:(ConditionPickerView *)view didClickWithActionType:(Operation_Type)type{
    switch (type) {
        case Operation_Type_InTime:{
            TimerPickerVC *timePicker = [[TimerPickerVC alloc] init];
            timePicker.delegate = self;
            LBPNavigationController *navi = [[LBPNavigationController alloc] initWithRootViewController:timePicker];
            [self.navigationController presentViewController:navi animated:true completion:nil];
        }
        case Operation_Type_EndTime:{
            TimerPickerVC *timePicker = [[TimerPickerVC alloc] init];
            timePicker.delegate = self;
            LBPNavigationController *navi = [[LBPNavigationController alloc] initWithRootViewController:timePicker];
            [self.navigationController presentViewController:navi animated:true completion:nil];
        }
        case Operation_Type_Locate:{
            JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
            cityViewController.title = @"城市";
            [cityViewController choseCityBlock:^(NSString *cityName) {
                self.conditionView.cityName = cityName;
            }];
            LBPNavigationController *navigationController = [[LBPNavigationController alloc] initWithRootViewController:cityViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
        }
        case Operation_Type_AutoLocate:{
            NSLog(@"自动定位");
            break;
        }
        case Operation_Type_SearchHotel:{
            NSLog(@"查找酒店");
            break;
        }
        case Operation_Type_StarFilter:{
            self.starView = [[PriceAndStarLevelPickerView alloc] initWithFrame:CGRectMake(0,BoundHeight, BoundWidth, 600)];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.starView];
            self.starView.delegate = self;
            break;
        }
            
        default:
            break;
    }
}
#pragma mark - SalePromotionImageViewDelegate
-(void)salePromotionImageView:(SalePromotionImageView *)salePromotionImageView didClickAtPromotionView:(NSString *)flag{
    PrivilegeHotelVC *vc = [[PrivilegeHotelVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark - SelectConditionCellDelegate
-(void)selectConditionCell:(SelectConditionCell *)selectConditionCell didClickCollectionCellAtIndexPath:(NSInteger)indexPath{
    switch (indexPath) {
        case 0:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 1:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 2:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 3:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 4:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 5:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 6:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        case 7:
            [SVProgressHUD showInfoWithStatus:@"程序员哥哥正在努力哦，敬请期待！"];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 181;
    }else if(indexPath.row == 1){
        return 106;
    }else if (indexPath.row == 2){
        return 81;
    }else{
        return 270;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SelectConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectConditionCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.datas = self.condtions;
        return cell;
    }else if (indexPath.row == 1){
        HotPopularHotelAdCell *cell = [tableView dequeueReusableCellWithIdentifier:HotPopularHotelAdCellID forIndexPath:indexPath];
        cell.datas = self.condtions;
        return cell;
    }else if (indexPath.row == 2){
        SpecialHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialHotelCellID forIndexPath:indexPath];
        return cell;
    }else{
        HotelDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:HotelDescriptionCellID forIndexPath:indexPath];
        cell.hotelImageName = self.dataArray[indexPath.row - 3];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>=3) {
        HotelDetailVC *vc = [[HotelDetailVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- private method
- (void)preData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    for (int i = 1; i <= 8; i++){
        [self.dataArray addObject:[NSString stringWithFormat:@"jpg-%d",i]];
    }
    self.advertiseView.localizationImageNamesGroup = self.dataArray;
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    [self.tableView reloadData];
}

- (void)testFPSLabel {
    self.fpsLabel = [YYFPSLabel new];
    self.fpsLabel.frame = CGRectMake(BoundWidth/2-25, 20, 50, 30);
    [self.fpsLabel sizeToFit];
    [self.view addSubview:self.fpsLabel];
}

#pragma mark --lazy load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, BoundWidth, BoundHeight) style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate = self;
        _tableView.scrollsToTop = YES;
        _tableView.backgroundColor = TableViewBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SelectConditionCell class] forCellReuseIdentifier:SelectConditionCellID];
        [_tableView registerClass:[HotPopularHotelAdCell class] forCellReuseIdentifier:HotPopularHotelAdCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SpecialHotelCell" bundle:nil] forCellReuseIdentifier:SpecialHotelCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"HotelDescriptionCell" bundle:nil] forCellReuseIdentifier:HotelDescriptionCellID];
        
        __weak typeof(self) WeakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [WeakSelf preData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [WeakSelf preData];
        }];
        _tableView.mj_header.automaticallyChangeAlpha = YES;       // 设置自动切换透明度(在导航栏下面自动隐藏)
    }
    return _tableView;
}

-(SDCycleScrollView *)advertiseView{
    if (!_advertiseView) {
        SDCycleScrollView *adview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, BoundWidth, 394) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        adview.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        adview.currentPageDotColor = [UIColor whiteColor];
        adview.originY = 112;
        _advertiseView = adview;
    }
    return _advertiseView;
}

-(ConditionPickerView *)conditionView{
    if (!_conditionView) {
        _conditionView = [[ConditionPickerView alloc] initWithFrame:CGRectMake(10, 130, BoundWidth-20, 255)];
        _conditionView.delegate = self;
    }
    return _conditionView;
}

-(UIView *)headerView{
    if (!_headerView) {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BoundWidth, 394)];
        head.backgroundColor = [UIColor whiteColor];
        [head addSubview:self.advertiseView];
        [head addSubview:self.conditionView];
        _headerView = head;
    }
    return _headerView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)condtions{
    if (!_condtions) {
        NSMutableArray *datas = [NSMutableArray array];
        NSArray *images =  @[@"Home_appoinement",@"Home_health",@"Home_interactivePlatform",@"Home_advisory Complaints",
                             @"Home_dietDocument",@"Home_stepCounter",@"Home_BMIDocument",@"Home_myNotice"];
        NSArray *titles = @[@"钟点房",@"门票",@"特惠酒店",@"当地",
                            @"机票",@"火车票",@"汽车票",@"特色酒店"];
        
        for (int i=0; i<images.count; i++) {
            NSDictionary *dic = @{@"image":images[i],@"title":titles[i]};
            [datas addObject:dic];
        }
        _condtions = datas;
    }
    return _condtions;
}

-(SalePromotionImageView *)saleImageView{
    if (!_saleImageView) {
        _saleImageView = [[SalePromotionImageView alloc] initWithFrame:CGRectMake(BoundWidth-SalePromotionImageWidth, BoundHeight/2-SalePromotionImageHeight/2, SalePromotionImageWidth, SalePromotionImageHeight)];
        _saleImageView.defaultImageName = @"Home_sale_promotion";
        _saleImageView.delegate = self;
    }
    return _saleImageView;
}

@end
