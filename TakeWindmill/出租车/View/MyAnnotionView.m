//
//  MyAnnotionView.m
//  MapDemo
//
//  Created by rhjt on 16/7/22.
//  Copyright © 2016年 junjie. All rights reserved.
//

#import "MyAnnotionView.h"

@implementation MyAnnotionView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.centerOffset = CGPointMake(0, 0);
        self.frame = CGRectMake(0, 0, 39, 39);
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
                _bgImageView.image = [UIImage imageNamed:@"iconsend.png"];
        [self addSubview:_bgImageView];
        
        UIImageView *paoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        paoView.image =[UIImage imageNamed:@"iconsend.png"];
        self.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paoView];
        
    }
    return self;
}

@end
