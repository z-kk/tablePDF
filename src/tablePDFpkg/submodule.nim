import
  std / [os, strutils, math, parsecsv],
  libharu

const
  DefaultFontsDir = "/usr/local/fonts"
  DefaultFont = "mgenplus-1c-regular.ttf"
  Xpos = 30.0
  Ypos = 820.0
  HMargin = 10.0
  VMargin = 6.0

proc hLine(page: HPDF_Page, x, y: float, length: float) =
  ## Draw horizontal line.
  discard page.HPDF_Page_MoveTo(x, y)
  discard page.HPDF_Page_LineTo(x + length, y)
  discard page.HPDF_Page_Stroke

proc vLine(page: HPDF_Page, x, y: float, length: float) =
  ## Draw vertical line.
  discard page.HPDF_Page_MoveTo(x, y)
  discard page.HPDF_Page_LineTo(x, y - length)
  discard page.HPDF_Page_Stroke

proc makeTable*(page: HPDF_Page, data: seq[seq[string]],
                fontSize = HPDF_DEF_FONTSIZE) =
  ## Make data table.
  var
    widthList: seq[float]
    x = Xpos
    y = Ypos
  let
    rowHeight = fontSize.toFloat + VMargin
  for row in data:
    for idx, val in row:
      let width = page.HPDF_Page_TextWidth(val.cstring)
      if widthList.len <= idx:
        widthList.add width
      else:
        widthList[idx] = max(widthList[idx], width)

  for row in data:
    x = Xpos
    y -= rowHeight
    for idx, val in row:
      page.textOut(x, y, val)
      x += widthList[idx] + HMargin

  x = Xpos - HMargin / 2
  y = Ypos - VMargin / 2
  page.hLine(x, y, widthList.sum + HMargin * widthList.len.toFloat)
  y -= rowHeight
  page.hLine(x, y, widthList.sum + HMargin * widthList.len.toFloat)
  for i in 1 ..< data.len - 1:
    discard page.HPDF_Page_SetLineWidth(0.3)
    y -= rowHeight
    page.hLine(x, y, widthList.sum + HMargin * widthList.len.toFloat)
  discard page.HPDF_Page_SetLineWidth(1)
  y -= rowHeight
  page.hLine(x, y, widthList.sum + HMargin * widthList.len.toFloat)

  x = Xpos - HMargin / 2
  y = Ypos - VMargin / 2
  page.vLine(x, y, rowHeight * data.len.toFloat)
  for width in widthList:
    discard page.HPDF_Page_SetLineWidth(0.3)
    x += width + HMargin
    page.vLine(x, y, rowHeight * data.len.toFloat)
  discard page.HPDF_Page_SetLineWidth(1)
  page.vLine(x, y, rowHeight * data.len.toFloat)

proc makeTablePdf*(data: seq[seq[string]], path: string, fontsDir = DefaultFontsDir) =
  ## Make data table PDF.
  let
    pdf = newPdfDoc()
    fontName = pdf.getFontName(fontsDir / DefaultFont)
    font = pdf.getFont(fontName, ecUtf8)
  defer:
    pdf.saveToFile(path)
    pdf.free

  var
    page = pdf.addPage
  page.setFont(font)

  page.makeTable(data)

proc fromCsv*(csvPath, pdfPath: string, fontsDir = DefaultFontsDir) =
  ## Make PDF from CSV file.
  if not csvPath.fileExists:
    quit "No such file[$1]." % [csvPath]

  var csv: CsvParser
  csv.open(csvPath)
  defer: csv.close

  var data: seq[seq[string]]
  while csv.readRow:
    var row: seq[string]
    for val in csv.row.items:
      row.add val
    data.add row

  data.makeTablePdf(pdfPath, fontsDir)
