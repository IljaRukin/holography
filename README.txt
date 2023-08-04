# Hologram generation/display enviroment

note that the phase for hologram display can either be directly displayed using "..." or saved in an image specific to the currently used SLM (with phase stored as bit values 0-255 in RGB colors) with "./interfacing/fp2png".

to use all scripts first load all script paths by executing:
'''
initialize.m
'''

## calibration
- displaying blazed gratings supplied in "./calibration/blazed_gratings" can help find the alignment of the polarizers & wave plate to maximize contrast.
- align two SLMs lateraly using the image "./calibration/alignment_calibration/align_slms_rectangles.png" or by generating and displaying some patterns using "./calibration/alignment_calibration/justage.m"
- for amplitude modulation with a phase SLM light is polarized at 45° offset from SLMs modulation plane so half of the incident light does not get modulated. The Amplitude modulation happens by destructive interference between modulated and unmodulated light. Determine the phase offset between modulated and unmodulated light by displaying different phase modulations from "./calibration/amplitude_calibration/" which are generated with the script "./calibration/amplitude_calibration/generate_phase_offsets.m" for a specific wavelength. The phase modulation at which the center circle has the highest intensity should be used as the "offset" parameter for amplitude modulation.
- to compensate phase errors make a calibration using phase shifting with "./calibration/phase_shifting.m". This stores the correction in the file "dPhi_SLM.mat".
- to compensate amplitude non-uniformity make a amplitude calibration by measuring the intensity with "./calibration/amplitude_correction.m". This stores the correction in the file "amp_correct.mat".
- to help calibration the script "./interfacing/open_camera.m" can be used to observe the light by the camera.

## rendering (calculating wavefield for hologram display)
- hologram rendering for displaying an image in a plane is done with "./render.m". The result is a ".fp.img" file, which can be read and written with the functions "/critical_functions/save_n_load/loadFPImage.m" and "/critical_functions/save_n_load/saveFPImage.m". For rendering simple 3D objects you can define intensities in multiple planes at depths "zSlices" which all get rendered separately and added up.
- hologram rendering for displaying 3D objects can be done with "./geometry_rendering/line_rendering.m" and "./geometry_rendering/triangle_rendering.m" by defining the object using lines (manually) or triangles (from .obj file). These functions render the holograms from these primitives directly. Another option for rendering objects composed of triangles is to split these triangles into multiple perpendicular planes and propagating the planes separately or plane to plane (takeing occlusion into account) with the script "./geometry_rendering/planes_rendering.m".

## modifying holograms
- adding constant/random phase should be done during rendering.
- Regression of the wavefield to corser resolution SLM/TTP-MMA can be done with the functions "MMAtiling" and "SLMtiling"
- indirect amplitude modulation can be done with ...

## displaying holograms
- display one single image using "./interfacing/display_holo.m" which uses "./interfacing/display_fullscreen.m" in the background. For the display amplitude/phase correction can be included, the wavefield modified, the SLM-orientation (flip horz./vert.) corrected and the encoding of the amplitude (RELPH [michelson interferometer]/4F [destructive interference]) specified.
- for easier handling and displaying the holograms from images on the fly (e.g. using irfanview) use the script "./interfacing/fp2png" to convert ".fp.img" wavefield files to ".png" images where the phase at the SLMs is color coded in RGB using 256bits.

## capturing images
- once the camera has been started with "./interfacing/open_camera.m" the intensity can be captured using just 3 lines:
'''
frame = getsnapshot(x);
figure(1);imshow(frame);
imwrite(frame,'myIMG.png');
'''
- to capture multiple images in a loop of the same scene (e.g. while focusing on different depths) use "./capture_loop.m".
- to capture many different holograms from images ".png" at once use "./capture_png.m".
- to capture many different holograms from images ".fp.img" at once use "./capture.m".

## undistroting images
- you can undistort captured images to make them comparable to the original image. to do so an example is provided in the folder "./undistort_image/".

## simulation
- to simulate the display of a hologramm the script "./reconstruct" can be used. It simulates the propagation of the wavefield to a specified depth. Moreover the wavefield passing through a partially closed aperture is simulated, as well as the lightfield (using stft) computed.
- the wigner function of a wavefield can be calculated with "./wigner_fkt/wigner1D.m" and "./wigner_fkt/wigner2D.m" in 1D and 2D. Both calculation have the option to be executed on the cpu or gpu (appropriate cuda drivers needed !)

## required software:
matlab + genicaminterface extension
(infranview)
(vimbaviewer driver)
