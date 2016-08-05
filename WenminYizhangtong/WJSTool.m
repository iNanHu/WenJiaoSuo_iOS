//
//  WJSTool.m
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/24.
//  Copyright © 2016年 alexyang. All rights reserved.
//
#import <ASIFormDataRequest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "WJSDataModel.h"
#import <TFHpple.h>
#import "WJSTool.h"


@implementation WJSTool

+ (UIImage *)ImageWithColor:(UIColor*)bgColor andFrame:(CGRect) rect {
    // 使用颜色创建UIImage
    CGSize imageSize = CGSizeMake(rect.size.width, rect.size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [bgColor set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

+ (UIImage*) createRaduisImageWithColor: (UIColor*) color andFrame:(CGRect) rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = CGRectGetWidth(rect)/2;
    CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    //画圆
    CGContextAddArc(ctx, radius, radius, radius, 0, 2*M_PI, 0);
    CGContextFillPath(ctx);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+(NSDictionary *) getQuotationWithServ:(NSString*)servAddr andWJSId:(NSInteger) wjsId{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%ld",servAddr,(long)wjsId];
    NSError *error;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *htmlData = [[NSString stringWithContentsOfURL:[NSURL
                                                           URLWithString: strUrl]
                                                 encoding:enc error:&error]
                        dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strHtmlData = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *strHead = @"<h3 class=\"indextitle\"><a> 总览</a></h3>";
    NSString *strEnd = @"<h3 class=\"indextitle\"><a> 综合指数分时线</a></h3>";
    NSRange rangeHead = [strHtmlData rangeOfString:strHead];
    if (rangeHead.location == NSNotFound)
        return nil;
    NSRange rangeEnd = [strHtmlData rangeOfString:strEnd];
    if (rangeEnd.location == NSNotFound)
        return nil;
    NSInteger keyStart = rangeHead.location + rangeHead.length;
    NSInteger keyLen = rangeEnd.location - keyStart;
    NSRange rangeKey = NSMakeRange(keyStart, keyLen);
    NSString *strKeyData = [strHtmlData substringWithRange:rangeKey];
    strKeyData = [strKeyData stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    strKeyData = [strKeyData stringByReplacingOccurrencesOfString:@" " withString:@""];
    rangeHead = [strKeyData rangeOfString:@"<ul>"];
    rangeEnd = [strKeyData rangeOfString:@"</ul>"];
    keyStart = rangeHead.location + rangeHead.length;
    keyLen = rangeEnd.location - keyStart;
    rangeKey = NSMakeRange(keyStart, keyLen);
    strKeyData = [strKeyData substringWithRange:rangeKey];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[strKeyData dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//li"]; // get the title
    NSLog(@"%lu",(unsigned long)[elements count]);
    
    NSArray *arrTitleName = @[@"上涨数",@"下跌数",@"平盘数",@"交易中藏品",@"藏品总数",@"今日开盘",@"昨日收盘",@"最高指数",@"最低指数",@"成交量",@"成交额",@"更新时间"];
    NSMutableDictionary *dicQuotaion = [[NSMutableDictionary alloc]init];
    [dicQuotaion setObject:[NSNumber numberWithInteger:wjsId] forKey:@"wjsId"];
    for(int i = 0; i < [elements count]; i++) {
        TFHppleElement *element = [elements objectAtIndex:i];
        NSString *strRaw = [element raw];
        NSRange rangeRaw = [self rangeWithSrc:strRaw withHead:@"<span>" andEnd:@"</span>"];
        if (rangeRaw.location == NSNotFound) {
            rangeRaw = [self rangeWithSrc:strRaw withHead:@"<spanclass>" andEnd:@"</spanclass>"];
        }
        if (rangeRaw.location == NSNotFound) {
            rangeRaw = [self rangeWithSrc:strRaw withHead:@"<spanclass=\"t-green\">" andEnd:@"</span>"];
        }
        if (rangeRaw.location == NSNotFound) {
            rangeRaw = [self rangeWithSrc:strRaw withHead:@"<spanclass=\"t-red\">" andEnd:@"</span>"];
        }
        if (rangeRaw.location == NSNotFound) continue;
        NSString *keyVal = [strRaw substringWithRange:rangeRaw];
        NSLog(@"keyVal: %@",keyVal);
        [dicQuotaion setObject:keyVal forKey:arrTitleName[i]];
    }
    
    return [NSDictionary dictionaryWithDictionary:dicQuotaion];
}

+ (NSRange)rangeWithSrc:(NSString *)strSrc withHead:(NSString *)strHead andEnd:(NSString *)strEnd {
    NSRange rangeHead = [strSrc rangeOfString:strHead];
    NSRange rangeEnd = [strSrc rangeOfString:strEnd];
    
    NSInteger keyStart = rangeHead.location + rangeHead.length;
    NSInteger keyLen = rangeEnd.location - keyStart;
    NSRange rangeKey = NSMakeRange(keyStart, keyLen);
    
    return rangeKey;
}

+(void)getPostResult:(NSString*)startqi{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@""]];
    
    [request setPostValue:startqi forKey:@"startqi"];
    [request setPostValue:@"20990101001" forKey:@"endqi"];
    [request setPostValue:@"qihao" forKey:@"searchType"];//网页的中的搜索方式
    [request startSynchronous];
    
    NSData* data = [request responseData];
    
    if (data==nil) {
        NSLog(@"has not data");
    }
    else{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
        NSLog(@"html = %@",retStr);
    }
}

+ (NSString *)getMD5Val:(NSString *)strVal {
    const char *original_str = [strVal UTF8String];//string为摘要内容，转成char
    
    /****系统api~~~~*****/
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);//调通系统md5加密
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02x", result[i]];
    return hash ;//校验码
}

+ (BOOL) validateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateUserName:(NSString *)name

{
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    BOOL B = [userNamePredicate evaluateWithObject:name];
    
    return B;
    
}

#pragma 验证码判断
+ (BOOL)chekSecurityCode:(NSString *) code {
    
    if (code && ![code isEqualToString:@""])
        return YES;
    return NO;
}

#pragma 正则匹配手机号

+ (BOOL)validateMobile:(NSString*) telNumber {
    
    if (!telNumber || [telNumber isEqualToString:@""] || telNumber.length != 11)
        return NO;
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

#pragma 正则匹配用户密码6-18位数字和字母组合

+ (BOOL)validatePassword:(NSString*) password {
    
    if (!password || [password isEqualToString:@""])
        return NO;
    
    NSString *passWordRegex = @"^[a-zA-Z][a-zA-Z0-9]{5,17}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:password];
}


+ (BOOL) validateIdentityCard: (NSString *)identityCard

{
    
    BOOL flag;
    
    if (identityCard.length <= 0) {
        
        flag = NO;
        
        return flag;
        
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}
@end
