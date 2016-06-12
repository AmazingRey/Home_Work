//
//  XKRWPrivacyPassWordVC.m
//  XKRW
//
//  Created by ss on 16/6/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPrivacyPassWordVC.h"
#import <AudioToolbox/AudioServices.h>

@interface XKRWPrivacyPassWordVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imageOne;
@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;
@property (strong, nonatomic) IBOutlet UIImageView *imageThree;
@property (strong, nonatomic) IBOutlet UIImageView *imageFour;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation XKRWPrivacyPassWordVC{
    NSArray *imageViewArray;
}

- (IBAction)btnAction:(id)sender {
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageViewArray = @[_imageOne, _imageTwo, _imageThree, _imageFour];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (NSString *)passWord{
    if (!_passWord) {
        _passWord = @"1234";
    }
    return _passWord;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    [self makeEachImageViewWhenTextInput:range string:string];
    if (toBeString.length == self.passWord.length) {
        if ([toBeString isEqualToString:self.passWord]) {
            [textField resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            textField.text = @"";
            for (UIImageView  *imgView in imageViewArray) {
                imgView.image = [UIImage new];
            }
            
            return false;
        }
        
    }
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.text.length  == self.passWord.length) {
        return false;
    }
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return true;
}

- (void)makeEachImageViewWhenTextInput:(NSRange)range string:(NSString *)string{
    UIImageView *imageView = [imageViewArray objectAtIndex:range.location];
    if ([string isEqualToString:@""]) {
        imageView.image = [UIImage new];
    }else{
        imageView.image = [UIImage imageNamed:@"answer_check"];
    }
}

@end