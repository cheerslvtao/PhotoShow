//
//  AlipayHandle.m
//  PhotoShow
//
//  Created by SFC-a on 2017/8/25.
//  Copyright © 2017年 lvtao. All rights reserved.
//

#import "AlipayHandle.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayHandle

+(AlipayHandle *)shareAlipay{
    static AlipayHandle * alipayhandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alipayhandle = [[AlipayHandle alloc]init];
    });
    return alipayhandle;
}

//
//选中商品调用支付宝极简支付
//
- (void)AlipayPayWithOrderName:(NSString *)orderName orderNo:(NSString *)orderNo orderAmount:(NSString *)price{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017080107985594";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDNv9/L3Kt5/SzsK4MY0gJvgg7BvD/YgsunIDlFyXib0UuIjvtYgcs6mJyizy9O48ikXyTeBwR5i0IIaSsFAqwMNgoaY7Vo63c7JMu9aV/rOg9tgX0TPFpoBerOrYnDUKven9nSbI23b3Lne/rANCg36NHMqtxNOBR0z33r1k1qhQ937v8D+Iso6hNfo76ecDNwJKSFz7VMbXURCPlKeWzLJ61dSxDHYJ6C/GygInBPfHl+FggqbiTTR84QGKI7wv53DftLCSbvaJ5p4VFSVLBy2WPCkyHVee3CHM2iUgFEhz4N+KrACuMQLGQ+SUwqNyoq7QG2eDCX4ZGNI35VUJFNAgMBAAECggEBAIdU9Lxf6n5z0++H81QJFscHsfMmgoxEA/Zq0KEhku5SrS8mdRbTULy7ExRX2NM4KopLdrF/xia4PXfQzRYfmtDxXpXbDcD0WFmTq1tsC0ZqyykJKh7T7NdNRRQqu1m4H0RwulKZSmHksZynRNjVtbqIri7EF+HGyFXJARd1vzgXHUY2rGepHzCbIdNnLaVNSJfXq+toHuJHdW5dmJiK1MloWlTd5K2alfEI823SYL2OXztUCNlnSS9tpuupz6IlTQy6REOrtvSrJCENDR44JRPduCCl3bUXo09/xiUnKB6CIcQx+Y5v1GgaPrEf4e+QtAuW2mzN7bMreAP2uo+6rZUCgYEA8G7z42vZlKQ09OuVrHFUKUQOIHR9QfKf+EmCkw9bUJb5jr7SlFHMHMLhXXFiIj4OakqndbwiOcn+uH6yft8cSs8bXlkZlROsSWz4LhPkwGfuYvGxNXbI6PoTBno0TMhZxfm5UejwljCwFJ+gN1aN7T12mEbY2HhG/a66uV4GA48CgYEA2xIOOIgVU0hcwqA1ka70NBfDnOcjoMkWDeMLeWTyhiYlaj3DaubJxhnt6RTJzbWNLG1VMFs7hJDFrqj9N5hpriyof31LMcSJ2qlGVrsc7LL3haOTfRi1KVhgyDzsaX+7wMRX+Gw+xtrBJ11wKhWwl6nVRthWboMF1GJmC92TP2MCgYEAiw6g4Bewb9fJCR54IpQpKPTDduHo0AuTmfZqHsPy/FlVXMng4QeuFbRgw7qgF03s6GzlDaMR6Hp7aBlfAyHnKx09pwPBWAdYzd7Ia132H5H8vh0rcNCSwqxf9I8ZUI9P3MDh/g3LmBHwxPzNnTPiQiQaQ1g2cnyeEnrMZAmNUOECgYEAwb8JNrQb8CkaaMLaPbr2nS+7QAQoPWY6jBOWLUm7OCt6gaiYMO5l2z9Jaw+IntcHQRh89CRr0gVb3+ny8P1p0bILX52HKD/DD9EPtVsM7MYnJVkS8tssNaHFDrLa/z8J5SWBC+Nn7eTAWTlJHt9J7Ag26M4iOuDEAh74U1wmgzMCgYAJgKkWd2XHqkzn2fFXa1DJiTQ/bO0NLQS2K8bh2RZdgEq4iqQhy6NtUKuH4jDs4jBgOQOD9w+1xVctlVJCCfldhJXf/owj2eqt1SVRnwe5YhdVd4dVB+3lVWVRGaaA1PI2d09zLkMQmIaU7QS7uDT3FLQNqq1Tr82vgvKVhKEJ0g==";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
//    order.biz_content.body = @""; //(非必填项)商品描述
    order.biz_content.subject = orderName; //商品的标题/交易标题/订单标题/订单关键字等。
    order.biz_content.out_trade_no = orderNo; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = price; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        //NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        if (_delegate && [_delegate respondsToSelector:@selector(payWith:)]) {
            [_delegate payWith:orderString];
        }
        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
    }
}

@end
