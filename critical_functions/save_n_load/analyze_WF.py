import numpy as np
import matplotlib.pyplot as plt
import loadFPimage

folder = './results/'

FileNames = ['Butterfly_FullAmplitude_ConstantPhase_mma4x4_z-100_lambda638_Dm8_Dn8.fp.img']

for FileName in FileNames:
    data = loadFPimage.loadData(folder+FileName)

    plt.imshow(np.angle(data[400:600,400:600]), cmap='jet')
    plt.colorbar()
    #plt.show()
    plt.savefig(FileName+'.png')
    plt.clf()
