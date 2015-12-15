//
//  PostListViewController.h
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/14/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "ViewController.h"
#import "UserData.h"
#include "PostListData.h"
@interface PostListViewController : ViewController
@property(nonatomic,strong)UserData * userDataObjPL;
@property(nonatomic,strong)PostListData * postListDataPL;
@end
