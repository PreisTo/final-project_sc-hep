#include <stdio.h>
int readDataFromTTree(const char *filename)
{
 ROOT::EnableImplicitMT();
 TFile *file = new TFile(filename,"update"); // there are a few TTree's in this file, each corresponds to different event

 TList *lofk = file->GetListOfKeys(); // standard ROOT stuff, to read all entries in the ROOT file
 Int_t nr_entries=int(lofk->GetEntries());
 cout<<Form("Total number of keys %d",nr_entries)<<endl;
 for(Int_t i=0; i<lofk->GetEntries(); i++)
 //for(Int_t i=0; i<2; i++)
 {
  cout<<Form("Analysing event number %d",i)<<endl;
  TTree *tree = (TTree*) file->Get(Form("%s;%d",lofk->At(i)->GetName(),i+1)); // works if TTrees in ROOT file are named 'event;1', 'event;2'. Otherwise, adapt for your case

  if(!tree || strcmp(tree->ClassName(),"TTree")) // make sure the pointer is valid, and it points to TTree
  {
   cout<<Form("%s is not TTree!",lofk->At(i)->GetName())<<endl;
   continue;
  }

  //tree->Print();  //from this printout, you can for instance inspect the names of the TTree's branches

  cout<<Form("Accessing TTree named: %s",tree->GetName())<<": "<<tree<<endl;
  Int_t nParticles = (Int_t)tree->GetEntries(); // number of particles
  cout<<Form("=> It has %d particles.",nParticles)<<endl;

  // Attach local variables to branches:
  Float_t px = 0., py = 0., pz = 0., E = 0., PID = 0.;
  tree->SetBranchAddress("px",&px); // that the name of this branch is px, you can inspect from tree->Print() above, and so on
  tree->SetBranchAddress("py",&py);
  tree->SetBranchAddress("pz",&pz);
  tree->SetBranchAddress("E",&E);
  tree->SetBranchAddress("PID",&PID);

  TFile *fileOutput = TFile::Open("AnalysisResults.root","update"); // open up output file to store histograms
 // if(!fileOutput){TFile *fileOutput = TFile::Open("AnalysisResults.root","NEW");}  // check if output file exists, otherwise create --- somehow needed, TODO figure out why
  
  TH1F *hist_pT_pion = dynamic_cast<TH1F*>(fileOutput->Get("hist_pT_pion"));
  TH1F *hist_pT_kaon = dynamic_cast<TH1F*>(fileOutput->Get("hist_pT_kaon"));
  TH1F *hist_pT_proton = dynamic_cast<TH1F*>(fileOutput->Get("hist_pT_proton"));

  for(Int_t p = 0; p < nParticles; p++) // loop over all particles in a current TTree
  {
   tree->GetEntry(p);
//   printf("\rIn progress %d \n", (p/nParticles)*100);
//   fflush(stdout); 
   PID=abs(PID);    // antiparticle, particle ... all the same
   if (PID == 211 || PID == 111)
   {
   // Pions
   double pT = TMath::Sqrt(TMath::Power(px,2)+TMath::Power(py,2));  // compute pT
   hist_pT_pion->Fill(pT);
   }
   else if (PID == 130 || PID == 310 || PID==311 || PID==321)
   {
    // Kaon
    double pT = TMath::Sqrt(TMath::Power(px,2)+TMath::Power(py,2));  // compute pT
    hist_pT_kaon->Fill(pT);
   }
   else if (PID == 2212)
   {
    // Proton
    double pT = TMath::Sqrt(TMath::Power(px,2)+TMath::Power(py,2));  // compute pT
    hist_pT_proton->Fill(pT);
   }

  }
  hist_pT_pion->Write(hist_pT_pion->GetName(),TObject::kSingleKey+TObject::kWriteDelete);
  hist_pT_kaon->Write(hist_pT_kaon->GetName(),TObject::kSingleKey+TObject::kWriteDelete);
  hist_pT_proton->Write(hist_pT_proton->GetName(),TObject::kSingleKey+TObject::kWriteDelete);
  fileOutput->Close();
  cout<<"Done with this event, marching on...\n"<<endl;

 } // for(Int_t i=0; i<lofk->GetEntries(); i++)
  file->Close();


 return 0;
}
