int exportHistos(const char *filename)
{
  TFile *file = new TFile(filename,"update");
  TH1F *hist_pT_pion = dynamic_cast<TH1F*>(file->Get("hist_pT_pion"));
  TH1F *hist_pT_kaon = dynamic_cast<TH1F*>(file->Get("hist_pT_kaon"));
  TH1F *hist_pT_proton = dynamic_cast<TH1F*>(file->Get("hist_pT_proton"));

  auto C = new TCanvas();
  hist_pT_pion->Draw();

  C->SaveAs("figures/pions.pdf");
  C->SaveAs("figures/pions.png");
  C->SaveAs("figures/pions.eps");
  C->SaveAs("figures/pions.C");

  hist_pT_kaon->Draw();
  C->SaveAs("figures/kaons.pdf");
  C->SaveAs("figures/kaons.png");
  C->SaveAs("figures/kaons.eps");
  C->SaveAs("figures/kaons.C");
  
  hist_pT_proton->Draw();
  C->SaveAs("figures/protons.pdf");
  C->SaveAs("figures/protons.png");
  C->SaveAs("figures/protons.eps");
  C->SaveAs("figures/protons.C");

  delete C;
  delete hist_pT_proton;
  delete hist_pT_pion;
  delete hist_pT_kaon;

  file->Close();
  delete file;
  return 0;
}
