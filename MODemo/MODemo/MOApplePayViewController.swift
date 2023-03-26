//
//  MOApplePayViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit
// 1. 导入
import PassKit

// 2. 遵循协议
class MOApplePayViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, PKPaymentAuthorizationControllerDelegate {
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        payment.token // 支付凭证 (发给服务器验证支付是否真实有效)
        payment.billingContact  // 账单信息
        payment.shippingContact // 送货信息
        payment.shippingMethod  // 送货方式
        // TODD 发给服务器验证支付是否真实有效
        // show something
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        moPrint(self, #line, "支付完成回调")
    }
    
    let supportedNetworks = [
        PKPaymentNetwork.amex,
        PKPaymentNetwork.masterCard,
        PKPaymentNetwork.visa,
        PKPaymentNetwork.chinaUnionPay
    ];
    
    // 创建字符请求
    func requestPay() {
        let request = PKPaymentRequest()
        request.countryCode = "CN"  // 国家代码
        request.currencyCode = "CNY"  // RMB的币种代码
        request.merchantIdentifier = "merchant.ApplePayDemoYasin" // 申请的merchantID
        request.supportedNetworks = supportedNetworks // 用户可以进行支付的银行卡
        //    request.requiredBillingContactFields = PKAddressField
        
        // 账单信息设置
        let origiAmount = NSDecimalNumber(mantissa: 1275, exponent: -2, isNegative: false)
        let origiItem = PKPaymentSummaryItem(label: "商品价格", amount: origiAmount, type: PKPaymentSummaryItemType.pending)
        
        let discountAmount = NSDecimalNumber(mantissa: 8, exponent: -2, isNegative: false)
        let discountItem = PKPaymentSummaryItem(label: "优惠折扣", amount: discountAmount, type: PKPaymentSummaryItemType.pending)
        
        let methodsAmount = NSDecimalNumber(value: 0)
        let methodsItem = PKPaymentSummaryItem(label: "包邮", amount: methodsAmount, type: PKPaymentSummaryItemType.pending)
        
        var totalAmount = NSDecimalNumber(value: 0)
        totalAmount = totalAmount.adding(origiAmount)
        totalAmount = totalAmount.adding(discountAmount)
        totalAmount = totalAmount.adding(methodsAmount)
        let item = PKPaymentSummaryItem(label: "momo", amount: totalAmount, type: PKPaymentSummaryItemType.final) // 支付给谁
        
        let summanryItems = [origiItem, discountItem, methodsItem, item]
        request.paymentSummaryItems = summanryItems;
        
        // 显示购物信息并进行字符
        let vc = PKPaymentAuthorizationViewController(paymentRequest: request)
        vc?.delegate = self as PKPaymentAuthorizationViewControllerDelegate
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 8.0, *) { // iOS8.0以上
            // 检查当前设备是否可以支付 (iPhone6以上设备才支持)
            if !PKPaymentAuthorizationViewController.canMakePayments() {
                moPrint(self, #line, "设备不支持ApplePay")
            }
            
            //      if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) {
            //        moPrint(self, #line, "没有绑定银联卡")
            //      }
            if PKPaymentAuthorizationViewController.canMakePayments() {
                requestPay()
            } else {
                moPrint(self, #line, "没有绑定字符卡")
            }
        }
        
        
        
        /*
         let netWork:Array = [PKPaymentNetwork.privateLabel, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
         let canPay:Bool = PKPaymentAuthorizationViewController.canMakePayments()//usingNetworks: netWork
         
         if canPay {
         moPrint(self, #line, "支持Apple Pay")
         // PKPaymentRequest
         let paymentRequest = PKPaymentRequest()
         paymentRequest.currencyCode = "CNY"
         paymentRequest.countryCode = "CN"
         
         // merchantIdentifier
         paymentRequest.merchantIdentifier = "merchant.com.hunk.assistants"
         paymentRequest.merchantCapabilities = [PKMerchantCapability.capability3DS,PKMerchantCapability.capabilityEMV]
         paymentRequest.requiredShippingAddressFields = PKAddressField.all
         
         // support Networks
         paymentRequest.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
         
         // subtotal
         let subTotal = PKPaymentSummaryItem(label:"Subtotal", amount:NSDecimalNumber(string:"101.00"))
         
         // discount
         let dicount = PKPaymentSummaryItem(label:"Discount", amount:NSDecimalNumber(string:"100.00"))
         
         // tax
         let tax = PKPaymentSummaryItem(label:"Tax", amount:NSDecimalNumber(string:"2.00"))
         paymentRequest.paymentSummaryItems = [subTotal,dicount,tax]
         
         // show the apple pay controller
         let payAuth = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
         payAuth?.delegate = self as? PKPaymentAuthorizationViewControllerDelegate
         self.present(payAuth!, animated:true, completion:nil)
         
         } else {
         moPrint(self, #line, "不支持Apple Pay")
         let setupButton = PKPaymentButton(paymentButtonType: PKPaymentButtonType.setUp, paymentButtonStyle: PKPaymentButtonStyle.black)
         setupButton.addTarget(self, action:Selector(("applePaySetupButtonPressed:")), for:UIControlEvents.touchUpInside)
         self.view.addSubview(setupButton)
         setupButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 150)
         }
         */
    }
    
    
    
    
}


