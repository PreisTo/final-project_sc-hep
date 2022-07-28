# final_project
Final Project for Scientific Computing in High Energy Physics

- Cleaner.sh: removes all produced data for rerunning - just for personal usage
- Splitter.sh: splits output of MC as defined in challenge 1)
- Filter.sh: filters out the primary particles as defined in challenge 2)
- Transfer.sh: transfers the .dat files into a TTree for each run as defined in challenge 3)
    - importASCIIfileIntoTTree.C: root file that does the actual transferring
- Analysis.sh: analyze the output of the MC, save the histograms in one single AnalysisResults.root with the transversal impulses of pions, kaons and protons as defined in challenge 4)
  - createHistos.C: create the histograms
  - readDataFromTTree.C: read all the events and particles and fill up the histograms
  - exportHistos.C: export the figures from the histos and print out the required average pT infos
- TheFinalTouch.sh: runs Splitter, Filter, Transfer and Analysis as defined in challenge 5)
