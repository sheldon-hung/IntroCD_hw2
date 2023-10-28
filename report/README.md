# hw2 report

|||
|-:|:-|
|Name|洪慎廷|
|ID|110550162|

## How much time did you spend on this project

> e.g. 2 hours.

About 5 hours.

## Project overview

> Please describe the structure of your code and the ideas behind your implementation in an organized way. \
> The point is to show us how you deal with the problems. It is not necessary to write a lot of words or paste all of your code here. 

My codes are written in "scanner.l" and "parser.y". For the sanner, I modified the given lex source file, not using my code written in hw1. For the parser, the codes can break into three parts, declarations, grammer rules and user subroutines. However, I didn't modify any codes in the last part. Thus, the following paragraghs are my  description of the scanner, declarations and the grammer rules.

In the "scanner.l", I just added return token to the regular expressions, some of the tokens are returned as its literal character and others are returned as its declared token which are declared in the declaration part in the parser. For the delimiters, I returned the literal charcters, because they all are single character and have no precednce. For the operators, I returned its declared token, becuase some of the operators have more than one characters and all of them have precedence. For reserved words, I also returned its declared tokens, because they are strings. For the constant integers and octal integers, I viewed them as the same token, so as the constant floating-point and the scientific notation, because the former are both the scalar type according to the p-language, the latter are both the real type also according to the p-language. For constant string, just return its declared token.

In the declaration part of the "parser.y", I declared all the tokens that would be returned by the scanner, including the reserved words, constants and operators. And for the operators because they have precedence and different association. They are declared in either "%left", "%right" or "%nonassoc" and organized according to its precedence, from low to high.

In the grammer rules part of the "parser.y", I wrote all the context-free grammer rules of the p-language. The rules are organized according to the syntax definition in README.md file. During the construction, I started from constructing the simple rules, then use the constructed rules to construct more complex rules. At last, use the testcases to debug and fix my grammer rules.

## What is the hardest you think in this project

> Not required, but bonus point may be given.

Constructing the arithmetic expressions is the hardest part I think in this project. Because it has many rules and precedence to follow. It took me quite a time to think, write and debug this part.

## Feedback to T.A.s

> Not required, but bonus point may be given.

