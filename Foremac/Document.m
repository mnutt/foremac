//
//  Document.m
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize tasks;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (NSArray *)tasksFromRawFile:(NSString *)raw
{
    NSMutableArray *taskList;
    NSArray *tasklines = [raw componentsSeparatedByString:@"\n"];
    
    for (NSString *line in tasklines) {
        if([line length] > 0) {
            Task *task = [[Task alloc] init];
            [task initWithLine:line];
            NSLog(@"%@", [task name]);
            [taskList addObject:task];
        }
    }
    
    return taskList;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"%@", data);
    NSString * rawProcfile = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *newTasks = [self tasksFromRawFile:rawProcfile];
    [self setValue:newTasks forKey:@"tasks"];
    
    return YES;
}

@end
