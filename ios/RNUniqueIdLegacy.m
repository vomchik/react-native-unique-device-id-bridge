
#import "RNUniqueIdLegacy.h"
#import <React/RCTLog.h>
#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

@implementation RNUniqueIdLegacy

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuidUserDefaults = [defaults objectForKey:@"uuid"];
    
    NSString *uuid = [UICKeyChainStore stringForKey:@"uuid"];
    
    if ( uuid && !uuidUserDefaults) {
        [defaults setObject:uuid forKey:@"uuid"];
        [defaults synchronize];
        
    }  else if ( !uuid && !uuidUserDefaults ) {
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        
        [UICKeyChainStore setString:uuidString forKey:@"uuid"];
        
        [defaults setObject:uuidString forKey:@"uuid"];
        [defaults synchronize];
        
        uuid = [UICKeyChainStore stringForKey:@"uuid"];
        
    } else if ( ![uuid isEqualToString:uuidUserDefaults] ) {
        [UICKeyChainStore setString:uuidUserDefaults forKey:@"uuid"];
        uuid = [UICKeyChainStore stringForKey:@"uuid"];
    }
    
    NSLog(@"UUID: %@", uuid);
    
    return @{ @"uniqueId": uuid };
}

@end
  
