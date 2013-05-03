//
//  BWWeather.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWWeather : NSObject

@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* weather;
@property (strong, nonatomic) NSString* temp_c;
@property (strong, nonatomic) NSString* humidity;
@property (strong, nonatomic) NSString* wind_kph;

@end
