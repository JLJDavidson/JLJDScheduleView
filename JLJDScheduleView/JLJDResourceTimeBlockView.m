/*
  Created by Jason Davidson on 9/11/13.
  Copyright (c) 2013 JLJDavidson, LLC. All rights reserved.

  The resource time block displays a rectangle from the start date time
  through the end date time.  This rectangle is then added to the resource
  day view.

*/


#import <EventKit/EventKit.h>
#import "JLJDResourceTimeBlockView.h"
#import "JLJDResource.h"

float const kJLJDScheduleBlockWidthPerHour = 40.0;
float const kJLJDScheduleBlockHeight = 40.0;
float const kJLJDScheduleBlockWidth = 40.0;

@implementation JLJDResourceTimeBlockView

@synthesize startDateTime = _startDateTime;
@synthesize endDateTime = _endDateTime;

- (id)initWithStartDate:(NSDate *)start
                endDate:(NSDate *)end
              xPosition:
                    (float)x
              yPosition:(float)y {
   NSLog(@"JLJDResourceTimeBlockView started");
   self = [super init];
   if (self) {
      [self setStartDateTime:[start copy]];
      [self setEndDateTime:[end copy]];
      [self setFrame:CGRectMake(x, y, [self calculateBlockWidth],
            kJLJDScheduleBlockWidthPerHour)];
   }
   NSLog(@"JLJDResourceTimeBlockView ended");
   return self;
}

- (CGFloat)calculateBlockWidth {

   long startMilliseconds = [[self startDateTime] timeIntervalSince1970];
   long endMilliseconds = [[self endDateTime] timeIntervalSince1970];
   long millisecondDiff = (endMilliseconds - startMilliseconds);
   float toMinutes = (float) millisecondDiff / 60;
   float toHours = toMinutes / 60;
   return toHours * kJLJDScheduleBlockWidthPerHour;
}

#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
   NSLog(@"JLJDResourceTimeBlockView drawRect started");
   if ([self isMemberOfClass:[JLJDResourceTimeBlockView class]]) {
      // If this isn't a subclass use the default drawing
      [self drawBackground];
      [self drawBorders];
   }
   NSLog(@"JLJDResourceTimeBlockView drawRect ended");

}


#pragma mark Drawing

- (void)drawBackground {
   //TODO change background to match the number items in this block
   UIColor *color = [UIColor orangeColor];
   [color setFill];
   UIRectFill(self.bounds);
}

- (void)drawBorders {
   CGContextRef context = UIGraphicsGetCurrentContext();

   CGContextSetLineWidth(context, 1.0);

   CGContextSaveGState(context);
   CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:255.0 / 255.0
         alpha:1.0].CGColor);
   CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
   CGContextAddLineToPoint(context, 0.5, 0.5);
   CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
   CGContextStrokePath(context);
   CGContextRestoreGState(context);

   CGContextSaveGState(context);
   CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:185.0 / 255.0
         alpha:1.0].CGColor);
   CGContextMoveToPoint(context, self.bounds.size.width - 0.5, 0.0);
   CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, self.bounds.size.height - 0.5);
   CGContextAddLineToPoint(context, 0.0, self.bounds.size.height - 0.5);
   CGContextStrokePath(context);
   CGContextRestoreGState(context);
}

#pragma mark Touch Handlers
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
   NSLog(@"resourceTimeBlockView touches");
   if ([event type] == UIEventTypeTouches) {
      if ([[self delegate] respondsToSelector:@selector
      (resourceTimeBlockView:didSelectTimeBlockStartDateTime:endDateTime:resource:withEvent:)]) {
         [[self delegate]
               resourceTimeBlockView:self
               didSelectTimeBlockStartDateTime:[self startDateTime]
               endDateTime:[self endDateTime]
               resource:[self resource]
               withEvent:[self event]];
      }
   }
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event {
   [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event {
   [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event {
   [super touchesCancelled:touches withEvent:event];
}

@end