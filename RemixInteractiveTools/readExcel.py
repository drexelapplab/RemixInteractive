import xlrd
book = xlrd.open_workbook("RemixLightShow.xls",formatting_info=True)
print "The number of worksheets is", book.nsheets
print "Worksheet name(s):", book.sheet_names()
sh = book.sheet_by_index(5)
print sh.name, sh.nrows, sh.ncols
for i in range(0,4):
	for j in range(0,4):
		cell = sh.cell(i,j)
		bookXFList= book.xf_list
		cellIndex = cell.xf_index
		cellFormat = bookXFList[cellIndex]
		cellBackground = cellFormat.background
		cellBackgroundIndex = cellBackground.background_colour_index
		print 'BackgroundColorIndex: ' + str(cellBackgroundIndex)

for rx in range(sh.nrows):
	print sh.row(rx)