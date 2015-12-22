//
//  EditUserProfileViewController.h
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/9/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "ViewController.h"
#import "UserData.h"
#import <Parse.h>


@interface EditUserProfileViewController : ViewController
@property(nonatomic,strong)UserData * userDataObjEUP;
@property(strong,nonatomic)PFGeoPoint *userLocation;
@end
