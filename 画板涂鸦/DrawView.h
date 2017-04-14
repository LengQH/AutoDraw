//
//  DrawView.h
//  AutoDraw
//
//  Created by 冷求慧 on 16/2/29.
//  Copyright © 2016年 gdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
/** 用户是否绘画了 */
@property (nonatomic,assign)BOOL isDraw;
/** 线条的宽度 */
@property (nonatomic,assign)CGFloat lineWidthFloat;
/** 相册的图片 */
@property (nonatomic,copy)UIImage *imageAlbum;
/** 线条的颜色 */
@property (nonatomic,assign)UIColor *lineColor;

/** 返回 */
-(void)backAgoAction;
/** 清除 */
-(void)cleanAction;
@end
