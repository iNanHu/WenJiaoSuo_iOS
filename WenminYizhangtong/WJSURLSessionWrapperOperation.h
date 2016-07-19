//
//  WJSURLSessionWrapperOperation.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/7/17.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSURLSessionWrapperOperation : NSOperation

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask *)task;

@end
