//
//  NSAlert+SynchronousSheet.h
//
//  Created by Philipp Mayerhofer on 6/10/11.
//  Copyright 2011 Incredible Bee Ltd. Released under the New BSD License.
//  https://github.com/incbee/NSAlert-SynchronousSheet
//
// Slightly modified by me (Tomas Persson) Nov 10, 2011
//
#import "NSAlert.h"

@interface NSAlert ()
-(IBAction) stopSheet:(id)sender;
-(void) beginSheetModalForWindow:(NSWindow *)aWindow;
@end

@implementation NSAlert (SynchronousSheet)

-(NSInteger) runModal:(NSWindow *)aWindow {
	
	// Set ourselves as the target for button clicks
	for (NSButton *button in [self buttons]) {
		[button setTarget:self];
		[button setAction:@selector(stopSheet:)];
	}
	
	// Bring up the sheet and wait until stopSynchronousSheet is triggered by a button click
	[self performSelectorOnMainThread:@selector(beginSheetModalForWindow:) withObject:aWindow waitUntilDone:YES];
	NSInteger modalCode = [NSApp runModalForWindow:[self window]];
	
	// This is called only after stopSynchronousSheet is called (that is,
	// one of the buttons is clicked)
	[NSApp performSelectorOnMainThread:@selector(endSheet:) withObject:[self window] waitUntilDone:YES];
	
	// Remove the sheet from the screen
	[[self window] performSelectorOnMainThread:@selector(orderOut:) withObject:self waitUntilDone:YES];
	
	return modalCode;
}

#pragma mark Private methods

-(IBAction) stopSheet:(id)sender {
	// See which of the buttons was clicked
	NSUInteger clickedButtonIndex = [[self buttons] indexOfObject:sender];
	NSInteger modalCode = 0;
	
	if (clickedButtonIndex == NSAlertFirstButtonReturn) {
		modalCode = NSAlertFirstButtonReturn;
		
	} else if (clickedButtonIndex == NSAlertSecondButtonReturn) {
		modalCode = NSAlertSecondButtonReturn;
		
	} else if (clickedButtonIndex == NSAlertThirdButtonReturn) {
		modalCode = NSAlertThirdButtonReturn;
		
	} else {
		modalCode = NSAlertThirdButtonReturn + (clickedButtonIndex - 2);
	}
	
	[NSApp stopModalWithCode:modalCode];
}

-(void) beginSheetModalForWindow:(NSWindow *)aWindow {
	[self beginSheetModalForWindow:aWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

@end