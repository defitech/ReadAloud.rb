//
//  main.m
//  ReadAloud.rb
//
//  Created by dev on 30.05.13.
//  Copyright (c) 2013 Defitech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
