//
//  MCLoginDemoViewController.m
//  ProvingGround
//
//  Created by Mark on 2020/10/12.
//  Copyright © 2020 markcj. All rights reserved.
//

#import "MCLoginDemoViewController.h"
#import "MCLoginViewModel.h"

@interface MCLoginDemoViewController ()

// UI Control
@property (weak, nonatomic) IBOutlet UITextField *tfMobilePhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;

// ViewModel
@property (nonatomic, strong) MCLoginViewModel *loginVM;

@end

@implementation MCLoginDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC测试-用户登录";
    
    self.loginVM = [[MCLoginViewModel alloc] init];
    
    RAC(self.loginVM.user, mobileNumber) = self.tfMobilePhone.rac_textSignal;
    RAC(self.loginVM.user, password) = self.tfPassword.rac_textSignal;
    RAC(self.btLogin, enabled) = self.loginVM.enableLoginSignal;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didLoginButtonClicked:(id)sender {
    [self.loginVM.loginCommand execute:@(1)];
}

@end
