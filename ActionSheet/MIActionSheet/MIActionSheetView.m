//
//  MIActionSheetView.m
//  ActionSheet
//
//  Created by mac2 on 2017/4/27.
//  Copyright © 2017年 mac2. All rights reserved.
//

#import "MIActionSheetView.h"

#define ACTION_HEIGHT      60
#define ANIMATION_DURATION 0.2
#define MARGIN_SECTION     8
#define MARGIN_SINGLE_LINE 1
#define ALPHA_VIEW         0.3

typedef void (^ActionHandle)(MIActionSheetView * actionSheetView);

@interface MIActionSheetViewAction ()

@property (nonatomic, copy) ActionHandle actionHandle;

@end

@implementation MIActionSheetViewAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(MIActionSheetStyle)style handle:(nullable void (^)(MIActionSheetView * actionSheetView))handle
{
    return [[self alloc] initWithTitle:title style:style handle:handle];
}

- (instancetype)initWithTitle:(nullable NSString *)title style:(MIActionSheetStyle)style handle:(nullable ActionHandle)handle
{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _actionHandle = handle;
    }
    return self;
}

@end

@interface MIActionSheetView ()

@property (nonatomic, strong) NSMutableArray * actionsMutableArray;
@property (nonatomic, strong) NSMutableArray * buttonsArray;
@property (nonatomic, strong) NSMutableArray * actionViewsArray;
@property (nonatomic, strong) UIVisualEffectView * actionsView;
@property (nonatomic, strong) UIView * cancelView;
@property (nonatomic, strong) UILabel * cancelLabel;

@end

@implementation MIActionSheetView

+ (instancetype)actionSheetViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [[MIActionSheetView alloc] initWithTitle:title message:message];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        
        [self initViews];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initViews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    //加按钮们的父view
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _actionsView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _actionsView.frame = CGRectMake(0, screenSize.height, screenSize.width, ACTION_HEIGHT);
    [self addSubview:_actionsView];
    
    //title and message
    if (_title.length > 0 || _message.length > 0) {//有标题
        UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _actionsView.bounds.size.width, ACTION_HEIGHT)];
        titleView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:ALPHA_VIEW];
        [_actionsView addSubview:titleView];
        
        if ((_title.length > 0 && _message.length == 0) || (_title.length == 0 && _message.length > 0)) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height)];
            titleLabel.text = _title.length > 0 ? _title : _message;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1.];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleView addSubview:titleLabel];
        }
        else
        {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, titleView.bounds.size.width, titleView.bounds.size.height / 2.0)];
            titleLabel.text = _title;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1.];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleView addSubview:titleLabel];
            
            UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), titleView.bounds.size.width, 15)];
            detailLabel.text = _message;
            detailLabel.font = [UIFont systemFontOfSize:13];
            detailLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1.];
            detailLabel.textAlignment = NSTextAlignmentCenter;
            [titleView addSubview:detailLabel];
        }
    }
    
    //必加取消按钮
    _cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, _actionsView.bounds.size.height - ACTION_HEIGHT, screenSize.width, ACTION_HEIGHT)];
    _cancelView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:ALPHA_VIEW];
    [_actionsView.contentView addSubview:_cancelView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 0, _cancelView.bounds.size.width, _cancelView.bounds.size.height);
    [cancelButton addTarget:self action:@selector(cancelOperation) forControlEvents:UIControlEventTouchUpInside];
    [_cancelView addSubview:cancelButton];
    
    _cancelLabel = [[UILabel alloc] initWithFrame:cancelButton.bounds];
    _cancelLabel.font = [UIFont systemFontOfSize:16];
    _cancelLabel.text = @"取消";
    _cancelLabel.textColor = [UIColor blackColor];
    _cancelLabel.textAlignment = NSTextAlignmentCenter;
    [_cancelView addSubview:_cancelLabel];
}

#pragma mark - private selector

- (void)addAction:(MIActionSheetViewAction *)action
{
    if (action.style == MIActionSheetStyleCancel) {
        _cancelLabel.text = action.title;
        return;
    }
    
    CGFloat actionViewOriginY = 0;
    if (_title.length > 0 || _message.length > 0) {
        actionViewOriginY = ACTION_HEIGHT + MARGIN_SINGLE_LINE;
    }
    else
    {
        actionViewOriginY = 0;
    }
    UIView * actionView = [[UIView alloc] initWithFrame:CGRectMake(0, actionViewOriginY, _actionsView.bounds.size.width, ACTION_HEIGHT)];
    actionView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:ALPHA_VIEW];
    [_actionsView.contentView addSubview:actionView];
    
    UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionButton.frame = CGRectMake(0, 0, actionView.bounds.size.width, actionView.bounds.size.height);
    [actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:actionButton];
    
    UILabel * actionLabel = [[UILabel alloc] initWithFrame:actionButton.bounds];
    actionLabel.font = [UIFont systemFontOfSize:16];
    actionLabel.text = action.title;
    actionLabel.textColor = [UIColor blackColor];
    actionLabel.textAlignment = NSTextAlignmentCenter;
    [actionView addSubview:actionLabel];
    
    if (action.style == MIActionSheetStyleDestructive) {
        actionLabel.textColor = [UIColor redColor];
    }
    
    if (action) {
        [self.actionsMutableArray addObject:action];
        [self.buttonsArray addObject:actionButton];
        [self.actionViewsArray addObject:actionView];
        self.actions = [self.actionsMutableArray copy];
    }
}

- (void)cancelOperation
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        weakSelf.actionsView.frame = CGRectMake(0, weakSelf.bounds.size.height, weakSelf.bounds.size.width, weakSelf.actionsView.bounds.size.height);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - public seletor

- (void)show
{
    CGFloat actionsViewHeight = (_actionViewsArray.count + 1) * ACTION_HEIGHT + MARGIN_SECTION + MARGIN_SINGLE_LINE * (_actionViewsArray.count - 1);
    if (_title.length > 0 || _message.length > 0) {
        actionsViewHeight = (_actionViewsArray.count + 2) * ACTION_HEIGHT + MARGIN_SECTION + MARGIN_SINGLE_LINE * (_actionViewsArray.count);
    }
    
    CGFloat actionsViewOriginY = self.bounds.size.height - actionsViewHeight;
    _actionsView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, actionsViewHeight);
    _cancelView.frame = CGRectMake(0, actionsViewHeight - ACTION_HEIGHT, _actionsView.bounds.size.width, ACTION_HEIGHT);
    
    for (int i = 0; i < self.actionViewsArray.count; i ++) {
        UIView * anActionView = [self.actionViewsArray objectAtIndex:i];
        
        CGFloat anActionViewOriginY = ACTION_HEIGHT * i + MARGIN_SINGLE_LINE * (i - 1);
        if (_title.length > 0 || _message.length > 0) {
                anActionViewOriginY = (ACTION_HEIGHT + MARGIN_SINGLE_LINE) * (i + 1);
        }
        anActionView.frame = CGRectMake(0, anActionViewOriginY, _actionsView.bounds.size.width, ACTION_HEIGHT);
    }
    
    //加载并做动画
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_VIEW];
        weakSelf.actionsView.frame = CGRectMake(0, actionsViewOriginY, weakSelf.actionsView.bounds.size.width, weakSelf.actionsView.bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - actions

- (void)actionButtonClick:(UIButton *)button
{
    [self cancelOperation];
    
    NSInteger index = [self.buttonsArray indexOfObject:button];
    MIActionSheetViewAction * action = [self.actionsMutableArray objectAtIndex:index];
    if (action.actionHandle) {
        action.actionHandle(self);
    }
}

- (void)dismissView:(UITapGestureRecognizer *)tap
{
    [self cancelOperation];
}


#pragma mark - lazy load

- (NSMutableArray *)actionsMutableArray
{
    if (!_actionsMutableArray) {
        _actionsMutableArray = [NSMutableArray array];
    }
    return _actionsMutableArray;
}

- (NSMutableArray *)buttonsArray
{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

- (NSMutableArray *)actionViewsArray
{
    if (!_actionViewsArray) {
        _actionViewsArray = [NSMutableArray array];
    }
    return _actionViewsArray;
}

@end














