pkg load statistics
pkg load stk

load 'E:/TACR/VS_LITE/META/meta_numeric.txt'; # Site metadata with numeric values (coordinates)

fid = fopen('E:/TACR/VS_LITE/META/meta_text.txt'); # Site metadata with charcter values (names, codes)
meta_text = textscan(fid, '%s', 'Delimiter', '\n');
meta_text2 = meta_text{1};
fclose(fid);



for i = (1:18)  # Modify in case of a different number of sites to be processed
    site = meta_text2{[i, 1]};
  
    # Loading and storing important input data
    phi = meta_numeric(i, 1);
  
    eval((['load E:/TACR/VS_LITE/TRW/', ([site]), '_rwl.txt'])); # site chronology
    chronology = eval([strrep(site, '"', ''), '_rwl']);
    
    eval((['load E:/TACR/VS_LITE/KLIM/', ([site]), '_T.txt'])); # temperature
    temperature = eval([strrep(site, '"', ''), '_T']); 
    
    eval((['load E:/TACR/VS_LITE/KLIM/', ([site]), '_P.txt'])); # precipitation
    precipitation = eval([strrep(site, '"', ''), '_P']);  
  
    end_year = 60 - (2020 - meta_numeric(i, 4)); # Number of the last year of calculations
  
    # Removing temporary files
    eval(["clear ", strrep(site, '"', ''), '_T'])
    eval(["clear ", strrep(site, '"', ''), '_P'])
    eval(["clear ", strrep(site, '"', ''), '_rwl'])
      
    # Randomization approach
    [random, MAX] = estimate_randomization_decline(chronology, temperature'(:, 1:end_year), precipitation'(:, 1:end_year), phi, 1, end_year);
    
    # Calculating the model based on the best of all random combinations
    [mod, gT, gM, gE, moist, gINT] = VSLite_decline(1, 60, phi, MAX, temperature'(:, 1:60), precipitation'(:, 1:60));
  
     # Saving outputs
     obsmod = [chronology mod(1:end_year)'];
     eval(['save E:/TACR/VS_LITE/VYSTUPY/obsmod/', strrep(site, '"', ''), '_obsmod.txt obsmod']); # Modelled chronology
     
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gT/', strrep(site, '"', ''), '_gT.txt gT']); # grT - partial growth rate to temperature
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gM/', strrep(site, '"', ''), '_gM.txt gM']); # grM - partial growth rate to soil moisture
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gINT/', strrep(site, '"', ''), '_gINT.txt gINT']); # grINT - integral growth rate
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gE/', strrep(site, '"', ''), '_gE.txt gE']); # grE - partial growth rate to photoperiod
     
     eval(['save E:/TACR/VS_LITE/VYSTUPY/moist/', strrep(site, '"', ''), '_moist.txt moist']); # soil moisture
     temp_save = temperature';
     eval(['save E:/TACR/VS_LITE/VYSTUPY/temp/', strrep(site, '"', ''), '_temp.txt temp_save']); # air temperature

     eval(['save E:/TACR/VS_LITE/VYSTUPY/parameters/', strrep(site, '"', ''), '_BOX.txt random']); # all random sets of combinations considered
     eval(['save E:/TACR/VS_LITE/VYSTUPY/parameters/', strrep(site, '"', ''), '_MAX.txt MAX']); # the optimal combination of parameters

     disp(['Site ', site, ' processed with correlation of ', num2str(MAX(1,9))]);
     
     clear mod gT gM gE gINT moist cor end_year obsmod MAX random temp_save
     clear phi site precipitation temperature chronology
    
endfor
