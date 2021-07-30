//
//  MOPrivateAPIViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOPrivateAPIViewController.h"

@interface MOPrivateAPIViewController ()

@end

@implementation MOPrivateAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 未公开
    Class LSAppliactionWorkspace_Class = NSClassFromString(@"LSApplicationWorkspace");
    
    NSObject *workspace = [LSAppliactionWorkspace_Class performSelector:NSSelectorFromString(@"defaultWorkspace")];
    
    NSArray *applist = [workspace performSelector:NSSelectorFromString(@"allApplications")];
    for (id app in applist) {
        NSLog(@"%@", [app performSelector:NSSelectorFromString(@"applicationIdentifier")]);
    }
    
    // 私有 放在私有框架中的API
    NSString *path = [self decodeString:@"L1N5c3RlbS9MaWJyYXJ5L1ByaXZhdGVGcmFtZXdvcmtzL01vYmlsZUNvbnRhaW5lck1hbmFnZXIuZnJhbWV3b3Jr"];
    NSBundle *container = [NSBundle bundleWithPath:path];
    
    if ([container load]) {
        NSString *container = [self decodeString:@"TUNNQXBwQ29udGFpbmVy"];
        Class appContainer = NSClassFromString(container);
        id test = [appContainer performSelector:@selector(containerWithIdentifier:error:) withObject:[self decodeString:@"Y29tLmFwcGxlLmZhbWlseQ=="] withObject:nil];
        if (test) {
            NSLog(@"存在该应用");
        }
    }
}

/// base64编码
- (NSString *)encodeString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedStr = [data base64EncodedStringWithOptions:0];
    return encodedStr;
}

/// base64解码
- (NSString *)decodeString:(NSString *)string {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodedStr;
}

@end
