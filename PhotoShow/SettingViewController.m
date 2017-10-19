//
//  SettingViewController.m
//  PhotoShow
//
//  Created by SFC-a on 2017/7/29.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUsViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *aboutUsCell;
@property (weak, nonatomic) IBOutlet UISwitch *openNotification;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutUs:)];
    [self.aboutUsCell addGestureRecognizer:tap];
    
    self.openNotification.on = [[NSUSERDEFAULT objectForKey:@"push"] isEqualToString:@"push"];

    
}

-(void)aboutUs:(UITapGestureRecognizer *)tap{
    [self.navigationController pushViewController:[[AboutUsViewController alloc]init] animated:YES];
}
- (IBAction)openPush:(UISwitch *)sender {
    NSLog(@"%d",sender.isOn);
    if (sender.isOn) {
        [NSUSERDEFAULT setObject:@"push" forKey:@"push"];
    }else{
        [NSUSERDEFAULT setObject:@"notpush" forKey:@"push"];
    }
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
