# Package

version       = "0.1.0"
author        = "lune"
description   = "A new awesome nimble package"
license       = "MIT"
installDirs   = @["nimbledeps"]
srcDir        = "src"
binDir        = "bin"
bin           = @["nim_test"]

# Dependencies

requires "nim >= 2.0.2"

requires "plotly", "results"
