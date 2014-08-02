//
//  Document.h
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "task.h"

@interface Document : NSDocument

@property (strong, nonatomic) NSArray* tasks;

@end
