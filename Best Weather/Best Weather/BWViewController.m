//
//  BWViewController.m
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import "BWViewController.h"
#import "BWWeatherXMLParser.h"
#import <QuartzCore/QuartzCore.h>


@interface BWViewController () {

    NSURLConnection* _downloadXMLUrlConnection;
    NSMutableData* _downloadXMLData;
    BWWeather* _weather;

}

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *weather_cond;

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;

@end

@implementation BWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _locationManager = [BWLocationManager sharedInstance];
    _locationManager.delegate = self;
    
    _location = [_locationManager location];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController = self.navigationController;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
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

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    if (_downloadXMLUrlConnection) {
        return;
    }
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
    
    //NSLog([[NSString alloc] initWithData:_downloadXMLData encoding:NSUTF8StringEncoding]);
    
    NSXMLParser* parser =
    [[NSXMLParser alloc] initWithData:_downloadXMLData];
    BWWeatherXMLParser* parserDelegate = [[BWWeatherXMLParser alloc] init];
    parser.delegate = parserDelegate;
    
    if ([parser parse])
    {
        _weather = parserDelegate.weather;
    }
    
    [self.temperature setText:[_weather.temp_c stringByAppendingString:@" °C"]];
    [self.weather_cond setText:_weather.weather];
    [self.city setText:[_weather.city stringByAppendingString:[NSString stringWithFormat:@", %@", _weather.countryCode]]];
    
    self.city.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.weather_cond.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.temperature.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    self.city.layer.cornerRadius = 8;
    self.weather_cond.layer.cornerRadius = 8;
    self.temperature.layer.cornerRadius = 8;
    
    if ([_weather.weather rangeOfString:@"Cloudy"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cloudy" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Clouds"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"clouds" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Overcast"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"overcast" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Clear"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"clear" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Rain"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Drizzle"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Snow"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"snow" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Thunder"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"storm" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Haze"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fog" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor blackColor]];
        [self.weather_cond setTextColor:[UIColor blackColor]];
        [self.temperature setTextColor:[UIColor blackColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Fog"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"fog" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor blackColor]];
        [self.weather_cond setTextColor:[UIColor blackColor]];
        [self.temperature setTextColor:[UIColor blackColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Hail"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"hail" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Dust"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"dust" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Sand"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"sand" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    if ([_weather.weather rangeOfString:@"Ash"].location != NSNotFound) {
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"ash" ofType:@"png"];
        _background.image = [UIImage imageWithContentsOfFile:fullpath];
        [self.city setTextColor:[UIColor whiteColor]];
        [self.weather_cond setTextColor:[UIColor whiteColor]];
        [self.temperature setTextColor:[UIColor whiteColor]];
    }
    
    _downloadXMLData = nil;
}


@end
