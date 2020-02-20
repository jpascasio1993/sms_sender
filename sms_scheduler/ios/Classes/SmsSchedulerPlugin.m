#import "SmsSchedulerPlugin.h"
#if __has_include(<sms_scheduler/sms_scheduler-Swift.h>)
#import <sms_scheduler/sms_scheduler-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sms_scheduler-Swift.h"
#endif

@implementation SmsSchedulerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmsSchedulerPlugin registerWithRegistrar:registrar];
}
@end
