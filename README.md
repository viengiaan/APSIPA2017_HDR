# APSIPA2017_HDR

These are all training, loss function, test, and solver scripts of our single-shot HDR imaging for APSIPA 2017.

Prerequisites  
-------------
* Caffe (Matcaffe and Pycaffe)
* Python 3.xxx
* Matlab 2020a
* HDR tool box: run "installHDRToolbox.m" in "HDR_Toolbox-master" folder.

Full version for training
-------------
No plan  

How to train
-------------
caffe train -solver [PATH]/solver.prototxt

How to test
-------------
> After training: run "main.m" in "matlab_code" folder for testing.

Citing Single-Shot HDR Imaging
-------------

If you find our work useful in your research, please consider citing:

    @INPROCEEDINGS{APSIPA2017_An,
        author = {V. G. {An} and C. {Lee}},
        title = {Single-shot high dynamic range imaging via deep convolutional neural network},
        booktitle = {2017 Asia-Pacific Signal and Information Processing Association Annual Summit and Conference (APSIPA ASC)},
        year = {2017},
        pages={1768-1772},
    }

