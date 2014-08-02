//
//  Task.m
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import "Task.h"

@implementation Task

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

@end
