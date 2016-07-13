//
//  PersonDetailVC.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/11.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWSelectCityView.h"
#import "PickerChoiceView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PersonDetailVC : UIViewController<UIActionSheetDelegate,TFPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIActionSheet *myActionSheet;
@end
