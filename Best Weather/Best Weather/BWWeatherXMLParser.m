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
        _cityHasBeenSet = FALSE;
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
    
    [self setWeather:_weather];
    
}

@end
