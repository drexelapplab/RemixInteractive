import xlrd
import csv


colorIndexes=[]
rs=[]
gs=[]
bs=[]
numberOfWorkbooks = 5;


with open('excelColorPallate','r') as f:
	next(f) # skip headings
	reader=csv.reader(f,delimiter='\t')
	for colorIndex,r,g,b in reader:
		
		colorIndexes.append(int(colorIndex))
		
		rf = float(r)
		gf = float(g)
		bf = float(b)

		if(rf==255):
			rf = 256.0
		if(gf==255):
			gf = 256.0
		if(bf==255):
			bf = 256.0

		rs.append(rf)
		gs.append(gf)
		bs.append(bf)


		print 'INDEX: ' + str(colorIndexes[-1]) + '\tR:' + str(rs[-1]) + '\tG:' + str(gs[-1]) + '\tB:' + str(bs[-1])

allCuesStr = ''

for totalBooks in range(1,numberOfWorkbooks+1):
	book = xlrd.open_workbook('RemixLightShow' + str(totalBooks) + '.xls',formatting_info=True)
	print "The number of worksheets is", book.nsheets
	print "Worksheet name(s):", book.sheet_names()
	for n in range(0,book.nsheets):
		sh = book.sheet_by_index(n)
		print sh.name, sh.nrows, sh.ncols
		colorsList = ''
		cueName = sh.name
		cueTime =xlrd.xldate_as_tuple(sh.cell(4,0).value, book.datemode)
		yr, mo, dy, h, m, s = cueTime;
		# print yr, mo, dy, h, m, s
		mins = h
		secs = m
		msecs = int(float(s)/24.0*1000.0)
		cueTimeStr = str(mins) + ':' + str(secs) + ':' +  str(msecs)
		colorsList = colorsList + cueName + '|' + cueTimeStr + '|'
		for i in range(0,4):
			for j in range(0,4):
				 # print i, j
				if(i>=sh.nrows or j>=sh.ncols):
					cIndex = 0 #black
				else:
					cell = sh.cell(i,j)
					bookXFList= book.xf_list
					cellIndex = cell.xf_index
					cellFormat = bookXFList[cellIndex]
					cellBackground = cellFormat.background
					cellBackgroundIndex = cellBackground.pattern_colour_index - 7
					cIndex = cellBackgroundIndex-1
					#print 'BackgroundColorIndex: ' + str(cellBackgroundIndex)
				backgroundColorString = '{'+ str(rs[cIndex]/256.0) +','+ str(gs[cIndex]/256.0) +','+ str(bs[cIndex]/256.0) +',1.0}'
				colorsList = colorsList + backgroundColorString
		# print colorsList
		allCuesStr = allCuesStr + colorsList + '\n'

file = open("RemixAllBooks.riQ", "w")
file.write(allCuesStr)
file.close()



# for rx in range(sh.nrows):
# 	print sh.row(rx)