//
//  BWLocationManager.m
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import "BWLocationManager.h"

static BWLocationManager *sharedSingleton = nil;

@implementation BWLocationManager

-(id) init {
    
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
		
		NSLog(@"Location init");
		
		[self setLocation:nil];
		[self startLocationManager];
    }
    
    
    return self;
}

+ (BWLocationManager *)sharedInstance
{
	if( sharedSingleton == nil )
	{
		static dispatch_once_t predicate;
		
		dispatch_once( &predicate, ^{
			sharedSingleton = [[self alloc] init];
		});
		
		NSLog(@"Singleton init");
	}
	
	NSLog(@"Singleton return");
	
	return sharedSingleton;
}

- (void)startLocationManager
{
	if( [self location] == nil )
	{
		[_locationManager startUpdatingLocation];
		
		_timeOutTimer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(stopUpdatingLocation) userInfo:nil repeats:NO];
	}
}

- (void)stopLocationManager
{
	[self stopUpdatingLocation:@"Stopped"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
	if (locationAge > 5.0) return;
    if (newLocation.horizontalAccuracy < 0) return;
	
	NSLog(@"--> 1: %lf, %lf", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
	if (_lastLocation == nil || _lastLocation.horizontalAccuracy > newLocation.horizontalAccuracy)
	{
        _lastLocation = newLocation;
		[self setLocation:newLocation];
		
		NSLog(@"--> 2: %lf, %lf", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
		
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy)
		{
            [self stopUpdatingLocation:@"Updated"];
			
			NSLog(@"--> 3: %lf, %lf", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if( [error code] != kCLErrorLocationUnknown )
	{
		[self stopUpdatingLocation:@"Error"];
	}
}

- (void)stopUpdatingLocationWithTimeOut:(NSTimer *)timer
{
	[self stopUpdatingLocation:@"Timeout"];
	
	_timeOutTimer = nil;
}

- (void)stopUpdatingLocation:(NSString *)state
{
	if( _timeOutTimer != nil )
		[_timeOutTimer invalidate];
	
	[_locationManager stopUpdatingLocation];
	_locationManager.delegate = nil;
	
	[self.delegate locationUpdated:state withCoordinate:[self location]];
}



@end
