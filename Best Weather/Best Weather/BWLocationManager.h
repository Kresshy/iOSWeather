//
//  BWLocationManager.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@protocol BWLocationManagerDelegate <NSObject>

- (void)locationUpdated:(NSString *)status withCoordinate:(CLLocation *)coordinate;

@end

@interface BWLocationManager : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager* _locationManager;
    CLLocation* _lastLocation;
    NSTimer* _timeOutTimer;
    NSTimeInterval* locationTimer;
    
}

@property (weak, nonatomic) id <BWLocationManagerDelegate> delegate;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) CLLocation *location;

-(void) startLocationManager;
-(void) stopLocationManager;

+ (BWLocationManager*) sharedInstance;

@end
