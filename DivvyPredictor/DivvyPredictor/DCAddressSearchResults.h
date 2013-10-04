//
//  DCAddressSearchResults.h
//  Discover-Commons
//
//  Created by Manikanta.Sanisetty on 4/16/13.
//  Copyright (c) 2013 Discover Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DCAddressSearchResults : NSObject
@property (strong, nonatomic) NSString *address;
//@property (assign, nonatomic) CLLocationCoordinate2D latitude;
//@property (assign, nonatomic) CLLocationCoordinate2D longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSArray *results;
@end
