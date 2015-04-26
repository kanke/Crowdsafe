//
//  ViewController.m
//  CrowdSafe
//
//  Created by NG on 25/04/15.
//  Copyright (c) 2015 Neetesh Gupta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchbox;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
- (IBAction)didPressSearchButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];

    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = aUserLocation.coordinate;
    point.title = @"70% Full";
    point.subtitle = @"Cafe On Wheels";

    [self.mapView addAnnotation:point];
    //[self.mapView selectAnnotation:point animated:NO];
}

- (IBAction)didPressSearchButton:(id)sender {
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    CLGeocoder *geocoder;
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    NSLog(@"Starting geocode");
    [geocoder geocodeAddressString:self.searchbox.text
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     /*for (CLPlacemark* aPlacemark in placemarks)
                     {
                         CLPlacemark *place = aPlacemark[0];
                         CLLocation *location = [place locat]
                     }*/
                     CLPlacemark *placemark = placemarks[0];
                     CLLocation *loc = placemark.location;
                     
                     MKCoordinateRegion region;
                     MKCoordinateSpan span;
                     span.latitudeDelta = 0.010;
                     span.longitudeDelta = 0.010;
                     CLLocationCoordinate2D location;
                     location.latitude = loc.coordinate.latitude;
                     location.longitude = loc.coordinate.longitude;
                     region.span = span;
                     region.center = location;
                     [self.mapView setRegion:region animated:YES];
                     
                     MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                     point.coordinate = loc.coordinate;
                     point.title = @"70% Full";
                     point.subtitle = self.searchbox.text;
                     
                     [self.mapView addAnnotation:point];
                 }];
}
@end
