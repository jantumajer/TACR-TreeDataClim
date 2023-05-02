function[random_par, MAX] = estimate_randomization_decline(trw, temp, prec, phi, startyear, endyear)

  pkg load stk; pkg load statistics;
  more off

  cycles = 60000; % Here set the number of independent simulations optimal for <10000

  # tic
  for i = 1:cycles
  
    random_par(i,1) = double(stk_sampling_randomlhs(1, [0; 10]));                             % T1
    random_par(i,2) = double(stk_sampling_randomlhs(1, [(random_par(i,1) + 1); 20]));         % T2
    random_par(i,3) = double(stk_sampling_randomlhs(1, [(random_par(i,2) + 1); 30]));         % T3
    random_par(i,4) = double(stk_sampling_randomlhs(1, [(random_par(i,3) + 1); 35]));         % T4
    random_par(i,5) = double(stk_sampling_randomlhs(1, [0; 0.65]));                           % M1
    random_par(i,6) = double(stk_sampling_randomlhs(1, [(random_par(i,5) + 0.05); 1.0]));     % M2
    random_par(i,7) = double(stk_sampling_randomlhs(1, [random_par(i,6); 1.0]));              % M3
    random_par(i,8) = double(stk_sampling_randomlhs(1, [random_par(i,7); 1.0]));              % M4
    
    %%% Model
    [mod, gT, gM, gE, moist, gINT] = VSLite_decline(startyear, endyear, phi, random_par(i,1:8), temp, prec);
  
    %%% Storing correlation between simulated and observed chronology  
    if sum(sum(gINT) == 0) + sum(sum(gINT) == sum(gE)) < 6
          random_par(i, 9) = corr(mod', zscore(trw(:, 2)))(1,1); % correlation coefficient 
       else
          random_par(i, 9) = -999; % code for models with a high frequency of missing rings or simulated stable growth
    endif

   # disp(['Hotovo ', num2str(round(100*i/cycles)), ' % cyklu.']);
  
  endfor
  # toc
  
  MAX = random_par(random_par(:,9) == max(random_par(:,9)),:);
  
end
