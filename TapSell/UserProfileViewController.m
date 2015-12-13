//
//  UserProfileViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/9/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserProfileViewController.h"
#import "EditUserProfileViewController.h"
#import "UserData.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailID;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageViewDisplay];
    [self retrieveUserProfile];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)imageViewDisplay
{
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width/2;
    self.userProfileImageView.clipsToBounds = YES;
    self.userProfileImageView.layer.masksToBounds = self.userProfileImageView.layer.borderWidth = 8.0f;
    self.userProfileImageView.layer.borderColor = [UIColor colorWithRed:0.168f green:0.200f blue: 0.219f alpha:0.3f].CGColor;

}
-(void)retrieveUserProfile
{
      
    _lblName.text = [NSString stringWithFormat:@"%@  %@",self.userDataObjectUP.fname,self.userDataObjectUP.lname];

    _lblLocation.text = self.userDataObjectUP.city;
    _lblPhone.text=self.userDataObjectUP.phone;
    _lblEmailID.text = self.userDataObjectUP.emailID;
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit"])
    {
        EditUserProfileViewController * edit =  [segue destinationViewController];
        edit.userDataObjEUP = self.userDataObjectUP;
        
        NSLog(@"%@   %@", edit.userDataObjEUP.fname, self.userDataObjectUP.fname);
    }
    
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
