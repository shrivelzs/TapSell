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
#import "UserDetailViewController.h"

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self Annotation];
    _userDataMapVCObj = [[UserData alloc]init];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Annotation{
    PFQuery * query =[PFQuery queryWithClassName:@"User"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject * object in objects)
            {
                // retreive data
                NSString * objectID = [object objectId];
                
                NSLog(@"Here is User ID %@", objectID);
                NSString * firstName = [object objectForKey:@"UserFirstName"];
                NSString * lastname = [object objectForKey:@"UserLastName"];
                NSString * name = [[firstName stringByAppendingString:@" "]stringByAppendingString:lastname];
                NSString * email = [object objectForKey:@"EmailID"];
                
               // NSString * UserID = object.objectId;
               //NSLog(@"name:%@, userid:%@",name,UserID);
                _userDataMapVCObj.objectID = objectID;

                PFGeoPoint * point = [object objectForKey:@"currentLocation"];
                
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
                CLLocationCoordinate2D coordinate = [loc coordinate];
                
                PFFile *pictureFile = [object objectForKey:@"UserProfileImage"];
                //UIImage *userImage = [UIImage imageWithData:pictureFile];
                
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *userImage = [UIImage imageWithData:data];
                        // image can now be set on a UIImageView
//                        NSLog(@"imageuser:%@", userImage);

                        [self.mapView addAnnotations:[self objectWithImageName:userImage title:name subtitle:email coordinate:coordinate userID:objectID]];
                    }
                }];
                
                            }
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



#pragma mark - MethodforAnnotation

- (NSArray *)objectWithImageName:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subTitle coordinate:(CLLocationCoordinate2D)coordinate userID:(NSString *)userID
{
    JPSThumbnail *newObj = [[JPSThumbnail alloc] init];
    newObj.image = image;
    newObj.title = title;
    //self.UeserfName = title;
    newObj.subtitle = subTitle;
    //newObj.objectID = userID;
    
    newObj.coordinate = coordinate;
    newObj.disclosureBlock = ^{
               [self performSegueWithIdentifier:@"PushData" sender:self];
        NSLog(@"tap button:%@",self.userDataMapVCObj.objectID);
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserNum"];
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

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"PushData"])
//    {
//        UserDetailViewController *obj_VC = [segue destinationViewController];
//        obj_VC.userDataUserDetailVCObj = self.userDataMapVCObj;
//        
//    }
//}





@end
