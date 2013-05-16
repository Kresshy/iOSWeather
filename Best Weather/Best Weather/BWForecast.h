//
//  BWForecast.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/16/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWForecast : NSObject

@property (strong, nonatomic) NSString* day;
@property (strong, nonatomic) NSString* weather;
@property (strong, nonatomic) NSString* temp_c_high;
@property (strong, nonatomic) NSString* temp_c_low;

@end
