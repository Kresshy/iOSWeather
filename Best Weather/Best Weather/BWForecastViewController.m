//
//  BWForecastViewController.m
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/16/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import "BWForecastViewController.h"
#import "BWWeatherXMLParser.h"
#import <QuartzCore/QuartzCore.h>

@interface BWForecastViewController () {
    NSURLConnection* _downloadXMLUrlConnection;
    NSMutableData* _downloadXMLData;
    NSMutableArray* _forecastData;
}

@end

@implementation BWForecastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _locationManager = [BWLocationManager sharedInstance];
    _locationManager.delegate = self;
    
    _location = [_locationManager location];
    
    NSLog(@"%@: %lf, %lf",@"Coordinates: " ,_location.coordinate.latitude, _location.coordinate.longitude);
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location completionHandler:
     ^(NSArray* placemarks, NSError* error) {
         
         if ([placemarks count] > 0)
         {
             //Get nearby address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //String to hold address
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //Print the location to console
             NSLog(@"I am currently at %@",locatedAt);
             NSLog(@"Country: %@",placemark.country);
             NSLog(@"Locality: %@",placemark.locality);
             NSLog(@"Sublocality: %@",placemark.subLocality);
             NSLog(@"AdministrativeArea: %@",placemark.administrativeArea);
             NSLog(@"ISOCountryCode: %@",placemark.ISOcountryCode);
             NSLog(@"Thoroughfare: %@",placemark.thoroughfare);
             
             //Set the label text to current location
             //[locationLabel setText:locatedAt];
             
             if (_downloadXMLUrlConnection) {
                 return;
             }
             
             NSString *urlString;
             
             if ([placemark.country rangeOfString:@"United States"].location != NSNotFound) {
                 
                 urlString = [[NSString stringWithFormat:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/%@/%@/.xml", placemark.administrativeArea, placemark.locality] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 
             } else {
                 
                 urlString = [[NSString stringWithFormat:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/%@/%@/.xml", placemark.country, placemark.locality] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             }
             
             
             NSURL* url = [NSURL URLWithString:urlString];
             
             NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
             
             _downloadXMLUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
             
             _downloadXMLData = [NSMutableData data];
             
             [_downloadXMLUrlConnection start];
             
         }
     }];
}

-(void) locationUpdated:(NSString *)status withCoordinate:(CLLocation *)coordinate {
    _location = coordinate;
    
    NSLog(@"%@: %lf, %lf", status, _location.coordinate.latitude, _location.coordinate.longitude);
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location completionHandler:
     ^(NSArray* placemarks, NSError* error) {
         
         if ([placemarks count] > 0)
         {
             //Get nearby address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //String to hold address
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //Print the location to console
             NSLog(@"I am currently at %@",locatedAt);
             NSLog(@"Country: %@",placemark.country);
             NSLog(@"Locality: %@",placemark.locality);
             NSLog(@"Sublocality: %@",placemark.subLocality);
             NSLog(@"AdministrativeArea: %@",placemark.administrativeArea);
             NSLog(@"ISOCountryCode: %@",placemark.ISOcountryCode);
             NSLog(@"Thoroughfare: %@",placemark.thoroughfare);
             
             //Set the label text to current location
             //[locationLabel setText:locatedAt];
             
             if (_downloadXMLUrlConnection) {
                 return;
             }
             
             NSString *urlString;
             
             if ([placemark.country rangeOfString:@"United States"].location != NSNotFound) {
                 
                 urlString = [[NSString stringWithFormat:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/%@/%@/.xml", placemark.administrativeArea, placemark.locality] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 
             } else {
                 
                 urlString = [[NSString stringWithFormat:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/%@/%@/.xml", placemark.country, placemark.locality] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             }
             
             
             NSURL* url = [NSURL URLWithString:urlString];
             
             NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
             
             _downloadXMLUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
             
             _downloadXMLData = [NSMutableData data];
             
             [_downloadXMLUrlConnection start];
             
         }
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_downloadXMLData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadXMLData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _downloadXMLUrlConnection = nil;
    
    NSLog(@"Beleptunk ide is");
    
    NSXMLParser* parser =
    [[NSXMLParser alloc] initWithData:_downloadXMLData];
    BWWeatherXMLParser* parserDelegate = [[BWWeatherXMLParser alloc] init];
    parser.delegate = parserDelegate;
    
    if ([parser parse])
    {
        _forecasts = parserDelegate.forecastElements;
    }

    NSInteger index = 0;
    BWForecast* forecast = [_forecasts objectAtIndex: index];
  
    NSString *text = [NSString stringWithFormat:@"%@ \n%@ \nHigh: %@°C Low: %@°C", forecast.day, forecast.weather, forecast.temp_c_high, forecast.temp_c_low];
    
    // iOS6 and above : Use NSAttributedStrings
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *foregroundColor = [UIColor whiteColor];
    
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldFont, NSFontAttributeName,
                           foregroundColor, NSForegroundColorAttributeName, nil];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attrs];
    
    [self.forecastLabel1 setAttributedText:attributedText];

    index = 1;
    forecast = [_forecasts objectAtIndex: index];
    
    text = [NSString stringWithFormat:@"%@ \n%@ \nHigh: %@°C Low: %@°C", forecast.day, forecast.weather, forecast.temp_c_high, forecast.temp_c_low];
    
    // Create the attributed string (text + attributes)
    attributedText = [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attrs];
    
    [self.forecastLabel2 setAttributedText:attributedText];
    
    index = 2;
    forecast = [_forecasts objectAtIndex: index];
    
    text = [NSString stringWithFormat:@"%@ \n%@ \nHigh: %@°C Low: %@°C", forecast.day, forecast.weather, forecast.temp_c_high, forecast.temp_c_low];
    
    // Create the attributed string (text + attributes)
    attributedText = [[NSMutableAttributedString alloc] initWithString:text
                                                            attributes:attrs];
    
    [self.forecastLabel3 setAttributedText:attributedText];
    
    index = 3;
    forecast = [_forecasts objectAtIndex: index];
    
    text = [NSString stringWithFormat:@"%@ \n%@ \nHigh: %@°C Low: %@°C", forecast.day, forecast.weather, forecast.temp_c_high, forecast.temp_c_low];
    
    // Create the attributed string (text + attributes)
    attributedText = [[NSMutableAttributedString alloc] initWithString:text
                                                            attributes:attrs];
    
    [self.forecastLabel4 setAttributedText:attributedText];
    index = 0;
    for (int i = 0; i < 4; i++) {
        BWForecast* forecast = [_forecasts objectAtIndex: index];
        
        switch (index) {
            case 0:
                self.forecastImage1.contentMode = UIViewContentModeScaleAspectFit;
                
                if ([forecast.weather rangeOfString:@"Cloudy"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cloudypic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Clouds"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Overcast"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"overcastpic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Clear"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"sunny" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Rain"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Drizzle"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Snow"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofsnow" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Thunder"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofstrom" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Haze"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"hazepic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Fog"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Hail"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Dust"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Sand"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                
                if ([forecast.weather rangeOfString:@"Ash"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                } else {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"na" ofType:@"png"];
                    self.forecastImage1.image = [UIImage imageWithContentsOfFile:fullpath];
                }
                
                break;
                
            case 1:
                self.forecastImage2.contentMode = UIViewContentModeScaleAspectFit;
                
                if ([forecast.weather rangeOfString:@"Cloudy"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cloudypic" ofType:@"png"];
                    self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                    
                if ([forecast.weather rangeOfString:@"Clouds"].location != NSNotFound) {
                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"png"];
                        self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                    
                if ([forecast.weather rangeOfString:@"Overcast"].location != NSNotFound) {
                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"overcastpic" ofType:@"png"];
                            self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                            
                if ([forecast.weather rangeOfString:@"Clear"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"sunny" ofType:@"png"];
                    self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                
                if ([forecast.weather rangeOfString:@"Rain"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                    
                if ([forecast.weather rangeOfString:@"Drizzle"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                        
                if ([forecast.weather rangeOfString:@"Snow"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofsnow" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                            
                if ([forecast.weather rangeOfString:@"Thunder"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofstrom" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                                
                if ([forecast.weather rangeOfString:@"Haze"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"hazepic" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                                    
                if ([forecast.weather rangeOfString:@"Fog"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                                        
                if ([forecast.weather rangeOfString:@"Hail"].location != NSNotFound) {
                  NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                  self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                                            
                if ([forecast.weather rangeOfString:@"Dust"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                    self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                    
                if ([forecast.weather rangeOfString:@"Sand"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                    self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                                                                    
                if ([forecast.weather rangeOfString:@"Ash"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                    self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                } else {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"na" ofType:@"png"];
                    self.forecastImage2.image = [UIImage imageWithContentsOfFile:fullpath];
                }
                
                break;
                
            case 2:
                self.forecastImage3.contentMode = UIViewContentModeScaleAspectFit;
                
                if ([forecast.weather rangeOfString:@"Cloudy"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cloudypic" ofType:@"png"];
                    self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                    
                    if ([forecast.weather rangeOfString:@"Clouds"].location != NSNotFound) {
                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"png"];
                        self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                    } else
                        
                        if ([forecast.weather rangeOfString:@"Overcast"].location != NSNotFound) {
                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"overcastpic" ofType:@"png"];
                            self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                        } else
                            
                            if ([forecast.weather rangeOfString:@"Clear"].location != NSNotFound) {
                                NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"sunny" ofType:@"png"];
                                self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                            } else
                                
                                if ([forecast.weather rangeOfString:@"Rain"].location != NSNotFound) {
                                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                                    self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                } else
                                    
                                    if ([forecast.weather rangeOfString:@"Drizzle"].location != NSNotFound) {
                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                                        self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                    } else
                                        
                                        if ([forecast.weather rangeOfString:@"Snow"].location != NSNotFound) {
                                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofsnow" ofType:@"png"];
                                            self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                        } else
                                            
                                            if ([forecast.weather rangeOfString:@"Thunder"].location != NSNotFound) {
                                                NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofstrom" ofType:@"png"];
                                                self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                            } else
                                                
                                                if ([forecast.weather rangeOfString:@"Haze"].location != NSNotFound) {
                                                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"hazepic" ofType:@"png"];
                                                    self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                } else
                                                    
                                                    if ([forecast.weather rangeOfString:@"Fog"].location != NSNotFound) {
                                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                                                        self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                    } else
                                                        
                                                        if ([forecast.weather rangeOfString:@"Hail"].location != NSNotFound) {
                                                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                                                            self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                        } else
                                                            
                                                            if ([forecast.weather rangeOfString:@"Dust"].location != NSNotFound) {
                                                                NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                                                                self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                            } else
                                                                
                                                                if ([forecast.weather rangeOfString:@"Sand"].location != NSNotFound) {
                                                                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                                                                    self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                                } else
                                                                    
                                                                    if ([forecast.weather rangeOfString:@"Ash"].location != NSNotFound) {
                                                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                                                                        self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                                    } else {
                                                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"na" ofType:@"png"];
                                                                        self.forecastImage3.image = [UIImage imageWithContentsOfFile:fullpath];
                                                                    }
                
                break;
            case 3:
                self.forecastImage4.contentMode = UIViewContentModeScaleAspectFit;
                
                if ([forecast.weather rangeOfString:@"Cloudy"].location != NSNotFound) {
                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cloudypic" ofType:@"png"];
                    self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                } else
                    
                    if ([forecast.weather rangeOfString:@"Clouds"].location != NSNotFound) {
                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"png"];
                        self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                    } else
                        
                        if ([forecast.weather rangeOfString:@"Overcast"].location != NSNotFound) {
                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"overcastpic" ofType:@"png"];
                            self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                        } else
                            
                            if ([forecast.weather rangeOfString:@"Clear"].location != NSNotFound) {
                                NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"sunny" ofType:@"png"];
                                self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                            } else
                                
                                if ([forecast.weather rangeOfString:@"Rain"].location != NSNotFound) {
                                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                                    self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                } else
                                    
                                    if ([forecast.weather rangeOfString:@"Drizzle"].location != NSNotFound) {
                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                                        self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                    } else
                                        
                                        if ([forecast.weather rangeOfString:@"Snow"].location != NSNotFound) {
                                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofsnow" ofType:@"png"];
                                            self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                        } else
                                            
                                            if ([forecast.weather rangeOfString:@"Thunder"].location != NSNotFound) {
                                                NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofstrom" ofType:@"png"];
                                                self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                            } else
                                                
                                                if ([forecast.weather rangeOfString:@"Haze"].location != NSNotFound) {
                                                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"hazepic" ofType:@"png"];
                                                    self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                } else
                                                    
                                                    if ([forecast.weather rangeOfString:@"Fog"].location != NSNotFound) {
                                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fogpic" ofType:@"png"];
                                                        self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                    } else
                                                        
                                                        if ([forecast.weather rangeOfString:@"Hail"].location != NSNotFound) {
                                                            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"chanceofrain" ofType:@"png"];
                                                            self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                        } else
                                                            
                                                            if ([forecast.weather rangeOfString:@"Dust"].location != NSNotFound) {
                                                                NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                                                                self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                            } else
                                                                
                                                                if ([forecast.weather rangeOfString:@"Sand"].location != NSNotFound) {
                                                                    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                                                                    self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                                } else
                                                                    
                                                                    if ([forecast.weather rangeOfString:@"Ash"].location != NSNotFound) {
                                                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"smokepic" ofType:@"png"];
                                                                        self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                                    } else {
                                                                        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"na" ofType:@"png"];
                                                                        self.forecastImage4.image = [UIImage imageWithContentsOfFile:fullpath];
                                                                    }
                
                break;

            default:
                break;
        }
        index++;
    }
    
    
    _downloadXMLData = nil;
}


@end
