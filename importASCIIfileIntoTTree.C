#include "TFile.h"
#include "TTree.h"
#include <stdarg.h>

int importASCIIfileIntoTTree(const char *filename, ...)
{
 TFile *file = new TFile("HIJING_LBF_test_small.root","update"); // open ROOT file
 TTree *tree = new TTree("event","data from ascii file"); // make the new TTree for each event
 Long64_t nlines = tree->ReadFile(filename,":PID:::px:py:pz:E"); // whatever you specify here, will be relevant when you start later reading the TTree branches
 tree->Write(); // save TTree to file
 file->Close();

 return 0;
}
