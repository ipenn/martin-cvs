#coding = utf-8
import os
import xlwt
name = "207112.history"
hstpath = name + ".csv"

def main():
    with open(hstpath) as f:
        contens = f.readlines()
        if contens:
            file = xlwt.Workbook()
            table = file.add_sheet("194242")
            i = 0
            for item in contens:
                data = item.split(";")
                for key in range(0,13):
                    table.write(i,key,data[key])
                i += 1
            file.save(name+'.xls')

if __name__ =="__main__":
    main()



