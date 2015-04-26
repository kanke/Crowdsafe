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
- (IBAction)tappedPayButton:(id)sender;
@property PTPusher *client;
@end

@implementation ViewController {
    MKPointAnnotation *point;
    int percent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    percent = 70;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;


    self.client = [PTPusher pusherWithKey:@"610c2e6be84239a23fc8" delegate:self];
    [self.client connect];
    PTPusherChannel *channel = [self.client subscribeToChannelNamed:@"channel"];
    [channel bindToEventNamed:@"some-update" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        NSLog([channelEvent.data description]);
        percent = percent + 2;
        NSString *title = [NSString stringWithFormat:@"%d%% Full", percent];
        point.title = title;
        [self.mapView addAnnotation:point];
        [self.mapView selectAnnotation:point animated:NO];
    }];

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

    point = [[MKPointAnnotation alloc] init];
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
                     
                     point = [[MKPointAnnotation alloc] init];
                     point.coordinate = loc.coordinate;
                     point.title = @"70% Full";
                     point.subtitle = self.searchbox.text;
                     
                     [self.mapView addAnnotation:point];
                 }];
}

- (IBAction)tappedPayButton:(id)sender {
    NSLog(@"Clicked payment");
    Braintree *braintree = [Braintree braintreeWithClientToken:@"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI4MzUyNmE2ODAzNGQzMDI3NjQ0YTNmOTM0YzRlMzdlN2M3YWU5YTVkNDE3ZTdlZDM2OWQ2YzI1OGM3Yjk3NzA2fGNyZWF0ZWRfYXQ9MjAxNC0xMC0xMlQwOToxMzoyMC4zNjA4MTQ0NDYrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWZmZHFjOWZ5ZmZuN3luMmpcdTAwMjZwdWJsaWNfa2V5PXFqNjVubmRibm42cXlqa3AiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZmZkcWM5ZnlmZm43eW4yai9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbImN2diJdLCJwYXltZW50QXBwcyI6W10sImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy9mZmRxYzlmeWZmbjd5bjJqL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL2NsaWVudC1hbmFseXRpY3Muc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSJ9LCJ0aHJlZURTZWN1cmVFbmFibGVkIjp0cnVlLCJ0aHJlZURTZWN1cmUiOnsibG9va3VwVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2ZmZHFjOWZ5ZmZuN3luMmovdGhyZWVfZF9zZWN1cmUvbG9va3VwIn0sInBheXBhbEVuYWJsZWQiOnRydWUsInBheXBhbCI6eyJkaXNwbGF5TmFtZSI6IkNvbW1lcmNlIEZhY3RvcnkiLCJjbGllbnRJZCI6bnVsbCwicHJpdmFjeVVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS9wcCIsInVzZXJBZ3JlZW1lbnRVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vdG9zIiwiYmFzZVVybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXNzZXRzVXJsIjoiaHR0cHM6Ly9jaGVja291dC5wYXlwYWwuY29tIiwiZGlyZWN0QmFzZVVybCI6bnVsbCwiYWxsb3dIdHRwIjp0cnVlLCJlbnZpcm9ubWVudE5vTmV0d29yayI6dHJ1ZSwiZW52aXJvbm1lbnQiOiJvZmZsaW5lIiwibWVyY2hhbnRBY2NvdW50SWQiOiI3ZHloZDk4a2cydGt3cXRkIiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sIm1lcmNoYW50SWQiOiJmZmRxYzlmeWZmbjd5bjJqIiwidmVubW8iOiJvZmYiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6ImZmZHFjOWZ5ZmZuN3luMmotYXBwbGUtcGF5Iiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ=="];
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)

    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];

}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    //self.nonce = paymentMethod.nonce;
    //[self postNonceToServer:self.nonce]; // Send payment method nonce to your server
    //[self postNonceToServer:@"nonce"];
    [self dismissViewControllerAnimated:YES completion:nil];
    //self.cardNumber.text = @"4111 1111 1111 1111";

}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    //self.cardNumber.text = @"4111 1111 1111 1111";

}

- (void)dropInViewControllerWillComplete:(BTDropInViewController *)viewController
{
    //self.cardNumber.text = @"4111 1111 1111 1111";

}
@end
