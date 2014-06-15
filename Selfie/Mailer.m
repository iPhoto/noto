//
//  Mailer.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Mailer.h"
#import "Mailgun.h"
#import "Utilities.h"

@interface Mailer ()
@property (strong, nonatomic) Mailgun *mailgun;
@end;

@implementation Mailer

- (Mailgun *) mailgun {
    if (!_mailgun) {
        _mailgun = [[Mailgun alloc] init];
    }
    return _mailgun;
}

- (void)enqueueMailTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body {
}

- (void)pollMailQueue {
    NSArray *queue = (NSArray *) [Utilities getSettingsObject:@"emailQueue"];
    NSMutableArray *mutableQueue = [queue mutableCopy];
    
    for (int i = 0; i < [queue count]; i++) {
        NSDictionary *message = (NSDictionary *) [queue objectAtIndex: i];
        [self.mailgun sendMessageTo:[message valueForKey:@"toEmail"]
                               from:[message valueForKey:@"fromEmail"]
                        withSubject:[message valueForKey:@"subject"]
                           withBody:[message valueForKey:@"body"]];
        [mutableQueue removeObjectAtIndex: 0];
        NSLog([message valueForKey:@"subject"]);
    }
    
    [Utilities setSettingsObject:mutableQueue forKey:@"emailQueue"];
}

@end;