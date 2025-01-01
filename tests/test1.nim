import unittest

import std / [os]
import tablePDFpkg/submodule
setCurrentDir("sampledata")
test "sample data":
  let data = @[
    @["CustomerID", "Name", "Email", "Age", "Country"],
    @["1", "John Doe", "john.doe@example.com", "28", "USA"],
    @["2", "Jane Smith", "jane.smith@example.com", "34", "Canada"],
    @["3", "Emily Johnson", "emily.j@example.com", "22", "UK"],
    @["4", "Michael Brown", "michael.b@example.com", "45", "Australia"],
    @["5", "Linda Davis", "linda.d@example.com", "31", "India"],
  ]
  data.makeTablePdf("sample1.pdf")

test "sample csv":
  fromCsv("sample.csv", "sample2.pdf")
