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
@property (nonatomic, assign) BOOL isValid;

- (void)initWithLine:(NSString*)line;

@end
