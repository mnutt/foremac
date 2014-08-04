//
//  Document.h
//  Foremac
//
//  Created by Michael Nutt on 8/2/14.
//  Copyright (c) 2014 nutt.im. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "task.h"
#import "PXSourceList.h"

@interface Document : NSDocument <PXSourceListDataSource, PXSourceListDelegate>

@property (strong, nonatomic) NSArray* tasks;
@property (nonatomic, assign) IBOutlet NSString* rawProcfile;
@property (weak, nonatomic) IBOutlet PXSourceList *sourceList;
@property (strong, nonatomic) NSMutableArray *sourceListItems;
@property (weak, nonatomic) IBOutlet NSTextField *selectedItemLabel;
@property (strong, nonatomic) IBOutlet NSTextView *selectedLog;

@end
