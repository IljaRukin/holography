#  list of all scripts, functions and folders with their usage

### folder with functions for calibration of the experimental setup
calibration
#### image for lateral alignment calibration
calibration/alignment_calibration/align_slms_rectangles.png
#### script displays patterns for lateral alignment calibration
calibration/alignment_calibration/justage.m
#### 
calibration/amp_correct.mat
calibration/amplitude_calibration
calibration/amplitude_correction.m
calibration/blazed_gratings
calibration/phase_shifting.m
calibration/amplitude_calibration/632.8_1.000.png
calibration/amplitude_calibration/generate_phase_offsets.m
calibration/blazed_gratings/blaze_gitter_green.png
calibration/blazed_gratings/blaze_gitter_lowfreq.png
calibration/blazed_gratings/blaze_gitter_red.png

###
critical_functions
critical_functions/data_manipulation
critical_functions/error_function
critical_functions/error_metrics
critical_functions/image_manipulation
critical_functions/image_registration
critical_functions/linear_interpolation
critical_functions/save_n_load
critical_functions/scripts
critical_functions/stft
critical_functions/data_manipulation/avg.m
critical_functions/data_manipulation/covariance.m
critical_functions/data_manipulation/nosign.m
critical_functions/data_manipulation/sq2.m
critical_functions/data_manipulation/variance.m
critical_functions/error_function/erf.dll
critical_functions/error_function/erfz.dll
critical_functions/error_function/erfz.m
critical_functions/error_function/erfz.pdf
critical_functions/error_metrics/myCORR.m
critical_functions/error_metrics/myPSNR.m
critical_functions/error_metrics/mySSIM.m
critical_functions/error_metrics/psnrhvsm.m
critical_functions/image_manipulation/crop.m
critical_functions/image_manipulation/fftConvolution.m
critical_functions/image_manipulation/scaleNormalize.m
critical_functions/image_manipulation/scaleValues.m
critical_functions/image_registration/automatic_image_registration.m
critical_functions/image_registration/handpicked_image_registration.m
critical_functions/image_registration/refine_undistort_trafo.m
critical_functions/image_registration/shift_image.m
critical_functions/image_registration/undistort_image.m
critical_functions/image_registration/undistort_trafo.m
critical_functions/linear_interpolation/calc_offset.m
critical_functions/linear_interpolation/GetPrincipalFrequency.m
critical_functions/linear_interpolation/GetPrincipalFrequency_subpixel.m
critical_functions/linear_interpolation/linfit1D.m
critical_functions/linear_interpolation/linfit2D.m
critical_functions/linear_interpolation/test_linfit_1D.m
critical_functions/linear_interpolation/test_linfit_2D.m
critical_functions/save_n_load/analyze_WF.py
critical_functions/save_n_load/loadFPImage.m
critical_functions/save_n_load/loadFPimage.py
critical_functions/save_n_load/saveFPImage.m
critical_functions/save_n_load/saveGIF.m
critical_functions/scripts/average_images.m
critical_functions/scripts/img2gif.m
critical_functions/scripts/img2vid.m
critical_functions/scripts/load_slice_image.m
critical_functions/scripts/sum_of_wavefields.m
critical_functions/stft/example.mlx
critical_functions/stft/istft.m
critical_functions/stft/mySTFTexample.m
critical_functions/stft/README.md
critical_functions/stft/resources
critical_functions/stft/stft.m
critical_functions/stft/Stft.prj

###
slm_phase
slm_phase/AmpMod_calibratedCurve.m
slm_phase/AmpMod_phases.m
slm_phase/loadTTPAparams.m
slm_phase/MMAphasetiling.m
slm_phase/MMAtiling.m
slm_phase/Phase2TTP.m
slm_phase/pseudorandomPhase.m
slm_phase/RELPH_phases.m
slm_phase/saveTTPAparams.m
slm_phase/SLMphasetiling.m
slm_phase/SLMtiling.m
slm_phase/test_tiling.m
slm_phase/TTP2Phase.m
slm_phase/TTP_parameters.txt

###
interfacing
interfacing/capture_FPimg.m
interfacing/capture_loop.m
interfacing/capture_png.m
interfacing/display_fullscreen.m
interfacing/display_holo.m
interfacing/fp2png.m
interfacing/open_camera.m

###
propagation
propagation/angular_spectrum.m
propagation/angular_spectrum_occlusion.m
propagation/convolution.m
propagation/exponentials_and_signs.txt
propagation/fourier_multiplication_antialias.m
propagation/fourier_multiplication.m
propagation/fresnel.m
propagation/fresnel_scaled.m
propagation/magnify_by_1lens.m
propagation/sommerfeld.m

###
geometry_rendering
geometry_rendering/GeneralLineFT.m
geometry_rendering/getRotation3D.m
geometry_rendering/line_rendering.m
geometry_rendering/planes_rendering.m
geometry_rendering/triangle_rendering.m
geometry_rendering/UnitLineFT.m
geometry_rendering/UnitTriangleFT.m

###
iterative_rendering
iterative_rendering/GSA.m
iterative_rendering/wirtinger_fullres.m
iterative_rendering/wirtinger_mma.m
iterative_rendering/wirtinger_slm.m

###
wigner_fkt
wigner_fkt/ColorCodedDirection.m
'wigner_fkt/color space.png'
wigner_fkt/HSVcolorCircle.m
wigner_fkt/multOFshifts1D.cu
wigner_fkt/multOFshifts1D.ptx
wigner_fkt/multOFshifts2D.cu
wigner_fkt/multOFshifts2D.ptx
'wigner_fkt/random gpu examples'
wigner_fkt/simple_colorcoding.m
wigner_fkt/wigner1D.m
wigner_fkt/wigner2D.m
'wigner_fkt/wigner simulation parameters.txt'
'wigner_fkt/random gpu examples/cuda_fft.cu'
'wigner_fkt/random gpu examples/cudafft.mexw64'
'wigner_fkt/random gpu examples/cudafft_script.m'
'wigner_fkt/random gpu examples/GPUinfo.m'
'wigner_fkt/random gpu examples/mandelbrotComplex.cu'
'wigner_fkt/random gpu examples/mandelbrotComplex.m'
'wigner_fkt/random gpu examples/mandelbrotComplex.ptx'
'wigner_fkt/random gpu examples/mandelbrot.cu'
'wigner_fkt/random gpu examples/mandelbrot.m'
'wigner_fkt/random gpu examples/mandelbrot.ptx'
'wigner_fkt/random gpu examples/mexCUDAadd.cu'
'wigner_fkt/random gpu examples/mexCUDAadd.mexw64'
'wigner_fkt/random gpu examples/mexCUDAadd_script.m'
'wigner_fkt/random gpu examples/simpleGPUFFT.m'

###
undistort_image
undistort_image/2butterfly4096.jpg
undistort_image/Butterfly_ConstantPhase_fullres_z-100_lambda638_Dm8_Dn8.fp_AmpMod_exposure3000.png
undistort_image/Butterfly_ConstantPhase_mma16x16_z-100_lambda638_Dm8_Dn8.fp_AmpMod_exposure3000.png
undistort_image/calculate_modify_transform.m
undistort_image/calculate_transform.m
undistort_image/distorsion_interpolation.mat
undistort_image/distorsion_matrix.mat
undistort_image/processed_fullres.png
undistort_image/processed_mma16x16.png
undistort_image/processed_mod_fullres.png
undistort_image/processed_mod_mma16x16.png
undistort_image/process_image.m
undistort_image/process_modify_image.m
undistort_image/reference.png

### images and 3D files for hologram rendering
objects4display/2D_planes/
objects4display/3D_objects/

### folder where computation results are stored
results

### load all necessary ifunctions to path
initialize.m

### simulate wavefield propagation
reconstruct.m

### render wavefield
render.m
