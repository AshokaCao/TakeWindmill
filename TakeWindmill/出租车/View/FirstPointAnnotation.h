//
//  FirstPointAnnotation.h
//  MapDemo
//
//  Created by rhjt on 16/7/22.
//  Copyright © 2016年 junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Mymodel.h"
@interface FirstPointAnnotation : NSObject<MKAnnotation>


@property (nonatomic, copy) NSString *title;
- (id)initWithLatitude:(CLLocationDegrees)latitude
           andLongtude:(CLLocationDegrees)longtude;
@property (nonatomic, strong) Mymodel *model;
@end
