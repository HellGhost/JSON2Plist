//
//  FileManagedObject.m
//  JSON2Plist
//
//  Created by hell_ghost on 13.02.16.
//  Copyright © 2016 hell_ghost. All rights reserved.
//

#import "FileManagedObject.h"

@implementation FileManagedObject
- (void)setFilePath:(NSURL *)filePath {
    _filePath = filePath;
    self.fileName = [filePath lastPathComponent];
}
@end
