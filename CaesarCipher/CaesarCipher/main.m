//
//  main.m
//  CaesarCipher
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaesarCipher : NSObject

- (NSString *)decode:(NSString *)string offset:(NSInteger)offset;
- (NSString *)encode:(NSString *)string offset:(NSInteger)offset;
- (BOOL)isSameMessage:(NSString *)msg1 asMessage:(NSString *)msg2;

@end

@implementation CaesarCipher

- (NSString *)encode:(NSString *)string offset:(NSInteger)offset {
    
    // if offset is an illegal value, the assert statement will
    // fail and the app will crash with the provided error message
    if (offset > 25) {
        NSAssert(offset < 26, @"offset is out of range. 1 - 25");
    }
    
    // unsigned can be positive only (like size_t)
    unsigned long count = [string length];
    
    // unicode character arrays for encoded string and for buffer
    unichar result[count];
    unichar buffer[count];
    
    // use getCharacters:range: to copy string characters to buffer
    [string getCharacters:buffer range:NSMakeRange(0, count)];

    // go through the buffer character by character
    for (NSInteger i = 0; i < count; i++) {
        
        // if the character is a space or punctuation, copy the same exact thing
        // to result
        if (buffer[i] == ' ' || ispunct(buffer[i])) {
            result[i] = buffer[i];
            continue;
        }
        
        // islower is a c function that returns true or false.
        // if it returns true, the switch statement returns the unicode decimal
        // position for the letter 'a' which is 97.
        // if it returns false, the switch statement returns the unicode decimal
        // position for the letter 'A' which is 65.
        NSInteger low = islower(buffer[i]) ? 'a' : 'A';
        
//        // DEBUG
//        NSLog(@"Index %ld is letter %c or int %ld.", i, buffer[i], low);
        
        // buffer[i]%low will give distance from 'a' or 'A' of the old char
        // adding the offset will give the distance from 'a' or 'A' of the
        // new char
        // modulo 26 ensures the values are only between 1 and 26
        // and adding low back gives us the correct unicode decimal of the new
        // char
        result[i] = (buffer[i]%low + offset)%26 + low;
        
//        // DEBUG
//        NSLog(@"buffer[%ld]:%u %% low:%ld + offset:%ld = %ld", i, buffer[i], low,
//              offset, (buffer[i]%low+offset));
//        NSLog(@"%ld %% 26 + low:%ld = %ld", buffer[i]%low+offset, low,
//              ((buffer[i]%low+offset)%26+low) );
    }

    // using unichar array we make a new string and return it
    return [NSString stringWithCharacters:result length:count];
}

- (NSString *)decode:(NSString *)string offset:(NSInteger)offset {
    
    // will run encode method using an offset that will return it to the original
    // EXAMPLE: offset 1 to encode becomes offset 25 to decode
    // EXAMPLE: offset 8 to encode becomes offset 18 to decode
    // both encoder and decoder only need to knwow what the original offset
    // was. The decode method will do the rest
    return [self encode:string offset: (26 - offset)];
}

- (BOOL)isSameMessage:(NSString *)msg1 asMessage:(NSString *)msg2 {
    
    unsigned long count = [msg1 length];
    
    if (count != [msg2 length]) {
        NSLog(@"Number of letters is different.");
        return NO;
    }
    
    unichar buffer1[count];
    unichar buffer2[count];
    
    [msg1 getCharacters:buffer1 range:NSMakeRange(0, count)];
    [msg2 getCharacters:buffer2 range:NSMakeRange(0, count)];
    
    NSInteger zeroIndexDistance = 0;
    NSInteger otherIndexDistance = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        if (isalnum(buffer1[i]) && isalnum(buffer2[i])) {
            if (i == 0) {
                zeroIndexDistance = buffer1[i] - buffer2[i];
                if (zeroIndexDistance < 0) {
                    zeroIndexDistance += 26;
                }
//                // DEBUG
//                NSLog(@"buffer1[%ld] is %u", i, buffer1[i]);
//                NSLog(@"buffer2[%ld] is %u", i, buffer2[i]);
//                NSLog(@"zeroIndexDistance is: %ld", zeroIndexDistance);
            } else {
                otherIndexDistance = buffer1[i] - buffer2[i];
                if (otherIndexDistance < 0) {
                    otherIndexDistance += 26;
                }
//                // DEBUG
//                NSLog(@"buffer1[%ld] is %u", i, buffer1[i]);
//                NSLog(@"buffer2[%ld] is %u", i, buffer2[i]);
//                NSLog(@"otherIndexDistance is: %ld", otherIndexDistance);
                if (zeroIndexDistance != otherIndexDistance) {
                    return NO;
                }
            }
        } else {
            if (buffer1[i] != buffer2[i]) {
                NSLog(@"characters at %ld index are not the same type of character.", i);
                return NO;
            }
        }


    }
    
    return YES;
    
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        CaesarCipher *cc = [[CaesarCipher alloc] init];
        
        NSString *name = @"Elber";
        NSInteger offset1 = 1;
        NSString *encodedNameA = [cc encode:name offset:offset1];
        NSLog(@"%@ encoded with offset of %ld is %@", name, offset1,
              encodedNameA);
        
        NSInteger offset13 = 13;
        NSString *encodedNameB = [cc encode:name offset:offset13];
        NSLog(@"%@ encoded with offset of %ld is %@", name, offset13,
              encodedNameB);
        
        NSString *message1 = @"I like my cookies just fine, thanks.";
        NSInteger offset22 = 22;
        NSString *encodedMessage1A = [cc encode:message1 offset:offset22];
        NSLog(@"\n");
        NSLog(@"original message: %@", message1);
        NSLog(@"encoded message:  %@", encodedMessage1A);
        NSLog(@"decoded message:  %@",
              [cc decode:encodedMessage1A offset:offset22]);
        
        NSInteger offset18 = 18;
        NSString *encodedMessage1B = [cc encode:message1 offset:offset18];
        
        NSString *message2 = @"O crap my macbook went boom, homies.";
        NSInteger offset11 = 11;
        NSString *encodedMessage2A = [cc encode:message2 offset:offset11];
        
        NSInteger offset6 = 6;
        NSString *encodedMessage2B = [cc encode:message2 offset:offset6];
        
        NSLog(@"\n");
        NSLog(@"encoded message1A:  %@", encodedMessage1A);
        NSLog(@"encoded message1B:  %@", encodedMessage1B);
        NSLog(@"encoded message2A:  %@", encodedMessage2A);
        NSLog(@"encoded message2B:  %@", encodedMessage2B);
        
        NSLog(@"\n");
        NSLog(@"Are encoded message1A and encoded message1B the same? %@",
              [cc isSameMessage:encodedMessage1A asMessage:encodedMessage1B]
              ? @"Yes." : @"No.");
        
        NSLog(@"\n");
        NSLog(@"Are encoded message1B and encoded message2B the same? %@",
              [cc isSameMessage:encodedMessage1B asMessage:encodedMessage2B]
              ? @"Yes." : @"No.");
        
        NSLog(@"\n");
        NSLog(@"Are encoded message2A and encoded message2B the same? %@",
              [cc isSameMessage:encodedMessage2A asMessage:encodedMessage2B]
              ? @"Yes." : @"No.");
        
        NSLog(@"\n");
        NSLog(@"Are encoded name and encoded message4 the same? %@",
              [cc isSameMessage:encodedNameA asMessage:encodedMessage2B]
              ? @"Yes." : @"No.");
        
        NSString *message3 = @" dfs s sd fs   sdf s df s  sdfsdfsd!";
        NSInteger offset25 = 25;
        NSString *encodedMessage3A = [cc encode:message3 offset:offset25];
        NSLog(@"\n");
        NSLog(@"encoded message1A: %@", encodedMessage1A);
        NSLog(@"encoded message3A: %@", encodedMessage3A);
        
        NSLog(@"\n");
        NSLog(@"Are encoded message1A and encoded message3A the same? %@",
              [cc isSameMessage:encodedMessage1A asMessage:encodedMessage3A]
              ? @"Yes." : @"No.");

    }
}
