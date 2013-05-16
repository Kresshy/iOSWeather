//
//  BWForecastViewController.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/16/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWLocationManager.h"

@interface BWForecastViewController : UIViewController <NSURLConnectionDataDelegate, BWLocationManagerDelegate> {
    
    BWLocationManager* _locationManager;
    CLLocation* _location;
    NSArray* _forecasts;
}

@property (weak, nonatomic) IBOutlet UIImageView *forecastImage1;
@property (weak, nonatomic) IBOutlet UIImageView *forecastImage2;
@property (weak, nonatomic) IBOutlet UIImageView *forecastImage3;
@property (weak, nonatomic) IBOutlet UIImageView *forecastImage4;

@property (weak, nonatomic) IBOutlet UILabel *forecastLabel1;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel2;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel3;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel4;

@end
