//
//  YBHelpMessageCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/2.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBHelpMessageCell.h"


#define font_Size 14

#define messageContentViewH 100


@implementation YBHelpMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    YBHelpMessage *message = (YBHelpMessage *)model.content;
    CGSize size = [YBHelpMessageCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height+messageContentViewH);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont systemFontOfSize:font_Size]];
    
    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self.textLabel setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.textLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = kTextGreyColor;
    [self.messageContentView addSubview:line];
    self.line = line;
    
    
    UILabel * state = [[UILabel alloc]init];
    state.font = [UIFont systemFontOfSize:font_Size];
    state.textAlignment = NSTextAlignmentRight;
    state.textColor = kTextGreyColor;
    [self.messageContentView addSubview:state];
    self.state = state;
    
    UILabel * label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:font_Size];
    [self.messageContentView addSubview:label];
    self.helpMessage = label;
    
//    UITapGestureRecognizer *textMessageTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextMessage:)];
//    textMessageTap.numberOfTapsRequired = 1;
//    textMessageTap.numberOfTouchesRequired = 1;
//    [self.textLabel addGestureRecognizer:textMessageTap];
//    self.textLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *textMessageTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.messageContentView addGestureRecognizer:textMessageTap];
    self.messageContentView.userInteractionEnabled = YES;
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    YBHelpMessage *message = (YBHelpMessage *)model.content;
    DriverInfo * driverInfo = [DriverInfo yy_modelWithJSON:message.driverInfo];
    self.nicknameLabel.text = driverInfo.VehicleNumber;
    
    //self.textLabel.text = message.message;
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    YBHelpMessage *helpMessage = (YBHelpMessage *)self.model.content;
    if (helpMessage) {
        self.textLabel.text = helpMessage.content;
    }
    
    CGSize textLabelSize = [[self class] getTextLabelSize:helpMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.textLabel.frame = CGRectMake(10, 7, textLabelSize.width, textLabelSize.height);
        self.textLabel.textColor = kTextGreyColor;
        self.portraitStyle = RC_USER_AVATAR_CYCLE;
        
//        self.messageContentView.backgroundColor = [UIColor whiteColor];
//        self.textLabel.backgroundColor = [UIColor whiteColor];
        
        self.bubbleBackgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        
        //messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        //messageContentViewRect.size.width = self.width-16-44;
        
        messageContentViewRect.size = CGSizeMake(self.width-16-44-20, messageContentViewRect.size.height-10);
    
        self.messageContentView.frame = messageContentViewRect;
        
        self.line.frame = CGRectMake(0, 30, messageContentViewRect.size.width, 1);
        self.helpMessage.frame = CGRectMake(self.line.x, self.line.y +10, self.line.width, 30);
        self.state.frame = CGRectMake(0, 0, self.line.width, 30);
        
        if (helpMessage.send.intValue == 1) {
            self.helpMessage.text = @"我的求助信息";
            self.helpMessage.textColor = [UIColor redColor];
            
            self.state.text = [Tools getState:helpMessage.replyStat.intValue];
            self.state.hidden = NO;
        }else{
            self.helpMessage.text = @"对方求助信息";
            self.helpMessage.textColor = BtnBlueColor;
            self.state.hidden = YES;
        }
        
        //self.bubbleBackgroundView.frame =
        //CGRectMake(0, 44, self.width-16-44, 100);
        self.bubbleBackgroundView.frame =
        CGRectMake(0, CGRectGetMaxY(self.helpMessage.frame)+10, self.line.width, textLabelSize.height+40);
        self.bubbleBackgroundView.layer.borderWidth = 1;
        self.bubbleBackgroundView.layer.borderColor = kTextGreyColor.CGColor;
        self.bubbleBackgroundView.layer.cornerRadius = 8;
        self.bubbleBackgroundView.clipsToBounds = YES;
        
//        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
//        self.bubbleBackgroundView.image =
//        [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
//                                                            image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        self.textLabel.frame = CGRectMake(12, 7, textLabelSize.width, textLabelSize.height);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width - (messageContentViewRect.size.width + HeadAndContentSpacing +
                                                  [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame =
        CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image =
        [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                            image.size.height * 0.2, image.size.width * 0.8)];
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}
+ (CGSize)getTextLabelSize:(YBHelpMessage *)message {
    if ([message.content length] > 0) {
        float maxWidth = [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect = [message.content
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font_Size]}
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
    
    if (bubbleSize.width + 12 + 20 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 20;
    } else {
        bubbleSize.width = 50;
    }
    if (bubbleSize.height + 7 + 7 > 40) {
        bubbleSize.height = bubbleSize.height + 7 + 7;
    } else {
        bubbleSize.height = 40;
    }
    
    return bubbleSize;
}

+ (CGSize)getBubbleBackgroundViewSize:(YBHelpMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}
@end
