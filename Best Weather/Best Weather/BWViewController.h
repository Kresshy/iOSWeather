//
//  BWViewController.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWLocationManager.h"

@interface BWViewController : UIViewController <NSURLConnectionDataDelegate, BWLocationManagerDelegate> {
    
    BWLocationManager* _locationManager;
    CLLocation* _location;
    
}

@end
