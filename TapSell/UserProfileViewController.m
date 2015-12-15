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
#import <Parse.h>
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
    /*
    PFQuery * query =[PFQuery queryWithClassName:@"User"];
    [query whereKey:@"EmailID" equalTo:self.userDataObjectUP.emailID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (PFObject * object in objects)
            {
                // retreive data
                NSString * objectID = [object objectId];
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * emailID = [object objectForKey:@"EmailID"];
                NSString * address = [object objectForKey:@"Address"];
                NSString * aptNo = [object objectForKey:@"AptNo"];
                NSString * city = [object objectForKey:@"City"];
                NSString * state = [object objectForKey:@"State"];
                NSString * zipcode = [object objectForKey:@"Zipcode"];
                NSString * phone = [object objectForKey:@"Phone"];
                //UIImage * userprofile = [object objectForKey:@"UserProfileImage"];
                
                
                _userDataObjectUP.objectID = objectID;
                _userDataObjectUP.fname = firstName;
                _userDataObjectUP.lname = lastname;
                _userDataObjectUP.emailID = emailID;
                _userDataObjectUP.address = address;
                _userDataObjectUP.aptNo = aptNo;
                _userDataObjectUP.city = city;
                _userDataObjectUP.state = state;
                _userDataObjectUP.zipcode =zipcode;
                _userDataObjectUP.phone = phone;
                //_userDataObjectUP.userProfileImage = userprofile;
                
            }
            if (![objects count]==0) {
                [self performSegueWithIdentifier:@"afterlogin" sender:self];
                NSLog(@"Successfully retrieved: %@", objects);
                           }
            else
            {
                [self displayAlertView:@"Data not found"];
            }
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            [self displayAlertView:errorString];
        }
    }];*/

   // _userProfileImageView.image = self.userDataObjectUP.userProfileImage;
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
-(void)displayAlertView:(NSString *)message

{
    UIAlertController *alertCont =[UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:okAction];
    [self presentViewController:alertCont animated:YES completion:nil];
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
