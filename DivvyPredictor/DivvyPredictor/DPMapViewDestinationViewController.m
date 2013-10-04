//
//  DPMapViewDestinationViewController.m
//  DivvyPredictor
//
//  Created by Manikanta.Sanisetty on 10/4/13.
//  Copyright (c) 2013 SolsticeExpress. All rights reserved.
//

#import "DPMapViewDestinationViewController.h"
#import "DCAddressSearchResults.h"

@interface DPMapViewDestinationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *destinationAddressTextField;

@end

@implementation DPMapViewDestinationViewController

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
    [self.destinationAddressTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        
        [self getDestinationLocation:textField.text WithCompletionHandler:^{
            
        }];
        
        
        
        
        
        
//        DCCoordinateForAddressService *service = [[DCCoordinateForAddressService alloc] init];
//        [service getCoordinateForAddress:str withCompletion:^(DCAddressSearchResults *result) {
//            //        Clear pins before adding more pins.
//            [self.googleMapView clear];
//            self.searchedLocation = [[CLLocation alloc] initWithLatitude:[result.latitude doubleValue] longitude:[result.longitude doubleValue]];
//            [self addPinToMap:self.googleMapView ofType:BluePin atLocation:self.searchedLocation.coordinate withUserData:nil];
//            [self moveCameraPositionToLatitude:[result.latitude doubleValue] toLongitude:[result.longitude doubleValue] withZoomLevel:kDefaultZoomLevel];
//            /*
//             Service call to pull locations of cashback bonous (or) miles extras from discover.
//             */
//            [self getLocationsWithLatitude:result.latitude AndLongitude:result.longitude forCampaignId:self.detailedResponse.campaignId];
//        } withFailure:^(ErrorInfo *err) {
//            [(NavigationController *)self.navigationController handleError:err withCompletion:nil];
//            [(NavigationController *)self.navigationController hideProgressIndicatorAnimated:YES];
//        }];
        
        
        
        
        
        
    }
    return YES;
}


- (void)getDestinationLocation:(NSString *)destinationAddress WithCompletionHandler:(void(^)())completionBlock
{
    RKObjectMapping *stationListMapping = [RKObjectMapping mappingForClass:[DCAddressSearchResults class]];
    [stationListMapping addAttributeMappingsFromArray:@[@"results"]];

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stationListMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    NSString *esc_addr =  [destinationAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/maps/api/geocode/json?sensor=true&address=%@", esc_addr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        DCAddressSearchResults *addressSearchResult = [mappingResult.array lastObject];
        NSDictionary *resultDict = [addressSearchResult.results lastObject];
        if (resultDict != nil) {
            addressSearchResult.latitude = [[[resultDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
            addressSearchResult.longitude = [[[resultDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        }
        completionBlock();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}

@end
