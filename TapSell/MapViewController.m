//
//  MapViewController.m
//  TapSell
//
//  Created by Thanapat Tangsittiprasert on 12/7/15.
//  Copyright © 2015 Shu Zhang. All rights reserved.
//

#import "MapViewController.h"
#import "JPSThumbnailAnnotation.h"
#import "UserData.h"
#import <Parse/Parse.h>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapView.delegate = self;
    
    //[self.view addSubview:mapView];
    
    // Annotations
    //    [mapView addAnnotations:[self annotations]];
    
    //[self RetriveData];
    [self MyMethod];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)MyMethod{
    PFQuery * query =[PFQuery queryWithClassName:@"User"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            NSLog(@"OBJ: %@", objects);
            for (PFObject * object in objects)
            {
                // retreive data
                // NSString * objectID = [object objectId];
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * email = [object objectForKey:@"EmailID"];
                NSString * address = [object objectForKey:@"Address"];
                NSString * aptNo = [object objectForKey:@"AptNo"];
                NSString * city = [object objectForKey:@"City"];
                NSString * state = [object objectForKey:@"State"];
                NSString * zipcode = [object objectForKey:@"Zipcode"];
                NSString * phone = [object objectForKey:@"Phone"];
                PFGeoPoint * point = [object objectForKey:@"currentLocation"];
                
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
                CLLocationCoordinate2D coordinate = [loc coordinate];
                
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                //UIImage *userImage = [UIImage imageWithData:pictureFile];
                
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *userImage = [UIImage imageWithData:data];
                        // image can now be set on a UIImageView
                        NSLog(@"imageuser:%@", userImage);
                        
                        
                        
                        [self.mapView addAnnotations:[self objectWithImageName:userImage title:firstName subtitle:email coordinate:coordinate]];
                        
                        
                        
                    }
                }];
                
                //                NSLog(@"1%@2%@3%@4%@5%@6%@7%@8%@9%@10%@",firstName,lastname,address,aptNo,city,state,zipcode,phone,point,pictureFile);
                
                
                
                
                //                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                //                    if (!error){
                //
                //                        [self.editUserProfileImageView setImage:[UIImage imageWithData:data]];
                //                    }}];
                
                //                self.txtEditFname.text = firstName;
                //                self.txtEditLname.text = lastname;
                //                self.txtEdtiAddress.text = address;
                //                self.txtEdtiApt.text = aptNo;
                //                self.txtEditCity.text = city;
                //                self.txtEdtiState.text = state;
                //                self.txtEditZipcode.text = zipcode;
                //                self.txtEditPhone.text = phone;
            }
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (NSArray *)annotations {
    //    // Empire State Building
    //    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    //    empire.image = [UIImage imageNamed:@"empire.jpg"];
    //    empire.title = @"Empire State Building";
    //    empire.subtitle = @"NYC Landmark";
    //    empire.coordinate = CLLocationCoordinate2DMake(40.75f, -73.99f);
    //    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
    //    //add a gesture
    //
    //
    //
    //
    //
    //
    //    return @[[JPSThumbnailAnnotation annotationWithThumbnail:empire]];
    return [self objectWithImageName:[UIImage imageNamed:@"empire.jpg"] title:@"Empire State Building" subtitle:@"NYC Landmark" coordinate:CLLocationCoordinate2DMake(40.75f, -73.99f)];
    
}
#pragma mark - MethodforAnnotation

- (NSArray *)objectWithImageName:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subTitle coordinate:(CLLocationCoordinate2D)coordinate
{
    JPSThumbnail *newObj = [[JPSThumbnail alloc] init];
    newObj.image = image;
    newObj.title = title;
    //self.UeserfName = title;
    newObj.subtitle = subTitle;
    
    newObj.coordinate = coordinate;
    newObj.disclosureBlock = ^{
        [self performSegueWithIdentifier:@"PushData" sender:self];
        
        
    };
    
    
    
    
    
    return @[[JPSThumbnailAnnotation annotationWithThumbnail:newObj]];
    
    
    
    
}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        
        
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
        
    }
    return nil;
}

#pragma mark Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushData"])
    {
        //        DetailViewController *obj_VC = [segue destinationViewController];
        //        UserData *obj_Info = [UserData new];
        //
        //        obj_Info.emailID = self.UeserEmail;
        //        obj_Info.fname =self.UeserfName;
        //        obj_Info.fname =self.UeserlName;
        //        //        obj_CardInfo.cvvNumber = self.textf_CVV.text;
        //        //        obj_CardInfo.expiryDate = self.textf_ExpiryDate.text;
        //        //
        //        obj_VC.Userinfo = obj_Info;
    }
}

#pragma mark ParseData

-(void)RetriveData

{
    
    
    
    PFQuery * query =[PFQuery queryWithClassName:@"User"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
            
        {
            
            for (PFObject * object in objects)
                
            {
                
                // retreive data
                NSString * fName = [object objectForKey:@"UserFirstName"];
                
                NSString * lName = [object objectForKey:@"UserLastName"];
                NSString * Title = [[fName stringByAppendingString:@" "]stringByAppendingString:lName];
                NSLog(@"%@",Title);
                
                
                //                NSString * title = [object objectForKey:@"ProductTitle"];
                //
                //                NSString * location = [object objectForKey:@"Location"];
                //
                //                NSString * price = [object objectForKey:@"ProductPrice"];
                //
                //                NSString * productDescription = [object objectForKey:@"Discription"];
                //
                //                NSString * userID = [object objectForKey:@"UserID"];
                //
                //
                //
                //                PostListData * SearchPostList = [[PostListData alloc]init];
                //
                //                SearchPostList.title =title;
                //
                //                SearchPostList.location = location;
                //
                //                SearchPostList.price = price;
                //
                //                SearchPostList.productDescription = productDescription;
                //
                //                SearchPostList.userID = userID;
                //
                //                [self.array_SeachData addObject:SearchPostList];
                
            }
            
            if (![objects count]==0) {
                
                NSLog(@"Successfully retrieved: %@", objects);
                
                //[self.SearchTableViewList reloadData];
                
            }
            
        }
        
    }];
    
}





@end
