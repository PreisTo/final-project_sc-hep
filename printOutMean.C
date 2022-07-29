int printOutMean(const char *filename)
{
  TFile *file = new TFile(filename,"update");
  TH1F *hist_pT_pion = dynamic_cast<TH1F*>(file->Get("hist_pT_pion"));
  TH1F *hist_pT_kaon = dynamic_cast<TH1F*>(file->Get("hist_pT_kaon"));
  TH1F *hist_pT_proton = dynamic_cast<TH1F*>(file->Get("hist_pT_proton"));

  cout<<Form("Average pT for the whole dataset:")<<endl;
  cout<<Form("o pions\t\t=\t%f",hist_pT_pion->GetMean())<<endl;
  cout<<Form("o kaons\t\t=\t%f",hist_pT_kaon->GetMean())<<endl;
  cout<<Form("o protons\t=\t%f",hist_pT_proton->GetMean())<<endl;
  return 0;
}
