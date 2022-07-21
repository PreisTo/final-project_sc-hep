int readDataFromTTree(const char *filename)
{

 TFile *file = new TFile(filename,"update"); // there are a few TTree's in this file, each corresponds to different event

 TList *lofk = file->GetListOfKeys(); // standard ROOT stuff, to read all entries in the ROOT file

 for(Int_t i=0; i<lofk->GetEntries(); i++)
 {
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
  Float_t px = 0., py = 0., pz = 0., E = 0.;
  tree->SetBranchAddress("px",&px); // that the name of this branch is px, you can inspect from tree->Print() above, and so on
  tree->SetBranchAddress("py",&py);
  tree->SetBranchAddress("pz",&pz);
  tree->SetBranchAddress("E",&E);

  for(Int_t p = 0; p < nParticles; p++) // loop over all particles in a current TTree
  {
   tree->GetEntry(p);
   cout<<Form("%d: %f %f %f %f",p,px,py,pz,E)<<endl;
  }

  cout<<"Done with this event, marching on...\n"<<endl;

 } // for(Int_t i=0; i<lofk->GetEntries(); i++)

 file->Close();

 return 0;
}
