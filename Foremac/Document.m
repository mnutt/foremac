//
//  Document.m
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize sourceListItems;

- (id)init
{
    self = [super init];
    if (self) {
        self.sourceListItems = [[NSMutableArray alloc] init];
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
    NSMutableArray *taskList = [[NSMutableArray alloc] init];
    NSArray *tasklines = [raw componentsSeparatedByString:@"\n"];
    
    for (NSString *line in tasklines) {
        if([line length] > 0) {
            Task *task = [[Task alloc] init];
            [task initWithLine:line];
            if([task isValid]) {
                [taskList addObject:task];
            }
        }
    }
    
    return taskList;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSString * rawProcfile = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self setValue:rawProcfile forKey:@"rawProcfile"];
    
    NSArray *newTasks = [self tasksFromRawFile:rawProcfile];
    [self setValue:newTasks forKey:@"tasks"];
    
    PXSourceListItem *mainItem = [PXSourceListItem itemWithTitle:@"PROCESSES" identifier:@"processes"];
    PXSourceListItem *fooItem = [PXSourceListItem itemWithTitle:@"FOO" identifier:@"foo"];
    [mainItem setChildren:[NSArray arrayWithObject:fooItem]];
    [self.sourceListItems addObject:mainItem];
    
    for (Task *task in self.tasks) {
        PXSourceListItem *item = [PXSourceListItem itemWithTitle:[task name] identifier:[task name]];
        //[item setRepresentedObject:task];
        [mainItem addChildItem:item];
    }
    [self.sourceList reloadData];
    
    return YES;
}


#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
    NSLog(@"# children");
    NSLog(@"%li", [self.sourceListItems count]);
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [self.sourceListItems count];
	}
	else {
        NSLog(@"count: %li", [[item children] count]);
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [self.sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return NO;
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return NO;
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"processes"])
		return YES;
	
	return NO;
}


- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSLog(@"clicked");
}


@end
