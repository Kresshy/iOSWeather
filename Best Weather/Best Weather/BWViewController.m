//
//  BWViewController.m
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import "BWViewController.h"
#import "BWWeatherXMLParser.h"

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
                 
                 NSString* urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/%@/%@/.xml", placemark.country, placemark.locality];
                 
                 //NSURL* url = [NSURL URLWithString:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/Hungary/Budapest/.xml"];
                 
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
    
    NSURL* url = [NSURL URLWithString:@"http://api.wunderground.com/api/1581002a1df007d6/conditions/forecast/astronomy/q/Hungary/Budapest/.xml"];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    _downloadXMLUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _downloadXMLData = [NSMutableData data];
    
    [_downloadXMLUrlConnection start];
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
    [self.city setText:_weather.city];
    
    _downloadXMLData = nil;
}


@end
