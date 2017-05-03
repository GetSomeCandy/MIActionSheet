//
//  MIActionSheetView.h
//  ActionSheet
//
//  Created by mac2 on 2017/4/27.
//  Copyright © 2017年 mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MIActionSheetView;

typedef NS_ENUM(NSInteger, MIActionSheetStyle) {
    MIActionSheetStyleDefault     = 0,//默认
    MIActionSheetStyleCancel      = 1 << 1,//取消类型
    MIActionSheetStyleDestructive = 1 << 2,//类似"删除"类型
};

@interface MIActionSheetViewAction: NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(MIActionSheetStyle)style handle:(nullable void (^)(MIActionSheetView * actionSheetView))handle;

- (instancetype)initWithTitle:(nullable NSString *)title style:(MIActionSheetStyle)style handle:(nullable void (^)(MIActionSheetView * actionSheetView))handle;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) MIActionSheetStyle style;

@end

@interface MIActionSheetView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray<MIActionSheetViewAction *> *actions;

+ (instancetype)actionSheetViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(MIActionSheetViewAction *)action;

- (void)show;

@end
