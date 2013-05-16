//
//  BWWeatherXMLParser.m
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import "BWWeatherXMLParser.h"

@implementation BWWeatherXMLParser : NSObject

-(id) init {

    if (self = [super init]) {
        _weather = [[BWWeather alloc] init];
        _forecast = [[BWForecast alloc] init];
        _cityHasBeenSet = FALSE;
        _countryHasBeenSet = FALSE;
        _celsiusHighHasBeenSet = FALSE;
        _forecastHasBeenRead = FALSE;
        _currentForecastElements = [NSMutableArray array];
        self.forecastElements = [NSMutableArray array];
        
    }

    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    _currentElementValue = string;
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    if ([elementName isEqualToString:@"city"]) {
        if (!_cityHasBeenSet) {
            NSLog(@"Processing Value: %@", @"city");
            _weather.city = _currentElementValue;
            _cityHasBeenSet = TRUE;
        }
    }
    
    if ([elementName isEqualToString:@"country"]) {
        if (!_countryHasBeenSet) {
            NSLog(@"Processing Value: %@", @"country");
            _weather.countryCode = _currentElementValue;
            _countryHasBeenSet = TRUE;
        }
    }
    
    if ([elementName isEqualToString:@"weather"]) {
        NSLog(@"Processing Value: %@", @"weather");
        _weather.weather = _currentElementValue;
    }
    
    if ([elementName isEqualToString:@"temp_c"]) {
        NSLog(@"Processing Value: %@", @"temp_c");
             _weather.temp_c = _currentElementValue;
    }
    
    if ([elementName isEqualToString:@"wind_kph"]) {
        NSLog(@"Processing Value: %@", @"wind_kph");
             _weather.wind_kph = _currentElementValue;
    }
    
    if ([elementName isEqualToString:@"relative_humidity"]) {
        NSLog(@"Processing Value: %@", @"humidity");
             _weather.humidity = _currentElementValue;
    
    }
    
    if ([elementName isEqualToString:@"weekday"]) {
        NSLog(@"Processing Value: %@", @"weekday_short");
        _forecast.day = _currentElementValue;
        
    }
    
    if ([elementName isEqualToString:@"celsius"]) {

        if (_celsiusHighHasBeenSet) {
            NSLog(@"Processing Value: %@ %@", @"celsius_low", _currentElementValue);
            _forecast.temp_c_low = _currentElementValue;
            _celsiusHighHasBeenSet = FALSE;
        } else {
            NSLog(@"Processing Value: %@ %@", @"celsius_high", _currentElementValue);
            _forecast.temp_c_high = _currentElementValue;
            _celsiusHighHasBeenSet = TRUE;
        }
    }
    
    if ([elementName isEqualToString:@"conditions"]) {
        NSLog(@"Processing Value: %@", @"conditions");
        _forecast.weather = _currentElementValue;
        _forecastHasBeenRead = TRUE;
        
    }
    
    [self setForecast:_forecast];
    [self setWeather:_weather];
    
    if (_forecastHasBeenRead) {
        NSLog(@"Processing Value: %@", @"Adding forecast");
        [self.forecastElements addObject:_forecast];
        _forecast = [[BWForecast alloc] init];
        _forecastHasBeenRead = FALSE;
    }
    
}

@end
