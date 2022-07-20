#include "TFile.h"
#include "TTree.h"

int importASCIIfileIntoTTree(const char *filename)
{
 TFile *file = new TFile("output.root","update"); // open ROOT file named 'output.root', where TTree will be saved
 TTree *tree = new TTree("event","data from ascii file"); // make the new TTree for each event

 Long64_t nlines = tree->ReadFile(filename,"px:py:pz:E"); // whatever you specify here, will be relevant when you start later reading the TTree branches
 tree->Write(); // save TTree to 'output.root' file
 file->Close();

 return 0;
}
