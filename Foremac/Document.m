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
    
    NSURL *workingDirectory = [[self fileURL] URLByDeletingLastPathComponent];
    
    NSArray *newTasks = [self tasksFromRawFile:rawProcfile];
    [self setValue:newTasks forKey:@"tasks"];
    
    self.sourceListItems = [[NSMutableArray alloc] init];
    PXSourceListItem *mainItem = [PXSourceListItem itemWithTitle:@"PROCESSES" identifier:@"processes"];
    [self.sourceListItems addObject:mainItem];
    
    for (Task *task in self.tasks) {
        PXSourceListItem *item = [PXSourceListItem itemWithTitle:[task name] identifier:[task name]];
        [item setRepresentedObject:task];
        [task setWorkingDirectory:workingDirectory];
        [task run];
        [mainItem addChildItem:item];
    }
    NSLog(@"done loading data from %@", [self fileURL]);
    [self.sourceList reloadData];
    [self.sourceList expandItem:mainItem];
    
    return YES;
}

#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [self.sourceListItems count];
	}
	else {
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


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
    NSLog(@"%@", object);
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return !![(PXSourceListItem *)item badgeValue];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [(PXSourceListItem *)item badgeValue].integerValue;
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return !![item icon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
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
	return NO;
}


- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [self.sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
		[self.selectedItemLabel setStringValue:@"(multiple)"];
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[self.sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
        Task* t = [[self.sourceList itemAtRow:[selectedIndexes firstIndex]] representedObject];
		
        NSLog(@"%@", [t command]);
        [[[self.selectedLog textStorage] mutableString] setString:[t output]];
		[self.selectedItemLabel setStringValue:identifier];
	}
	else {
		[self.selectedItemLabel setStringValue:@"(none)"];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}

@end
