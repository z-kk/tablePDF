# Package

version       = "0.1.0"
author        = "z-kk"
description   = "Make table in PDF format using libharu."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["tablePDF"]
binDir        = "bin"


# Dependencies

requires "nim >= 2.0.0"
requires "docopt"
requires "libharu"


# Tasks

import std / [os, strutils]
task r, "build and run":
  exec "nimble build"
  exec "nimble ex"

task ex, "run without build":
  withDir binDir:
    exec "." / bin[0]


# Before / After

before build:
  let infoFile = srcDir / bin[0] & "pkg" / "nimbleInfo.nim"
  infoFile.parentDir.mkDir
  infoFile.writeFile("""
    const
      AppName* = "$#"
      Version* = "$#"
  """.dedent % [bin[0], version])

after build:
  let infoFile = srcDir / bin[0] & "pkg" / "nimbleInfo.nim"
  infoFile.writeFile("""
    const
      AppName* = ""
      Version* = ""
  """.dedent)
