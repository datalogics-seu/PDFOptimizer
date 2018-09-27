#####################################################################################################
# Powershell script to run Datalogics PDFOptimizer and process all files in a folder (not recursive)
#    v1.1  
# Argument list: 
#  -- input folder (relative paths supported)
#  -- output folder (relative paths supported)
#  -- filepath to json profile
#  -- 
#  -- Note 1: The code does not create the output folder if it does not already exist
#  -- Note 2: To execute scripts, Powersehll must be started as an admin (hint, right click on the icon) and then 
#  --    you must explicitly set the script policy with "Set-ExecutionPolicy Unrestricted"   
#  --    Options are Restricted or AllSigned or RemoteSigned or Unrestricted
#####################################################################################################

if ($args.count -ne 3) {
   echo "Incorrect number of arguments"
   echo "RunPDFOptimizer.ps1  inputFolder outputFolder profilePath"
   echo "e.g. RunPDFOptimizer.ps1  c:\test\input\  c:\test\output\  c:\datalogics\pdfoptimizer\OptimizationProfiles\standard.json"
   Exit
}
$inFolder = $args[0]
$outFolder = $args[1]
$json = $args[2]

# Standardize any trailing backslash. 
$inFolder = $inFolder.TrimEnd('\') + '\'
$outFolder = $outFolder.TrimEnd('\') + '\'
#echo "inFolder : $inFolder" 


# evaluation versions of PDFOptimizer require a license
$env:RLM_LICENSE = "c:\datalogics\pdfoptimizer\"   # define the location of the datalogics eval license as needed

$count = 0
$failcount = 0
$files = Get-ChildItem $inFolder -Name   # get the set of filenames as strings (-Name option)

ForEach ($f in $files) {
   $extn = [IO.Path]::GetExtension($f)
   # echo "extn : $extn"
   # echo "filename : $f"
   if ($extn -eq '.pdf') {
       echo "processing file : $f"
       $count++
       $exe = 'pdfoptimizer'
       $input = $inFolder + $f
       $output = $outFolder + $f
       # echo "$exe $input $output $json" 
       & $exe $input $output $json  >$null   # call PDFOptimizer.  Redirecting console output of Optimizer to null
       if ($LastExitCode -ne 0) {
           $failcount++
           #echo "last exit code :  $LastExitCode"
           }

       } else   {
       echo "skipping file : $f"
    }
   
}  # end ForEach loop

$successcount = $count-$failcount
echo ""
echo "Processed $count PDF files, $successcount successful, $failcount failed." 