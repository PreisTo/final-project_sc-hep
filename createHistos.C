int createHistos(const char *filename)
{  
  TFile *file = new TFile(filename,"update");
  TH1 *hist_pT_pion = new TH1F("hist_pT_pion", "hist_pT_pion", 100, 0., 10);
  TH1 *hist_pT_kaon = new TH1F("hist_pT_kaon", "hist_pT_kaon", 100, 0., 10);
  TH1 *hist_pT_proton = new TH1F("hist_pT_proton", "hist_pT_proton", 100, 0., 10);
  hist_pT_pion->Write();
  hist_pT_kaon->Write();
  hist_pT_proton->Write();
  delete hist_pT_kaon;
  delete hist_pT_pion;
  delete hist_pT_proton;
  file->Close();
  delete file;
  return 0;
}
