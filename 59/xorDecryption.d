#!/usr/bin/env rdmd -i -I..

import std.stdio;
import std.datetime.stopwatch;
import std.file;
import std.array;
import std.algorithm;
import std.conv;
import std.range;

void main() {
  StopWatch timer;
  string plaintext;
  auto commonWordsArray = ["the", "a", "for", "to", "if", "so", "over", "who", "what", "where", "when", "why", "how"];
  auto wordsMap = commonWordsArray.zip(repeat(0)).assocArray();
  writeln(wordsMap);

  timer.start();

  auto codes = readText("p059_cipher.txt").split(',').map!(a => a.to!int()).array();
  string ciphertext = codes.map!(a => cast(immutable(char))a).array();

  auto keys = iota('a', cast(char)('z' + 1))
    .map!(a => iota('a', cast(char)('z' + 1))
        .map!(b => iota('a', cast(char)('z' + 1))
          .map!(c => cast(string)([a, b, c]))
          .array())
        .join())
    .join();

  foreach (key; keys) {
    foreach (c, k; lockstep(ciphertext, key.cycle())) {
      plaintext ~= c ^ k;
    }
    plaintext.split(' ').length.writeln();
    plaintext = [];
  }

  //writeln(keys);
  //writeln(typeof(keys).stringof);
  //writeln(codes);
  //writeln(typeof(codes).stringof);
  //writeln(ciphertext);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}

//auto keyGenInit() {
  //char[3] key = ['a', 'a', 'a'];
  //auto keyGen() {
  //}
  //return &keyGen;
//}
