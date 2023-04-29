pkg load statistics
pkg load stk

load 'E:/TACR/VS_LITE/META/meta_numeric.txt'; # Site metadata

fid = fopen('E:/TACR/VS_LITE/META/meta_text.txt'); # Site names
meta_text = textscan(fid, '%s', 'Delimiter', '\n');
meta_text2 = meta_text{1};
fclose(fid);



for i = (1:745) 
    site = meta_text2{[i, 1]};
  
    # Loading and storing important input data
    phi = meta_numeric(i, 1);
  
    eval((['load E:/TACR/VS_LITE/TRW/', ([site]), '_rwl.txt']));
    chronology = eval([strrep(site, '"', ''), '_rwl']);
    eval((['load E:/TACR/VS_LITE/KLIM/', ([site]), '_T.txt']));
    temperature = eval([strrep(site, '"', ''), '_T']); 
    eval((['load E:/TACR/VS_LITE/KLIM/', ([site]), '_P.txt']));
    precipitation = eval([strrep(site, '"', ''), '_P']);  
  
    end_year = 60 - (2020 - meta_numeric(i, 4));
  
    # Removing temporary files
    eval(["clear ", strrep(site, '"', ''), '_T'])
    eval(["clear ", strrep(site, '"', ''), '_P'])
    eval(["clear ", strrep(site, '"', ''), '_rwl'])
      
     % Random approach
     [random, MAX] = estimate_randomization_decline(chronology, temperature'(:, 1:end_year), precipitation'(:, 1:end_year), phi, 1, end_year);
      
     [mod, gT, gM, gE, moist, gINT] = VSLite_decline(1, 60, phi, MAX, temperature'(:, 1:60), precipitation'(:, 1:60));
  
     # Saving outputs
     obsmod = [chronology mod(1:end_year)'];
     eval(['save E:/TACR/VS_LITE/VYSTUPY/obsmod/', strrep(site, '"', ''), '_obsmod.txt obsmod']);
     
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gT/', strrep(site, '"', ''), '_gT.txt gT']);
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gM/', strrep(site, '"', ''), '_gM.txt gM']);
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gINT/', strrep(site, '"', ''), '_gINT.txt gINT']);
     eval(['save E:/TACR/VS_LITE/VYSTUPY/gE/', strrep(site, '"', ''), '_gE.txt gE']);
     
     eval(['save E:/TACR/VS_LITE/VYSTUPY/moist/', strrep(site, '"', ''), '_moist.txt moist']);
     temp_save = temperature';
     eval(['save E:/TACR/VS_LITE/VYSTUPY/temp/', strrep(site, '"', ''), '_temp.txt temp_save']);

     eval(['save E:/TACR/VS_LITE/VYSTUPY/parameters/', strrep(site, '"', ''), '_BOX.txt random']);
     eval(['save E:/TACR/VS_LITE/VYSTUPY/parameters/', strrep(site, '"', ''), '_MAX.txt MAX']);

     disp(['Site ', site, ' processed with correlation of ', num2str(MAX(1,9))]);
     
     clear mod gT gM gE gINT moist cor end_year obsmod MAX random temp_save
     clear phi site precipitation temperature chronology
    
endfor