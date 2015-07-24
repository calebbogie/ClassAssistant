//
//  MapViewController.h
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 7/22/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

    @property (nonatomic, strong) IBOutlet MKMapView *mapView;
    @property CLLocationManager *locationManager;

@end
