//
//  ViewController.m
//  画板涂鸦
//
//  Created by 冷求慧 on 16/2/29.
//  Copyright © 2016年 gdd. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIWindow *windows;
}
@property (weak, nonatomic) IBOutlet DrawView *cusView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self someSet];
}
#pragma mark 一些设置
-(void)someSet{
    self.title=@"画板涂鸦";
    self.cusView.lineWidthFloat=1.0;// 设置默认的宽度
    self.cusView.lineColor=[UIColor darkGrayColor];//设置默认的颜色
    windows=[[UIApplication sharedApplication]keyWindow];
}
#pragma mark 设置线条宽度的操作
- (IBAction)lineWidth:(UIButton *)sender {
    self.cusView.lineWidthFloat=3.0;
}
#pragma mark 相册图片的操作
- (IBAction)albumImageAction:(UIButton *)sender {
    [self openPhotosAlbum];
}
#pragma mark 设置线条颜色的操作
- (IBAction)lineColor:(UIButton *)sender {
    self.cusView.lineColor=[UIColor redColor];
}
#pragma mark 返回的操作
- (IBAction)backAction:(UIButton *)sender {
    [self.cusView backAgoAction];
}
#pragma mark 清除的操作
- (IBAction)cleanAction:(UIButton *)sender {
    [self.cusView cleanAction];
}
#pragma mark 保存的操作(截图)
- (IBAction)saveAction:(UIButton *)sender {
    if (self.cusView.isDraw) {
        [MBProgressHUD showMessage:showNowSave toView:windows];
        UIGraphicsBeginImageContextWithOptions(self.cusView.frame.size, NO, 0); //创建图片内容上下文,设置图片的size,比例
        CGContextRef cusRef=UIGraphicsGetCurrentContext();
        [self.cusView.layer renderInContext:cusRef]; // 绘制 cusView上面的内容
        UIImage *imageObj=UIGraphicsGetImageFromCurrentImageContext(); //得到上下文的图片
        UIImageWriteToSavedPhotosAlbum(imageObj, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);//将图片写入到相册之中
    }
    else{
        [MBProgressHUD showError:showNoDraw];
    }
}
#pragma mark 打开相册
-(void)openPhotosAlbum{
    NSInteger num;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) { //先判断类型
        num=UIImagePickerControllerSourceTypeCamera; //相机
    }
    else{
        num=UIImagePickerControllerSourceTypeSavedPhotosAlbum; //相册
    }
    UIImagePickerController *pickVC=[[UIImagePickerController alloc]init];
    [self presentViewController:pickVC animated:YES completion:nil];
    pickVC.sourceType=num;
    pickVC.allowsEditing=YES;
    pickVC.delegate=self;
}
#pragma mark UIImagePickerControllerDelegate(选中图片后的操作)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    self.cusView.imageAlbum=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 图片写入后的操作
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [MBProgressHUD hideHUDForView:windows animated:YES];
        [MBProgressHUD showSuccess: showSaveSuccess];
    }
    else{
        [MBProgressHUD hideHUDForView:windows animated:YES];
        [MBProgressHUD showError:showSaveFail];
    }
}
@end
