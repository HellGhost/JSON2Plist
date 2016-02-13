//
//  FileManagedObject.h
//  JSON2Plist
//
//  Created by hell_ghost on 13.02.16.
//  Copyright © 2016 hell_ghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagedObject : NSObject
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSURL *filePath;
@end
