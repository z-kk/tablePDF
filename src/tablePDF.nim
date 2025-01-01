import
  std / [strutils, rdstdin],
  docopt,
  tablePDFpkg / [submodule, nimbleInfo]

type
  CmdOpt = object
    csvPath, pdfPath: string

proc readCmdOpt(): CmdOpt =
  ## Read command line options.
  let doc = """
    $1

    Usage:
      $1 [-i <csvPath>] [-o <pdfPath>]

    Options:
      -h --help             Show this screen.
      --version             Show version.
      -i --input <csvPath>  Input CSV file path.
      -o --output <pdfPath> Output PDF file path.
  """ % [AppName]
  let args = doc.dedent.docopt(version = Version)

  if args["--input"]:
    result.csvPath = $args["--input"]
  if args["--output"]:
    result.pdfPath = $args["--output"]

when isMainModule:
  let cmdOpt = readCmdOpt()
  var
    csvPath = cmdOpt.csvPath
    pdfPath = cmdOpt.pdfPath
  if csvPath == "":
    csvPath = readLineFromStdin("CSV Path: ")
  if pdfPath == "":
    pdfPath = readLineFromStdin("PDF Path: ")

  fromCsv(csvPath, pdfPath)
