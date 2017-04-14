//
//  DrawView.m
//  画板涂鸦
//
//  Created by 冷求慧 on 16/2/29.
//  Copyright © 2016年 gdd. All rights reserved.
//

#import "DrawView.h"


/**
 *思路:
 */

@interface DrawView(){
    UIBezierPath *path; //一条直线的路径
}
/** 是否开始触摸 */
@property (nonatomic,assign)BOOL isStartTouch;
/** 所有的直线 */
@property (nonatomic,strong)NSMutableArray *allLine;
@end
@implementation DrawView
// 懒加载
-(NSMutableArray *)allLine{
    if(_allLine==nil){
        _allLine=[NSMutableArray array];
    }
    return _allLine;
}
#pragma mark 开始触摸
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isStartTouch=self.isDraw=YES;
    UITouch *touchObj=touches.anyObject; //1.0 得到Touch触摸对象
    CGPoint startPoint=[touchObj locationInView: touchObj.view];// 2.0 得到开始触摸的 Point (起点)
    
    path=[UIBezierPath bezierPath]; //创建一条直线的路径
    [path moveToPoint:startPoint]; //设置起点
    [self.allLine addObject:path]; //将直线添加到直线数组里面
}
#pragma mark 移动触摸
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touchObj=touches.anyObject; // 和上面同理
    CGPoint movePoint=[touchObj locationInView:touchObj.view];

    [path addLineToPoint:movePoint];// 直线连接的点
    [self setNeedsDisplay];
}
#pragma mark 结束触摸
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
}
#pragma mark 重写drawRect:的方法,用来绘制图片
-(void)drawRect:(CGRect)rect{
    if (self.isStartTouch) {
        for (UIBezierPath *linePath in self.allLine) { // 循环数组中的直线路径
            [[self lineColor]set]; // 设置颜色
            [linePath setLineWidth:_lineWidthFloat];// 设置线条的宽度
            [linePath stroke];  // 渲染出来
        }
    }
}
#pragma mark 重写设置线条宽度的Set方法
-(void)setLineWidthFloat:(CGFloat)lineWidthFloat{
    _lineWidthFloat=lineWidthFloat;
    [self setNeedsDisplay];
}
#pragma mark 重写设置线条颜色的Set方法
-(void)setImageAlbum:(UIImage *)imageAlbum{
    _imageAlbum=imageAlbum;
    self.backgroundColor=[UIColor colorWithPatternImage:_imageAlbum]; //将图片设置为背景颜色
    [self setNeedsDisplay];
}
#pragma mark 重写设置线条颜色的Set方法
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor=lineColor;
    [self setNeedsDisplay];
}
#pragma mark 返回
-(void)backAgoAction{
    
    if(self.allLine.count>0){
        [self.allLine removeLastObject]; // 移除数组中最后一个元素
    }
    else{
        self.isDraw=NO;
        [MBProgressHUD showSuccess:showToAgo];
    }
    [self setNeedsDisplay];
}
#pragma mark 清除
-(void)cleanAction{
    if(self.allLine.count>0){
        [self.allLine removeAllObjects]; // 移除数组中所有的元素
    }
    else{
        [MBProgressHUD showError:showNoDraw];
    }
    self.isDraw=NO;
    self.backgroundColor=[UIColor whiteColor];
    [self setNeedsDisplay];
}
@end
