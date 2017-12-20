//
//  FirstPointAnnotation.m
//  MapDemo
//
//  Created by rhjt on 16/7/22.
//  Copyright © 2016年 junjie. All rights reserved.
//

#import "FirstPointAnnotation.h"
@interface FirstPointAnnotation()

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@end
@implementation FirstPointAnnotation
//@synthesize model =  _ttttt;

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongtude:(CLLocationDegrees)longtude {

    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longtude;
       
    }
    return self;
}


- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

- (void)setModel:(Mymodel *)model {

}

@end
