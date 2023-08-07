close all;clear;clc;
%% parameters
Mslm = 1920;
Nslm = 1080;
lambda = 0.000638; offset = 0.75*2*pi; %wavelength + amplitude modulation phase offset
display_screen = 1; %computer screen number on which to display

%% start camera
exposure_times = [300,1000,3000,10000,30000];
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 50000;

%% wavefield
sourcepath = './WF/';
destinationpath = './experiment_amplitude/';
files = dir(fullfile(sourcepath, '*4x4*z-250*.fp.img'));
filenames = {files.name};
files = dir(fullfile(sourcepath, '*fullres*z-250*.fp.img'));
filenames = horzcat(filenames,files.name);

countMAX = numel(filenames);
count = 0;
for filename=filenames
    count = count +1;
    fname = char(filename);
    fprintf("%s \n",fname);
    fprintf("%i / %i \n",count,countMAX);
    E=loadFPImage([sourcepath,fname]);
    [N,M,~] = size(E);
    
    %% parameters from filename (supports only integer values!)
    a0=strfind(fname,'z');a1=strfind(fname,'lambda');a2=strfind(fname,'Dm');a3=strfind(fname,'Dn');a4=strfind(fname,'.fp.img');
    if ~exist('z')
        z = str2double(fname(a0+1:a1-2));
    end
    if ~exist('lambda')
        lambda = str2double(fname(a1+6:a2-2))*1e-6;
    end
    if ~exist('Dm')
        Dm = str2double(fname(a2+2:a3-2))*1e-3;
    end
    if ~exist('Dn')
        Dn = str2double(fname(a3+2:a4-1))*1e-3;
    end

    %add phase calibration, if file exist and correctPhase=true
    correctPhase = false;
    if correctPhase && (exist('dPhi_SLM.mat', 'file') == 2)
        dPhi_SLM = load('dPhi_SLM.mat');
        dPhi_SLM = crop( dPhi_SLM.dPhi_SLM ,N,M);
        E = E.*exp(1i*2*pi*dPhi_SLM);
    end

    %add amplitude calibration, if file exist and correctAmplitude=true
    correctAmplitude = false;
    if correctAmplitude && (exist('amp_correct.mat', 'file') == 2)
        amp_correct = load('amp_correct.mat');
        amp_correct = flipud(fliplr( crop( amp_correct.amp_correct ,N,M) ));
        E = E.*amp_correct;
    end

    for amp=[-1,0,1,5,10,20,30,40,50,60,70,80,90]
        if amp==-1
            E0 = E;
            amplitude = ['_AmpMod'];
        else
            E0 = (sq2(E)>=(amp/100)^2).*exp(1i*angle(E));
            amplitude = ['_Amp',num2str(amp,'%03.f')];
        end

        %%% phase
        phi0 = angle(E0);

        %%% generate phases for relph
        % [phi1,phi2] = RELPH_phases(E0);
        % %---
        % phiRGB = zeros(N,M,3);
        % phiRGB(:,:,2) = phi2;
        % phiRGB(:,:,3) = fliplr( phi1 );

        %%% generate phases for 4f amplitude modulation
        [ampphi1,phi1] = AmpMod_phases(E0,offset);
        %---
        phiRGB = zeros(N,M,3);
        phiRGB(:,:,1) = ampphi1;
        phiRGB(:,:,2) = flipud(fliplr( phi1 ));
        phiRGB(:,:,3) = flipud(fliplr( phi0 ));

        %%% generated phases with unit amplitude modulation
        % phiRGB = zeros(N,M,3);
        % phiRGB(:,:,1) = offset;
        % phiRGB(:,:,2) = phi0;
        % phiRGB(:,:,3) = phi0;

        %scale phase for display
        phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
        phiRGB = crop( phiRGB ,Nslm,Mslm);

        f1 = display_fullscreen(display_screen,phiRGB);

        %%% capture images
        for expTime=exposure_times
            src.ExposureTime = expTime;
            pause(0.1);
            frame = getsnapshot(x);
            imwrite(frame,[destinationpath,fname(1:end-4),amplitude,'_exposure',num2str(expTime),'.png']);
        end

        %close(f1.Number);
    end
end

%% close camera
delete(x)
clear x
