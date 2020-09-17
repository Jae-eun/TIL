//
//  2. Programming in Objective-C.swift
//  prog1
//
//  Created by 이재은 on 2020/09/15.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import Foundation

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 1.
        NSLog(@"Programming is fun!");
        NSLog(@"Programming in Objective-C is even more fun!");
        NSLog(@"Testing...\n..1\n...2\n....3");
        
        int value1, value2, sum;
        
        value1 = 50;
        value2 = 25;
        
        sum = value1 + value2;
        
        NSLog(@"The sum of %i and %i is %i", value1, value2, sum);
        
        // 2.
        NSLog(@"In Objective-C, lowercase letters are significant.\nmain is where program execution begins.\nOpen and closed braces enclose program statements in a routine.\nAll program statements must be terminated by a semicolon.");
        
        // 3.
        int i;
        i = 1;
        NSLog(@"Testing...");
        NSLog(@"....%i", i);
        NSLog(@"...%i", i + 1);
        NSLog(@"..%i", i + 2);
        
        // 4.
        int value3, value4;
        value3 = 87;
        value4 = 15;
        
        NSLog(@"%i - %i = %i", value3, value4, value3 - value4);
        
        // 5.
        int sum2;
        /* COMPUTE RESULT */
        sum2 = 25 + 37 - 19;
        // DISPLAY RESULTS
        NSLog(@"The answer is %i", sum2);
        
        // 6.
        int answer, result;
        
        answer = 100;
        result = answer - 10;
        
        NSLog(@"The result is %i \n", result + 5);
    }
    return 0;
}
 
