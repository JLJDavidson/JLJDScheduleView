/*
  Created by Jason Davidson on 9/11/13.
  Copyright (c) 2013 JLJDavidson, LLC. All rights reserved.

  Hour of Day view to show the hour in question with delegation capabilities.
  The hour of day is used in the day view title hour block view.

*/


#import "JLJDHourOfDayView.h"


@implementation JLJDHourOfDayView {

}

@synthesize hourOfDay = _hourOfDay;

- (id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
   if (self != nil) {
      self.backgroundColor = [UIColor whiteColor];
   }
   return self;
}


#pragma mark Properties

- (void)setSelectionState:(JLJDScheduleViewHourOfDaySelectionState)selectionState {
   _selectionState = selectionState;
   [self setNeedsDisplay];
}

#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
   NSLog(@"JLJDHourOfDayView drawRect started");

   if ([self isMemberOfClass:[JLJDHourOfDayView class]]) {
      // If this isn't a subclass use the default drawing
      [self drawBackground];
      [self drawBorders];
      [self drawDayNumber];
   }
   NSLog(@"JLJDHourOfDayView drawRect ended");

}


#pragma mark Drawing

- (void)drawBackground {
   switch (self.selectionState) {
      case JLJDScheduleViewHourOfDaySelected:
         [[UIColor greenColor] setFill];
         UIRectFill(self.bounds);
         break;
      case JLJDScheduleViewHourOfDayNotSelected:
         break;
   }
}

- (void)drawBorders {
   CGContextRef context = UIGraphicsGetCurrentContext();

   CGContextSetLineWidth(context, 0.5);

   CGContextSaveGState(context);
   CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
   CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
   CGContextAddLineToPoint(context, 0.5, 0.5);
   CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
   CGContextStrokePath(context);
   CGContextRestoreGState(context);
}

- (void)drawDayNumber {
   UIFont *textFont = [UIFont systemFontOfSize:12.0];
   NSMutableDictionary *textFontAttributes = [NSMutableDictionary
         dictionaryWithObject:[UIFont
         systemFontOfSize:12.0]
         forKey:NSFontAttributeName];
   CGSize textSize = [[_hourOfDay stringValue]
         sizeWithAttributes:textFontAttributes];

   CGRect textRect = CGRectMake(
         ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0)),
         ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
   NSString *hourOfDayText;
   if ([[self hourOfDay] intValue] > 12) {
      hourOfDayText = [NSString stringWithFormat:@"%d",
                                                 ([[self hourOfDay]
                                                       intValue] - 12)];
   } else if ([[self hourOfDay] intValue] == 12) {
      hourOfDayText = [NSString stringWithFormat:@"%d",
                                                 ([[self hourOfDay] intValue])];
   } else {
      hourOfDayText = [NSString stringWithFormat:@"%d",
                                                 ([[self hourOfDay] intValue])];
   }
   [hourOfDayText drawInRect:textRect withAttributes:textFontAttributes];
}

#pragma mark Touch Events
/*
   Handles touch events on the hour of day block
*/
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
   NSLog(@"hourOfDayView handling touch of hour");
   if ([event type] == UIEventTypeTouches) {
      if ([[self delegate] respondsToSelector:@selector
      (hourOfDayView:didSelectHour:)]) {
         [[self delegate] hourOfDayView:self
               didSelectHour:[self hourOfDay]];
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