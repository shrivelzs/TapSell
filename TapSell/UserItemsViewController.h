//
//  UserItemsViewController.h
//  TapSell
//
//  Created by Shu Zhang on 12/27/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "PostListData.h"
@interface UserItemsViewController : UIViewController
@property(nonatomic,strong)UserData*userDataUserItemObj;
@property(nonatomic,strong)PostListData * postListDataUserItemObj;
@end
