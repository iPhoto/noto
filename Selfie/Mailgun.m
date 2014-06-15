//
//  Mailgun.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/mailcore.h>
#import "Mailgun.h"
#import "Utilities.h"

@interface Mailgun ()

@end;

@implementation Mailgun

NSString *SMTPHostname = @"smtp.mailgun.org";
unsigned int SMTPPort = 465;
NSString *SMTPUsername = @"postmaster@the-leather-apron-club.mailgun.org";
NSString *SMTPPassword = @"0npra6c831w9";

+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
               withID:(NSString *)mailID {
    [Mailgun sendMessageTo:toEmail from:fromEmail withSubject:subject withBody:body withID:mailID withCompletionHandler:nil];
}

+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
               withID:(NSString *)mailID
withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = SMTPHostname;
    smtpSession.port = SMTPPort;
    smtpSession.username = SMTPUsername;
    smtpSession.password = SMTPPassword;
    smtpSession.authType = MCOAuthTypeSASLPlain;
    smtpSession.connectionType = MCOConnectionTypeTLS;
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    
    MCOAddress *from = [MCOAddress addressWithMailbox:fromEmail];
    MCOAddress *to = [MCOAddress addressWithMailbox:toEmail];
    [[builder header] setFrom:from];
    [[builder header] setTo:@[to]];
    [[builder header] setSubject:subject];
    [builder setHTMLBody:body];
    NSData * rfc822Data = [builder data];
    
    MCOSMTPSendOperation *sendOperation =
    [smtpSession sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"Error sending email: %@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setMinimumBackgroundFetchInterval" object:nil];
            
            if (completionHandler) {
                completionHandler(UIBackgroundFetchResultFailed);
            }
            
        } else {
            [Utilities loopThroughMailQueueAndSave:^(NSMutableArray* queue, NSDictionary *message) {
                if ([[message valueForKey:@"id"] isEqualToString:mailID]) {
                    [queue removeObject:message];
                }
                if ([queue count] == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMinimumBackgroundFetchInterval" object:nil];
                }
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultNewData);
                }
            }];
        }
    }];
}

@end;