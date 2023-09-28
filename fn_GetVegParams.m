function [A]=fn_GetVegParams(VegName)
%%
%%%% Original code from Abby Swann
%%%% Calculated NPP (mean and variance) for different PFT's from CLM run
%%
%%%% Modified by Inez June 2010

%-- Guide for choosing NPP values for different vegetation types.
%--The results from NCAR climate model run (with a terrestrial carbon model CASA'.
%-- The values may be too high or low 
%		MeanNPP		varNPP	pftnames		range as a percent of the mean
%	1	105.2246    3.0186	bare               0.0660
%	2	 77.2326    4.8664  NET temperate      0.1143  needlelv evergr trees
%	3	 47.2717    1.8915	NET boreal         0.1164   
%	4	 18.9141    1.3628	NDT boreal         0.2469  needlelv decid trees
%	5	581.2650   98.4212	BET tropical       0.0683  broadlv evg trees
%	6	344.8148  186.4947	BET temperate      0.1584  
%	7	278.9480   23.8247	BDT tropical       0.0700  broadlv decid trees
%	8	156.1733   16.7101	BDT temperate      0.1047   
%	9	 36.4630    0.9938	BDT boreal         0.1094
%	10	 30.6910   19.8948	BES tempearate     0.5813  broadlv evg shrubs
%	11	209.7151   17.9541	BDS temperate      0.0808  broadlv decid shrubs 
%	12	 77.9806    7.3464	BDS boreal         0.1390    
%	13	 83.9177   10.3180	C3 arctic          0.1531     
%	14	171.2258    9.0293	C3 grass           0.0702     
%	15	208.0447   11.9817	C4 grass           0.0666    
%	16	173.4215    7.5605	crop     		   0.0634
   
% NPP is in unit of gramC/m2/year
% Tau's are turnover times of the carbon pools (in years).
% alloc is the partitioning of NPP to leaf, root and wood pools.

switch VegName
    case 'TRF'
        NPP=800; TauLeaf=2; TauRoot=TauLeaf; TauWood=30; 
        TauLitter=5; TauCWD=10; TauSoil=15;
        alloc=[1/3 1/3 1/3];
    case 'TempForest'
        NPP=200; TauLeaf=2; TauRoot=TauLeaf; TauWood=20; 
        TauLitter=5; TauCWD=25; TauSoil=20;
        alloc=[1/3 1/3 1/3];
    case 'BorealForest'
        NPP=100; TauLeaf=2; TauRoot=TauLeaf; TauWood=30; 
        TauLitter=5; TauCWD=30; TauSoil=25;
        alloc=[1/3 1/3 1/3];
    case 'Grass'
        NPP=50; TauLeaf=2; TauRoot=TauLeaf; TauWood=1; 
        TauLitter=5; TauCWD=1; TauSoil=10;
        alloc=[0.5 0.5 0];
end    
A.VEGNAME=VegName;
A.NPPMEAN=NPP;
A.TAUS=[TauLeaf TauRoot TauWood TauLitter TauCWD  TauSoil]
A.ALPHA=alloc;

return



