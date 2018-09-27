#####################################################################################################
# Python script to run Datalogics PDFOptimizer and process all files in a folder (not recursive).
#    v1.1  
# Argument list: 
#  -- input folder (relative paths supported)
#  -- output folder (relative paths supported)
#  -- filepath to json profile
#  -- 
#  -- Note 1: The code does not create the output folder if it does not already exist
#####################################################################################################

import os
import sys
import subprocess

#inFolder = '.'
#outFolder = '..\output'
#json = 'C:\Datalogics\PDFOptimizer\OptimizationProfiles\standard.json'
exePath = 'pdfoptimizer'  # or point to the location of the .exe (e.g. 'C:\Datalogics\PDFOptimizer\pdfoptimizer.exe')
count = 0
successCount = 0

if len(sys.argv) != 4: 
   print ("\nIncorrect number of arguments")
   print ("  python RunPDFOptimizer.py inputFolder outputFolder profilePath")
   print ("  e.g. python RunPDFOptimizer.py  c:\\test\\input\\  c:\\test\\output\\  c:\\datalogics\\pdfoptimizer\\OptimizationProfiles\\standard.json")
   exit()

inFolder = sys.argv[1]
outFolder = sys.argv[2]
json = sys.argv[3]
#print ("inFolder =", inFolder)
#print ("outFolder =", outFolder)
#print ("json =", json)

for file in os.listdir(inFolder):
    inFile = os.path.join(inFolder, file)
    outFile = os.path.join(outFolder, file)
    if os.path.isfile(inFile):
        if os.path.splitext(inFile)[1] == '.pdf':
            count += 1
            print ("Processing %s" % inFile) 
            retcode = subprocess.call([exePath, inFile, outFile, json])
            if retcode != 0:
                print ("   Error processing %s. Return code=%s" % (file, retcode))
            else:  
                successCount += 1          
        else:
            print ("Skipping %s" % inFile)
 
print ("\nProcessed %s PDF files, %s completed, %s failed" % (count, successCount, count-successCount) )
# Finished
