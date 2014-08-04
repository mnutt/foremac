//
//  Task.h
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *command;
@property (strong, nonatomic) NSTask *_task;
@property (strong, nonatomic) NSURL *workingDirectory;
@property (nonatomic, assign) BOOL isValid;

@property (nonatomic) NSMutableString* output;

- (void)initWithLine:(NSString*)line;
- (void)run;

@end
