//
//  PostListData.h
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/14/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostListData : NSObject
@property(nonatomic,strong)NSString * postID;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * location;
@property(nonatomic,strong)NSString * price;
@property(nonatomic,strong)NSString * productDescription;
@property(nonatomic,strong)NSString * userID;
@property(nonatomic,strong)NSData * productImage;
@end
