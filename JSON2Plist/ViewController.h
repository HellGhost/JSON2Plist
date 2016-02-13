//
//  ViewController.h
//  JSON2Plist
//
//  Created by hell_ghost on 13.02.16.
//  Copyright © 2016 hell_ghost. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FileManagedObject;
@interface ViewController : NSViewController
@property (strong) IBOutlet NSObjectController *objectController;
@property (nonatomic, strong) FileManagedObject* managedObject;
@end

