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
  string[] words;
  int num = 0;
  int maxcount = 0;
  string bestkey = "";
  string bestplaintext = "";
  auto commonWordsArray = ["the", "then", "than", "a", "an", "and", "or", "not", "for", "to", "if", "else", "so", "over", "who", "what", "where", "when", "why", "how"];
  ulong sum = 0;

  writeln("Xor decryption");
  timer.start();

  writeln("working...");

  auto commonWords = commonWordsArray.zip(repeat(0)).assocArray();
  string ciphertext = readText("p059_cipher.txt")
    .split(',')
    .map!(a => a.to!int())
    .map!(a => cast(immutable(char))a)
    .array();

  auto keys = iota('a', cast(char)('z' + 1))
    .map!(a => iota('a', cast(char)('z' + 1))
        .map!(b => iota('a', cast(char)('z' + 1))
          .map!(c => cast(string)([a, b, c]))
          .array())
        .join())
    .join();

  foreach (key; keys) {
    foreach (c, k; lockstep(ciphertext, key.cycle()))
      plaintext ~= c ^ k;

    num = plaintext.split(' ').fold!((a, b) => a + (b in commonWords ? 1 : 0))(0);

    if (num > maxcount) {
      bestkey = key;
      maxcount = num;
      bestplaintext = plaintext;
    }

    plaintext = [];
  }

  sum = bestplaintext.sum();

  writefln("best key: %s", bestkey);
  writefln("words matched: %s", maxcount);
  writeln("best plaintext:");
  writeln(bestplaintext);
  writefln("plaintext ascii code sum: %s", sum);

  timer.stop();

  writefln("Finished in %s milliseconds.", timer.peek.total!"msecs"());
}
