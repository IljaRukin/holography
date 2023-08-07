import numpy as np
import matplotlib.pyplot as plt
import struct
i = complex(0,1)

### decoding functions


def char(fid,num):
    result = ''
    for count in range(num):
        #x = fid.read(num)
        #for item in struct.unpack('@'+'c'*int(len(x)),x):
        x = fid.read(1)
        item = struct.unpack('@c',x)
        result += item[0].decode("utf-8") 
    return result

def bool1(fid,num):
    result = np.empty(num,dtype=bool)
    for count in range(num):
        #x = fid.read(num*1)
        #for item in struct.unpack('@?'+'c'*int(8*len(x)),x):
        x = fid.read(1)
        item = struct.unpack('@'+'?'*int(8*len(x)),x)
        for bit in range(8):
            result[count*8+bit] = item[bit]
    return result

def uint8(fid,num):
    result = np.empty(num,dtype=int)
    for count in range(num):
        #x = fid.read(num*1)
        #for item in struct.unpack('@'+'B'*int(len(x)),x):
        x = fid.read(1)
        item = struct.unpack('@B',x)
        result[count] = item[0]
    return result

def uint16(fid,num):
    result = np.empty(num,dtype=int)
    for count in range(num):
        #x = fid.read(num*2)
        #for item in struct.unpack('@'+'H'*int(len(x)/2),x):
        x = fid.read(2)
        item = struct.unpack('@H',x)
        result[count] = item[0]
    return result

def int32(fid,num):
    result = np.empty(num,dtype=int)
    for count in range(num):
        #x = fid.read(num*4)
        #for item in struct.unpack('@'+'i'*int(len(x)/4),x):
        x = fid.read(4)
        item = struct.unpack('i',x)
        result[count] = item[0]
    return result

def uint32(fid,num):
    result = np.empty(num,dtype=int)
    for count in range(num):
        #x = fid.read(num*4)
        #for item in struct.unpack('@'+'I'*int(len(x)/4),x):
        x = fid.read(4)
        item = struct.unpack('@I',x)
        result[count] = item[0]
    return result

def float(fid,num):
    result = np.empty(num,dtype='float')
    for count in range(num):
        #x = fid.read(num*4)
        #for item in struct.unpack('@'+'d'*int(len(x)/4),x):
        x = fid.read(4)
        item = struct.unpack('@d',x)
        result[count] = item[0]
    return result

def double(fid,num):
    result = np.empty(num,dtype='double')
    for count in range(num):
        #x = fid.read(num*8)
        #for item in struct.unpack('@'+'d'*int(len(x)/8),x):
        x = fid.read(8)
        item = struct.unpack('@d',x)
        result[count] = item[0]
    return result

### main function

def loadData(FileName):
    
    with open(FileName,'rb') as fid:

        magicword    = char( fid,8 )
        headerLength = uint16( fid,1 )[0]
        dataOffset   = uint16( fid,1 )[0]
        datatype     = uint16( fid,1 )[0]
        width        = uint32( fid,1 )[0]
        height       = uint32( fid,1 )[0]
        depth        = uint16( fid,1 )[0]
        descriptorLength = dataOffset - headerLength
        descriptor   = char( fid,descriptorLength )
        '''
        # print for debugging
        print( magicword )
        print( headerLength )
        print( dataOffset )
        print( datatype )
        print( width )
        print( height )
        print( depth )
        print( descriptorLength )
        print( descriptor )
        '''
        if datatype == 1088 and depth == 128:     # complex<double>
            image = double(fid,2*height*width)
            image = image[0::2] + i*image[1::2]
            image = np.reshape(image, [width,height])
        else:
            print('Unable to read file - or functionality was not implemented (edit source code to enable untested functionality.)')
        '''
        ### not tested:
        elif datatype == 64 and depth == 64:      # complex<float>
            image = float(fid,2*height*width)
            image = image[0::2] + i*image[1::2]
            image = np.reshape(image, [width,height])
        elif datatype == 1024 and depth == 64:    # double
            image = double(fid,height*width)
            image = np.reshape(image, [width,height])
        elif datatype == 32 and depth == 32:      # float
            image = float(fid,height*width)
            image = np.reshape(image, [width,height])
        elif datatype == 16 and depth == 32:      # int32
            image = int32(fid,height*width)
            image = np.reshape(image, [width,height])
        elif datatype == 8 and depth == 16:       # short
            image = uint16(fid,height*width)
            image = np.reshape(image, [width,height])
        elif datatype == 1 and depth == 8:        # byte
            image = uint8(fid,height*width)
            image = np.reshape(image, [width,height])
        elif datatype == 2 and depth == 1:        # boolean (bit mask)
            roundedWidth = 8 * np.ceil(height/8)
            image = bool1(fid,height*roundedWidth)
            for k in range(8):
                image[(8-k):roundedWidth:8,:] = image[k:roundedWidth:8,:]
            image = image[1:height,:]
        else:
            print('Unable to read file')
        '''
    return image
