//
//  ViewController.m
//  JSON2Plist
//
//  Created by hell_ghost on 13.02.16.
//  Copyright © 2016 hell_ghost. All rights reserved.
//

#import "ViewController.h"
#import "FileManagedObject.h"

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _managedObject = [FileManagedObject new];
    [self.objectController add:self.managedObject];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}
- (IBAction)selectSource:(id)sender {
    NSArray *fileTypes = [NSArray arrayWithObjects:@"json", @"plist",nil];
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = fileTypes;
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setFloatingPanel:YES];
    
    NSInteger result = [panel runModal];
    if(result == NSModalResponseOK)
    {
        self.managedObject.filePath = [[panel URLs] firstObject] ;
    }
}

- (IBAction)selectDestanation:(id)sender {
    NSString *path = [self.managedObject.filePath path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self getMIME:self.managedObject.filePath callback:^(NSString * mime) {
            NSSavePanel *panel = [NSSavePanel savePanel];
            NSString *fileName = [self.managedObject.fileName stringByDeletingPathExtension];
            BOOL isJSON = [mime isEqualToString:@"application/json"];
            if (isJSON) {
                fileName = [fileName stringByAppendingPathExtension:@"plist"];
            } else {
                fileName =[fileName stringByAppendingPathExtension:@"json"];
            }
            panel.nameFieldStringValue = fileName;
            
            NSInteger result = [panel runModal];
            NSData *fileData = [NSData dataWithContentsOfURL:self.managedObject.filePath];
            NSError *error = nil;
            if(result == NSModalResponseOK) {
                if (isJSON) {
                    id jsonValues = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
                    if (!error) {
                        if ([jsonValues isMemberOfClass:[NSDictionary class]]) {
                            [((NSDictionary *)jsonValues) writeToURL:[panel URL] atomically:YES];
                        } else {
                            [((NSArray *)jsonValues) writeToURL:[panel URL] atomically:YES];
                        }
                    }
                } else {
                    id plistValues = [NSPropertyListSerialization propertyListWithData:fileData options:0 format:0 error:&error];
                    
                    if (!error) {
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:plistValues options:NSJSONWritingPrettyPrinted error:&error];
                        if (!error) {
                            [jsonData writeToURL:[panel URL] atomically:YES];
                        }
                    }
                }
                if (error) {
                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"Error";
                    alert.informativeText = error.localizedDescription;
                    [alert runModal];
                } else {
                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"File saved";
                    [alert runModal];
                    self.managedObject = [FileManagedObject new];
                }
            }
            
        }];
    }
}

- (void)getMIME:(NSURL *)fileUrl callback:(void(^)(NSString *))callback {
    NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:.1];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:fileUrlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString* mimeType = [response MIMEType];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(mimeType);
            }
        });
    }];
    
    [dataTask resume];
}
@end
