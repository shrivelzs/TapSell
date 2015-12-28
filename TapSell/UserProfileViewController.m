//
//  UserProfileViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/9/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "UserProfileViewController.h"
#import "EditUserProfileViewController.h"
#import <Parse.h>
#import "ViewController.h"
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
    [self reloadUserProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)imageViewDisplay
{
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width/2;
    self.userProfileImageView.clipsToBounds = YES;
    self.userProfileImageView.layer.masksToBounds = self.userProfileImageView.layer.borderWidth = 8.0f;
    self.userProfileImageView.layer.borderColor = [UIColor colorWithRed:0.168f green:0.200f blue: 0.219f alpha:0.3f].CGColor;
}
-(void)reloadUserProfile
{
    NSString*username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString*password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    PFQuery * query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"EmailID" equalTo:username];
    [query whereKey:@"Password" equalTo:password];
    [query findObjectsInBackgroundWithBlock:^(NSArray *  objects, NSError *  error) {
        if (!error) {
            self.userDataObjectUP = [[UserData alloc]init];
            for (PFObject * object in objects)
            {
                // retreive data
               // NSString * objectID = [object objectId];
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
                //NSString * address = [object objectForKey:@"Address"];
                //NSString * aptNo = [object objectForKey:@"AptNo"];
                NSString * city = [object objectForKey:@"City"];
                //NSString * state = [object objectForKey:@"State"];
                //NSString * zipcode = [object objectForKey:@"Zipcode"];
                NSString * phone = [object objectForKey:@"Phone"];
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error){
                        [self.userProfileImageView setImage:[UIImage imageWithData:data]];
                        _userDataObjectUP.userProfileImage = data;
                    }}];
                
                _lblName.text = [NSString stringWithFormat:@"%@  %@",firstName,lastname];
                _lblLocation.text = city;
                _lblPhone.text=phone;
                _lblEmailID.text = emailID;
            }
        }
        else
            NSLog(@"Canno load data");
    }];
}

-(void)displayAlertView:(NSString *)message

{
    UIAlertController *alertCont =[UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:okAction];
    [self.navigationController presentViewController:alertCont animated:YES completion:nil];
}

@end
