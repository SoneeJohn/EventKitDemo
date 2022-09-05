//
//  AppDelegate.m
//  EventKitDemo
//
//  Created by Wolfgang on 9/3/22.
//

#import "AppDelegate.h"
@import EventKit;

@interface AppDelegate ()
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NSWindow *window;
@property (strong) EKEventStore *eventStore;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self setEventStore:[EKEventStore new]];
        
    if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
        [[self eventStore] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self displayCalendarInfo];
                }];
            }
        }];
    } else {
        [self displayCalendarInfo];
    }
}

- (void)displayCalendarInfo
{
    NSMutableString *info = [@"Calendars:\n\n" mutableCopy];
    
    [[[self eventStore] calendarsForEntityType:EKEntityTypeEvent] enumerateObjectsUsingBlock:^(EKCalendar * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [info appendString:[NSString stringWithFormat:@"%@ — calendar type: %@ — %@\n",[obj title], [obj type] == EKCalendarTypeExchange ? @"Exchange" : @"NonExchange Type", [obj calendarIdentifier]]];
    }];

    [[self textView] setString:[info copy]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
