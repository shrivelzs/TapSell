//
//  UserDetailViewController.h
//  TapSell
//
//  Created by Shu Zhang on 12/24/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UserData.h"
//#import "MapViewController.h"

@interface UserDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *UserPortrait;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserEmail;



@end
