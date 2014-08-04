//
//  Task.m
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize workingDirectory;

- (void)initWithLine:(NSString*) line {
    NSArray *commentParts = [line componentsSeparatedByString:@"#"];
    NSString *nonComment = commentParts[0];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([A-Za-z-_]*):\\s*(.*)$" options:0 error:nil];
    NSArray *parts = [regex matchesInString:nonComment options:0 range:NSMakeRange(0, [nonComment length])];

    if([parts count] == 1 && [parts[0] numberOfRanges] == 3) {
        NSTextCheckingResult *match = parts[0];
        [self setValue:[line substringWithRange:[match rangeAtIndex:1]] forKey:@"name"];
        [self setValue:[line substringWithRange:[match rangeAtIndex:2]] forKey:@"command"];
        [self setIsValid:YES];
    } else {
        [self setIsValid:NO];
    }
}

- (void)run {
    self.output = [[NSMutableString alloc] init];
    self._task = [[NSTask alloc] init];
    
    NSLog(@"working dir is %@", [[self workingDirectory] path]);
    self._task.currentDirectoryPath = [[self workingDirectory] path];
    self._task.launchPath = @"/bin/bash";
    self._task.arguments = @[@"-l", @"-i", @"-c", [NSString stringWithFormat:@"\'%@\'", [self command], nil]];
    
    self._task.standardOutput = [NSPipe pipe];
    self._task.standardError = [NSPipe pipe];
    [[self._task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData]; // this will read to EOF, so call only once
        NSLog(@"Task output! %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        // if you're collecting the whole output of a task, you may store it on a property
        [self.output appendString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    }];
    [[self._task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData]; // this will read to EOF, so call only once
        NSLog(@"Task error! %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        // if you're collecting the whole output of a task, you may store it on a property
        [self.output appendString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    }];
    
    [self._task setTerminationHandler:^(NSTask *task) {
        
        // do your stuff on completion
        
        [task.standardOutput fileHandleForReading].readabilityHandler = nil;
        [task.standardError fileHandleForReading].readabilityHandler = nil;
    }];
    
    [self._task launch];
}

@end
