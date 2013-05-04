//
//  BWWeatherXMLParser.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWWeather.h"

@interface BWWeatherXMLParser : NSObject <NSXMLParserDelegate> {
    
    NSString* _currentElementValue;
    BWWeather* _weather;
    bool _cityHasBeenSet;
    bool _countryHasBeenSet;
    
}

@property (strong, nonatomic) BWWeather* weather;



@end
