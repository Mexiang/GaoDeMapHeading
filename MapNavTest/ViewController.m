//
//  ViewController.m
//  MapNavTest
//
//  Created by Dry on 16/9/1.
//  Copyright © 2016年 Dry. All rights reserved.
//

#import "ViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

static const NSUInteger kUserHearderAnnotaionViewTag = 10000;

@interface ViewController ()<MAMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self creatMapView];
}

- (void)creatMapView {
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsCompass = NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    //是否自定义用户位置精度圈
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self.view addSubview:_mapView];
}

#pragma mark MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"%f,%f,%f",userLocation.heading.x,userLocation.heading.y,userLocation.heading.z);
    
    MAAnnotationView *hearderAnnotationView = [self.mapView viewWithTag:kUserHearderAnnotaionViewTag];
    if (hearderAnnotationView)
    {
        hearderAnnotationView.transform = CGAffineTransformIdentity;
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI*userLocation.heading.magneticHeading/180.0);
        hearderAnnotationView.transform = transform;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    //用户当前位置大头针
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *kUserLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kUserLocationStyleReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kUserLocationStyleReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"heardImg_passenger_default"];
        annotationView.frame = CGRectMake(0, 0, 26, 26);
        annotationView.contentMode = UIViewContentModeScaleToFill;
        annotationView.layer.masksToBounds = YES;
        annotationView.tag = kUserHearderAnnotaionViewTag;
        
        return annotationView;
    }
    //其他大头针
    else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
