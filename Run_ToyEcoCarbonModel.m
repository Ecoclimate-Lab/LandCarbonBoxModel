%% TCM0.m
%
% Toy Carbon Model 
%  original code by Abby Swann
%  reference is Abby's PhD thesis
%  modified by Inez, June 2010
%
% To Run this Model, need also
%     Run_ToyCarbonModel.m
%     fn_GetVegParams.m
%     fn_GetNPPScenario.m
%%-------------------------------Model Set up------------------------------------
%%% Four pools are defined as
%%% 1. live plant 
%%% 			leaf  (L)
%%% 			woody (W)
%%% 			roots (R)
%%% 2. Litter
%%% 3. Coarse Woody Debris (CWD)
%%% 4. Soil
% 
%
%%% The equations for the dead pools are such that 
%%%   the fraction gamma is transferred from one dead pool to another
%%%   (1-gamma) is respired CO2 to the atmosphere
%
% (1) L,R,W:    dM/dt  = alloc*NPP - M/tau
% (2) Litter:   dM2/dt = (ML+MR)/tau2 - gamma24*M2/tau2 - (1-gamma24)M2/tau2
% (3) CWD:      dM3/dt = MW/tauW - gamma34*M3/tau3 - (1-gamma34)*M3/tau3
% (4) Soil:     dM4/dt = gamma24*M2/tau2 + gamma34*M3/tau3 - M4/tau4
%
%
%%--------------------------   Model Parameters  ------------------------
%%% Parameters are defined in fn_GetVegParams.m
%
%%% Turnover times for each pool will be in the range
%%% tauL=tauR=	1-2 years
%%% tauW =		5 years tropics
%%% 				100 years high latitudes
%%% tau2 =		2-5 years        % litter
%%% tau3 =		10-1000 years    % Coarse woody Debris
%%% tau4 =		100-1000 years   % Soil
%
%%% allocL, allocR, allocW - fraction of NPP allocated to leaf, root and wood pools
%%% gamma24, gamma34 - fraction of decomposed carbon passed to next dead pool
% 
% 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODEL PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----turnover times (tau)
tauL=taus(1);
tauR=taus(2);
tauW=taus(3);
tau2=taus(4); 
tau3=taus(5);
tau4=taus(6);

allocL=alloc(1);      % leaf
allocR=alloc(2);      % root
allocW=alloc(3);      % wood

%    gamma is Fraction of decomposed stuff passed to next dead pool;
%    (1-gamma) is microbial respiration = co2 flux to atmosphere
gamma24=.3;   % from deadpool 2 to deadpool4
gamma34=.3;

%%%%%%%%%%%%%%%%%%%%%   INITIAL CONDITIONS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Equations 1-4, d/dt=-0
%
ML(1)=allocL*tauL*NPPmean;
MR(1)=allocR*tauR*NPPmean;
MW(1)=allocW*tauW*NPPmean;

M2(1)=(ML(1)+MR(1))*tau2/tauL;
M3(1)=MW(1)*tau3/tauW;
M4(1)=tau4*(gamma24*M2(1)/tau2+gamma34*M3(1)/tau3);


%sprintf(strcat('Initial Eqm:  MLive= ', num2str(Mlive), ';  Mdead = ', num2str(Mdead)))
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  INTEGRATE FORWARD IN TIME %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=2:length(tseries)
    ML(i)=ML(i-1) + dt*(allocL*NPP(i) - ML(i-1)/tauL);
    MR(i)=MR(i-1) + dt*(allocR*NPP(i) - MR(i-1)/tauR);
    MW(i)=MW(i-1) + dt*(allocW*NPP(i) - MW(i-1)/tauW);
    M2(i)=M2(i-1) + dt*(ML(i-1)/tauL + MR(i-1)/tauR - M2(i-1)/tau2); 
    M3(i)=M3(i-1) + dt*(MW(i-1)/tauW - M3(i-1)/tau3);
    M4(i)=M4(i-1) + dt*(gamma24*M2(i-1)/tau2 + gamma34*M3(i-1)/tau3 - M4(i-1)/tau4);
end 

%% summary inventories and respiration
    Mlive=ML + MR + MW;
    Mdead=M2 + M3 + M4;
    RespHet=(1-gamma24)*M2/tau2 + (1-gamma34)*M3/tau3 + M4/tau4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%   END OF INTEGRATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%


return

%% 
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%%---interpolate time series down to annual (or other arbitrary time step) values
%
NPP_t=interp1(tseriesI,NPP,tseries);
ML_t=interp1(tseriesI,ML,tseries);
MR_t=interp1(tseriesI,MR,tseries);
MW_t=interp1(tseriesI,MW,tseries);
M2_t=interp1(tseriesI,M2,tseries);
M3_t=interp1(tseriesI,M3,tseries);
M4_t=interp1(tseriesI,M4,tseries);
HR2_t=interp1(tseriesI,HetResp2,tseries);
HR3_t=interp1(tseriesI,HetResp3,tseries);
HR4_t=interp1(tseriesI,HetResp4,tseries);
%
%--------------------------------------------------------------------------


%----------------------------------------------------------------------------------

ts_peryear=1/dt;		%time steps per year

NPP_anmean=mean(reshape(NPP(2:end),ts_peryear,tmax));
ML_anmean =mean(reshape(ML(2:end),ts_peryear,tmax));
MR_anmean =mean(reshape(MR(2:end),ts_peryear,tmax));
MW_anmean =mean(reshape(MW(2:end),ts_peryear,tmax));
M2_anmean =mean(reshape(M2(2:end),ts_peryear,tmax));
M3_anmean =mean(reshape(M3(2:end),ts_peryear,tmax));
M4_anmean =mean(reshape(M4(2:end),ts_peryear,tmax));

%----------------------------------------------------------------------------------
