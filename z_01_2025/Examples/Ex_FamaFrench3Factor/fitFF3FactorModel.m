function [MdlFF3,MdlCAPM] = fitFF3FactorModel(LIBOR,returnsMarket,returnsSMB,returnsHML,returnsSecurity)

T       = table();
T.Rf    = LIBOR.Rates(2:end);
T.Rm    = returnsMarket;
T.Rsmb  = returnsSMB;
T.Rhml  = returnsHML;
T.Ri    = returnsSecurity;
T.RiMinusRf = T.Ri - T.Rf;
T.RmMinusRf = T.Rm - T.Rf;

MdlFF3  = fitlm(T,'RiMinusRf ~ RmMinusRf + Rsmb + Rhml');
MdlCAPM = fitlm(T,'RiMinusRf ~ RmMinusRf');