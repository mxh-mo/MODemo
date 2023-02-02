//
//  MOAlgorithmList.m
//  MODemoSwift
//
//  Created by mikimo on 2023/2/3.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "MOAlgorithmList.h"

#include <stdio.h>
#include <iostream>

class MOBridge {
public:
    static void runList() {
        std::cout << "Hello, world! \n";
    }
};

@implementation MOAlgorithmList

+ (void)run {
    MOBridge:: runList();
}

@end
