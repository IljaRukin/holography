close all;clear;clc;
Mslm = 1920;
Nslm = 1080;
lambda = 0.000638; offset = 0.75*2*pi; %wavelength + amplitude modulation phase offset
%lambda = 0.000532; offset = 0.45*2*pi; %wavelength + amplitude modulation phase offset

%path to wavefield data ".fp.img"
path = '../results/';

%include phase correction (from phase shifting)
correctPhase = false;
%include amplitude correction
correctAmplitude = true;

%tile wavefield for mirror-array and lowres slm simulation
% mirrorPixels = [1];
mirrorPixels = [1,2,4,8,16,32,64];

%binary amplitude modulation by thresholding;
%disabled for amplitudeThresholds=-1
%unit amplitude for amplitudeThresholds=0
amplitudeThresholds = [-1];
% amplitudeThresholds = [-1,0];
% amplitudeThresholds = [-1,0,0.01,0.1,0.2,0.5,0.8,0.9];

% use amplitude average instead of max fft coefficient
AverageAmplitude = false;

%filenames = {'E1.fp.img','E2.fp.img','E3.fp.img'};
files = dir(fullfile(path, '*.fp.img'));
filenames = {files.name};

for filename=filenames
    filename = char(filename);
    fprintf("%s \n",filename);
    
    E0 = loadFPImage([path,filename]);
    [N,M,~] = size(E0);
    
    %add phase calibration, if file exist and correctPhase=true
    if correctPhase && (exist('dPhi_SLM.mat', 'file') == 2)
        dPhi_SLM = load('../calibration/dPhi_SLM.mat');
        dPhi_SLM = crop( dPhi_SLM.dPhi_SLM ,N,M);
        E0 = E0.*exp(1i*2*pi*dPhi_SLM);
    end

    %add amplitude calibration, if file exist and correctAmplitude=true
    if correctAmplitude && (exist('amp_correction.mat', 'file') == 2)
        amp_correct = load('../calibration/dPhi_SLM.mat');
        amp_correct = crop( amp_correct.amp_correct ,N,M);
        E = E.*amp_correct;
    end

    for PixPerMirror=mirrorPixels
        %%%tile wavefield for mirror-array
        if PixPerMirror>1
            tilingSetupNR=3;
        else
            tilingSetupNR=1;
        end
        
        for tilingSetup=1:tilingSetupNR
            if tilingSetup==1 %fullres SLM
                Et = E0;
                setupname = '_fullres';
            elseif tilingSetup==2 %mirror-array
                Et = MMAtiling(E0,PixPerMirror,PixPerMirror);
                setupname = ['_MApix',num2str(PixPerMirror)];
            else %lowresSLM
                Et = SLMtiling(E0,PixPerMirror,PixPerMirror);
                setupname = ['_SLMpix',num2str(PixPerMirror)];
            end
            Et = Et/max(abs(Et(:)));
            
            for amplitudeThreshold=amplitudeThresholds
                if amplitudeThreshold==-1
                    E = Et;
                    thresholdname = '_fullamp';
                else
                    E = (sq2(Et)>=amplitudeThreshold).*exp(i*angle(Et));
                    thresholdname = ['_ampt',num2str(amplitudeThreshold)];
                end
                
                %%% wavefield amplitude/phase
                amp0 = abs(E);
                phi0 = angle(E);
                
%                 %%% generate phases for relph
%                 [phi1,phi2] = RELPH_phases(E);
%                 %---
%                 phiRGB = zeros(N,M,3);
%                 phiRGB(:,:,1) = phi2;
%                 phiRGB(:,:,2) = fliplr( phi1 );
%                 phiRGB = crop( mod(phiRGB/(2*pi),1) ,Nslm,Mslm) *lambda/0.000633;
%                 imwrite(phiRGB,[path,filename(1:end-7),setupname,thresholdname,'_RELPH.png']);
                
                %%% generate phases for 4f amplitude modulation
                [amp3,phi3] = AmpMod_phases(E,offset);
                %---
                phiRGB = zeros(N,M,3);
                phiRGB(:,:,1) = flipud(fliplr( amp3 )); %offset;
                phiRGB(:,:,2) = phi3; %phi0;
                phiRGB(:,:,3) = phi0;
                phiRGB = crop( mod(phiRGB/(2*pi),1) ,Nslm,Mslm) *lambda/0.000633;
                
                saveFPImage(E,[path,filename(1:end-7),setupname,thresholdname,'.fp.img']);
                imwrite(phiRGB,[path,filename(1:end-7),setupname,thresholdname,'.png']);
                
            end
            
        end
    end
end