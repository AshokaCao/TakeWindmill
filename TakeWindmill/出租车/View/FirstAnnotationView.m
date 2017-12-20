//
//  FirstAnnotationView.m
//  MapDemo
//
//  Created by rhjt on 16/7/22.
//  Copyright © 2016年 junjie. All rights reserved.
//

#import "FirstAnnotationView.h"

@implementation FirstAnnotationView {
    UIImageView *photoImageView;
}

//- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.layer.cornerRadius = 6;
//        self.backgroundColor = [UIColor blueColor];
//        self.clipsToBounds = YES;
//        self.bgView.image = [UIImage imageNamed:@"home_xddjjs_body_pipao.png"];
//        self.bgView.userInteractionEnabled = YES;
//        [self addSubview:self.bgView];
//        
//        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
//        self.topLabel.text = @"我想要去的地方";
//        self.topLabel.textColor = [UIColor whiteColor];
//        self.topLabel.textAlignment = NSTextAlignmentCenter;
//        [self.bgView addSubview:self.topLabel];
//        
//        self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 70, 40)];
//        self.bottomLabel.text = @"北京的某个地方";
//        self.bottomLabel.textColor = [UIColor blueColor];
//        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
//        [self.bgView addSubview:self.bottomLabel];
//        
//        
//        self.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:self.bgView];
//    }
//    return self;
//}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
     self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, 100, 45);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.height*0.5;
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        [bgImageView setImage:[UIImage imageNamed:@"padj_home_body_sjxs_bj_fwz_big"]];
        [self addSubview:bgImageView];
    }
    return self;
}

@end
