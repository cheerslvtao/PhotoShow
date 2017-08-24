//
//  AlbumDetailWebViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/22.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AlbumDetailWebViewController.h"
#import "PoperViewController.h"
#import "UINavigationBar+Progress.h"
#import <UShareUI/UShareUI.h>
#import "UMManager.h"
#import "SubmitOrderViewController.h"
#import "EditingAlbumViewController.h"
#import "SubmitDocumentViewController.h"

@interface AlbumDetailWebViewController ()<UIPopoverPresentationControllerDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,retain)WKWebView * webview;


@end

@implementation AlbumDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar.progressView setProgress:0 animated:NO];
    [self.navigationController.navigationBar showProgess];

    
    
    self.isShare? [self shareRightNav]: [self configNavRightItem];
    
    [self createWebView];
    
    __weak typeof(self) weakself = self;
    self.leftNavBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself.navigationController.navigationBar.progressView removeFromSuperview];
        [strongself.webview removeObserver:strongself forKeyPath:@"estimatedProgress"];
        [strongself.navigationController popViewControllerAnimated:YES];
    };
    
}


#pragma mark -  导航组件 相关

-(void)shareRightNav{
    self.title = @"我的分享";
    //我的界面 分享
    [self setNavigationBarRightItem:@"分享" itemImg:[UIImage imageNamed:@"nav_share"] currentNavBar:self.navigationItem curentViewController:self];
    __weak typeof(self) weakself = self;
    self.rightNavBlock = ^{
        NSLog(@"分享");
        [weakself share];
    };
}

//相册详情的 “更多”  文件上传
-(void)configNavRightItem{
    self.title = @"相册预览";
    if (self.filePath.length > 0) {
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 40);
        [button setTitle:@"上传" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(upLoadFile) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightitem;
        
        return;
    }
    [self setNavigationBarRightItem:@"更多" itemImg:[UIImage imageNamed:@"more"] currentNavBar:self.navigationItem curentViewController:self];
    
    __weak typeof(self) weakself = self;
    self.rightNavBlock = ^{
        NSLog(@"right item");
        __strong typeof(weakself) strongself = weakself;
        PoperViewController *pop = [[PoperViewController alloc] init];
        pop.modalPresentationStyle = UIModalPresentationPopover;
        pop.itemTitles = @[@"制作",@"编辑",@"分享"];
        
        pop.popoverPresentationController.sourceView = strongself.navigationController.navigationBar;  //rect参数是以view的左上角为坐标原点（0，0）
        pop.popoverPresentationController.sourceRect =  CGRectMake(SCREEN_WIDTH*5/6, 10, 100, 30); //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
        pop.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
        pop.popoverPresentationController.delegate = strongself;
        //    pop.preferredContentSize = CGSizeMake(self.view.bounds.size.width*0.3, 130);
        [strongself presentViewController:pop animated:YES completion:nil];
        
        pop.block = ^(NSInteger index) {
            switch ((long)index) {
                case 0:{
                    SubmitOrderViewController * submitVC = [[SubmitOrderViewController alloc]init];
                    submitVC.albumModel = strongself.albumModel;
                    [strongself.navigationController pushViewController:submitVC animated:YES];
                    break;
                }
                case 1:{
                    EditingAlbumViewController * editingvC = [[EditingAlbumViewController alloc]init];
                    editingvC.type = EditingAlbum;
                    editingvC.albumId = weakself.albumModel.albumId;
                    [strongself.navigationController pushViewController:editingvC animated:YES];
                    break;
                    }
                case 2:
                    [strongself share];
                    break;

                default:
                    break;
            }
        };
    };
}

#pragma mark - 上传文档
-(void)upLoadFile{
//    FileModel * model = self.dataArr[indexPath.row];
    
    [HTTPTool uploadImageWithPath:url_uploadFile params:nil thumbName:@"imageData" fileName:self.model.fileName file:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.model.filePath]] success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(CGFloat progress) {
        NSLog(@"%f",progress);
    }];
}

-(void)share{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"%ld",(long)platformType);
        NSLog(@"%@",userInfo);
        UMShareInfoModel * model = [[UMShareInfoModel alloc]init];
        model.vc = self;
        model.platfromType = platformType;
        if (self.isShare) {
            model.thumbURL =@"http://image.baidu.com/search/detail?ct=503316480&z=&tn=baiduimagedetail&ipn=d&ie=utf-8&in=24401&cl=2&lm=-1&st=-1&step_word=&rn=1&cs=&ln=1998&fmq=1402900904181_R&ic=0&s=&se=1&sme=0&tab=&width=&height=&face=0&is=&istype=2&ist=&jit=&fr=ala&ala=1&alatpl=others&pos=1&pn=4&word=%E5%9B%BE%E7%89%87%20%E7%BE%8E%E5%A5%B3&di=182764656140&os=602872014,2379713269&pi=0&objurl=http%3A%2F%2Ff4.topit.me%2F4%2F87%2F00%2F11213791114e400874o.jpg";
            model.webpageUrl = @"https://www.baidu.com";
            model.shareTitle = @"我的个性相册";
            model.shareMsg = @"快来一起分享我的个性相册";

        }else{
            // 构建分享信息
            model.thumbURL =[NSString stringWithFormat:@"%@%@",baseAPI,self.albumModel.albumPhoto];
            model.webpageUrl = [NSString stringWithFormat:@"%@/temp/getAlbum?album_id=%@",baseAPI,self.albumModel.albumId];
            model.shareTitle = @"我的个性相册";
            model.shareMsg = @"快来一起分享我的个性相册";
        }
        [UMManager share:model];

    }];

}

//iPhone下默认是UIModalPresentationFullScreen，需要手动设置为UIModalPresentationNone，iPad不需要
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙板popover不消失， 默认yes
}

#pragma mark - 设置Webview
-(void)createWebView{
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    NSURLRequest * request = nil;
    if (self.isShare){
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    }else if (self.filePath.length > 0) {
        request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]];
    }else{
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/temp/getAlbum?album_id=%@",baseAPI,self.albumModel.albumId]]];
    }
    NSLog(@"%@",request);
    [self.webview loadRequest:request];
    [self.view addSubview:self.webview];
    
    //监听webView加载进度
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - 进度条进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webview && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.navigationController.navigationBar.progressView setProgress:newprogress animated:YES];
        if (newprogress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController.navigationBar.progressView setProgress:0 animated:NO];
            });
        }
    }
}



-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"finished");
}

-(void)viewDidDisappear:(BOOL)animated{
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
