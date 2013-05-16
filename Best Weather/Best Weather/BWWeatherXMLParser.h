//
//  BWWeatherXMLParser.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWWeather.h"
#import "BWForecast.h"

@interface BWWeatherXMLParser : NSObject <NSXMLParserDelegate> {
    
    NSString* _currentElementValue;
    BWWeather* _weather;
    BWForecast* _forecast;
    bool _cityHasBeenSet;
    bool _countryHasBeenSet;
    bool _celsiusHighHasBeenSet;
    bool _forecastHasBeenRead;
    NSMutableArray * _currentForecastElements;
    
}

@property (strong, nonatomic) BWWeather* weather;
@property (strong, nonatomic) BWForecast* forecast;
@property (strong, nonatomic) NSMutableArray *forecastElements;


@end
