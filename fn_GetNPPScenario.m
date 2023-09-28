function NPPrel=fn_GetNPPScenario(tseries,scenario, arg1, arg2, arg3)
%%%
%%%  Toy Carbon Model - 
%%%     original code from Abby Swann
%%%     modified by Inez June 2010
%%%
%%%    NPPrel(t) = non-dimensional fluctuation in NPP   
%%%    NPP(t)=NPPmean * NPPrel

switch scenario
    case 'NatVar'     % sinusoidal NPP
        ampNPP=arg1; periodNPP=arg2;
        omega=2*pi./periodNPP;		 
        NPPrel = 1 + ampNPP.*sin(omega.*tseries);

    case 'trend'      % linear trend
        rate=arg1;
        NPPrel=1+rate*tseries;
        
    case 'defor'    
        NPPrel(1:arg1)=1;
        NPPrel(arg1+1:length(tseries))=0;
        
    case 'NatPlusTrend'
        ampNPP=arg1; periodNPP=arg2;
        omega=2*pi./periodNPP;
        rate = arg3;
        NPPrel = 1 + ampNPP.*sin(omega.*tseries) + rate*tseries;
end


