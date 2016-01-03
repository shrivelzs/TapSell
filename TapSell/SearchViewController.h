//
//  SearchViewController.h
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 1/2/16.
//  Copyright © 2016 Shu Zhang. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "PostListData.h"
#import "UserData.h"

@interface SearchViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating>
@property(nonatomic,strong)PostListData *PostDataObjSV;
@property(nonatomic,strong)UserData * userDataObjSV;
@end
