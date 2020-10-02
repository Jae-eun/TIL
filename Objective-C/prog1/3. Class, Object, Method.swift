//
//  3. Class, Object, Method.swift
//  prog1
//
//  Created by 이재은 on 2020/09/17.
//  Copyright © 2020 jaeeun. All rights reserved.
//

// 3. Class, Object, Method
#import <Foundation/Foundation.h>

// @interface 부분: 클래스와 메서드를 선언
@interface Fraction : NSObject

-(void) print;
-(void) setNumerator: (int) n;
-(void) setDenominator: (int) d;
-(int) numerator;
-(int) denominator;

@end

// @implementation 부분: 데이터 요소(클래스에 담을 인스턴스 변수)와 메서드들을 구현
@implementation Fraction
{
    int numerator;
    int denominator;
}

-(void) print
{
    NSLog(@"%i/%i", numerator, denominator);
}

-(void) setNumerator: (int) n
{
    numerator = n;
}

-(void) setDenominator: (int) d
{
    denominator = d;
}

-(int) numerator
{
    return numerator;
}

-(int) denominator
{
    return denominator;
}

@end

// Program 부분
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 3.1
        //        int numerator = 1;
        //        int denominator = 3;
        //
        //        NSLog(@"The fraction is %i/%i", numerator, denominator);
        
        // 3.2
//        Fraction *myFraction;
//
//        // Fraction 인스턴스를 생성
//        myFraction = [Fraction alloc];
//        myFraction = [myFraction init];
//
//        // 1/3로 분수의 값을 설정
//        [myFraction setNumerator: 1];
//        [myFraction setDenominator: 3];
//
//        // print 메서드로 분수의 값을 표시
//        NSLog(@"The value of myFraction is:");
//        [myFraction print];
        
        // 3.3
//        Fraction *frac1 = [[Fraction alloc] init];
//        Fraction *frac2 = [[Fraction alloc] init];
//
//        [frac1 setNumerator: 2];
//        [frac1 setDenominator: 3];
//
//        [frac2 setNumerator: 3];
//        [frac2 setDenominator: 7];
//
//        NSLog(@"First fraction is:");
//        [frac1 print];
//
//        NSLog(@"Second fraction is:");
//        [frac2 print];
        
        // 3.4
        Fraction *myFraction = [Fraction new]; // [[Fraction alloc] init]; 와 같음
        
        [myFraction setNumerator: 1];
        [myFraction setDenominator: 3];
        
        NSLog(@"The value of myFraction is: %i/%i", [myFraction numerator], [myFraction denominator]);
    }
    return 0;
