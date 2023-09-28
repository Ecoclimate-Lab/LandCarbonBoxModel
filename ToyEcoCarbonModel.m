% Run_ToyCarbonModel
%%
%%%%%%%%%%%
%%%% Original code from Abby Swann - 
%%%% Reference is Abby's PhD thesis
%%%%
%%%% Modified by Inez June 2010
%%%%
%%%% The model consists of
%%%%     Run_ToyCarbonModel.m
%%%%     fn_GetVegParams.m
%%%%     fn_GegNPPScenario.m
%%%%     TCM0.m
%%%%
%%%% Outputs a .mat file with time series of carbon inventories and fluxes
%%%%

%%
clear all

%---------------------------------------------------------------------------
%% Step 1:  Specify VegetationType and get parameters for the VegType
%---->>>>> Specify Ecosystem type here! <<<<----%
% Options: 'TRF', 'TempForest','BorealForest','Grass'
VegType='BorealForest';
    A=fn_GetVegParams(VegType);
    VegName=A.VEGNAME;
    NPPmean=A.NPPMEAN;
    taus=A.TAUS;
    alloc=A.ALPHA;

%----------------------------------------------------------------------------
%% Step 2: Specify Time Domain (years)
tmin=1;     % years
tmax=50;    % years
stepsperyear=52;   % timestep for integration

    dt=1./stepsperyear; 
    tseries=tmin:dt:tmax;  %time series for intergration, in years

%-----------------------------------------------------------------------------
%% Step 3:  Specify NPP fluctuations

scenario='defor';

switch scenario
    case 'NatVar'     % oscillatory perturbation
        %--->> Modify oscillatory signal in NPP here! <<<---%
        ampNPP=0.1;   % relative amplitude of sinusoidal perturbation to NPP
        periodNPP=1;  % years  
        NPPrel=fn_GetNPPScenario(tseries, 'NatVar', ampNPP, periodNPP);

    case 'trend'   %NPP trend; 
        rate=0.01;  % 0.001=0.1% per year
        NPPrel=fn_GetNPPScenario(tseries, 'trend', rate);
        
    case 'defor'   
        tintact=stepsperyear;   % number of timesteps for intact forest
        NPPrel=fn_GetNPPScenario(tseries, 'defor',tintact);
    
    case 'NatPlusTrend'
        ampNPP=0.1;   % relative amplitude of sinusoidal perturbation to NPP
        periodNPP=1;  % years  
        rate=0.01;  % 0.001=0.1% per year
        NPPrel=fn_GetNPPScenario(tseries, 'NatPlusTrend', ampNPP, periodNPP,rate);
end

NPP=NPPmean.*NPPrel;
figure(1), clf, plot(tseries, NPP); title('first round')

%=============================================================================
%% BIG STEP:  Integrate the Toy Carbon Model

Run_ToyEcoCarbonModel

%=============================================================================

%% quick check of output
nfig=10;
figure(10), clf, plot(tseries, NPP); 
xlabel('year'); ylabel('g/m2/yr'); title(VegType)
hold on, plot(tseries, RespHet,'r'),
plot(tseries, RespHet-NPP,'g')
legend('NPP','RespHet','NEE')
grid on

nfig=nfig+1; figure(nfig), clf,
plot(tseries, Mlive-Mlive(1)), title(VegType)
xlabel('year'); ylabel('g/m2')
hold on, plot(tseries, Mdead-Mdead(1),'r')
plot(tseries,Mlive+Mdead-Mlive(1)-Mdead(1),'g')
legend ('Mlive', 'Mdead','delM')
grid on

