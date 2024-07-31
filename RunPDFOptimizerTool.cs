using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

/*
 * Runs PDFOptimizer tool to process a folder at a time. Requires two parameters:
 * -- inputFolder  (absolute path)
 * -- outputFolder (absolute path)
 * Examples:
 *    PDFPDFOptimmizerTool.exe c:\temp\input  c:\temp\output
 *    
 * Important: You will need to specify the location of the PDFOptimizer tool and the JSON profile
 * in the strings below and recompile:
 *  -- optimizerLocation, optimizerProfile
 * 
 * Disclaimer: Samples are designed for demonstration purposes and are not intended for production usage.
 * Copyright (c) 2024, Datalogics, Inc. All rights reserved.
 */
namespace RunPDFOptimizerTool
{

    class Program
    {
        // Set the location of the PDF Optimizer folder here
        static String optimizerLocation = "C:\\Datalogics\\PDFOptimizer\\PDFOptimizer-v341";
        static String optimizerExecutable = optimizerLocation + "\\pdfoptimizer.exe";
        static String optimizerProfile = optimizerLocation + "\\OptimizationProfiles\\compressionMedium.json";

        static void ProcessOneFile(String sInput, String sOutput, ref int successCount, ref int failCount)
        {
            Console.WriteLine("  -- Optimizing {0} to {1}", sInput, sOutput);
            String optimizerArguments = " -i " + sInput + " -o " + sOutput + " -j " + optimizerProfile;

            using (Process myProcess = new Process())
            {
                myProcess.StartInfo.WorkingDirectory = optimizerLocation;
                myProcess.StartInfo.Arguments = optimizerArguments;
                myProcess.StartInfo.FileName = optimizerExecutable;
                //myProcess.StartInfo.CreateNoWindow = true;
                myProcess.StartInfo.UseShellExecute = false;
                myProcess.StartInfo.RedirectStandardOutput = true;
                myProcess.Start();
                myProcess.WaitForExit();  //lets wait here
                // Console.WriteLine(myProcess.StandardOutput.ReadToEnd()); //if you want to see the PDFOptimizer console, uncomment this

                if (myProcess.ExitCode == 0)
                {
                    successCount++;
                }
                else
                {
                    Console.WriteLine("    Failed to optimize PDF ", sInput);
                    failCount++;
                    return;
                }  
            }
        }


        static void Main(string[] args)
        {
            String sInputFolder = "";    
            String sOutputFolder = "";
            int successCount = 0, failCount = 0;

            if (args.Length > 0)
                sInputFolder = args[0];
            if (args.Length > 1)
                sOutputFolder = args[1];

            if (args.Length < 2)
            {
                Console.WriteLine ("Incorrect number of arguments");
                Console.WriteLine("Usage:  RunPDFOptimizerTool.exe  c:\\temp\\inputFolder  c:\\temp\\outputFolder");
                System.Environment.Exit(1);
            }

            // Do a small amount of error checking...
            // Console.WriteLine("In: " + sInputFolder + "   Out: " + sOutputFolder);
            if ( !File.Exists(sInputFolder) && !Directory.Exists(sInputFolder) )
            {
                 Console.WriteLine("{0} is not a valid directory.", sInputFolder);
                 System.Environment.Exit(1);
            }

            if (!Directory.Exists(sOutputFolder))
            {
                 Console.WriteLine("{0} is not a valid directory.", sOutputFolder);
                 System.Environment.Exit(1);
            }

            // Start processing files...
            // We are only looking for files with the .pdf extension.  
            FileAttributes attr = File.GetAttributes(sInputFolder);
            if ((attr & FileAttributes.Directory) == FileAttributes.Directory)
            {
                string[] fileEntries = Directory.GetFiles(sInputFolder, "*.pdf");
                Console.WriteLine("Processing {0}  files in {1} and storing in {2}", fileEntries.Count(), sInputFolder, sOutputFolder);

                String sOutputFile = "";
                foreach (string fileName in fileEntries)
                {
                    sOutputFile = sOutputFolder + "\\" + Path.GetFileName(fileName); ;
                    ProcessOneFile(fileName, sOutputFile, ref successCount, ref failCount);
                }
            }

            Console.WriteLine("\nFinished! {0}  files converted, {1} failed.", successCount, failCount);

         }
    }
}
