clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

L = 2^13 * 3 * 5;

d = 32* propdiv(L/32);

M = d(find(d>=1024 & d<L/16));
%M = [32 M];
red = [32, 16, 8, 4, 2];

tfrs = (M.^2./(L.*red)')';

%%
examples = 2;
base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_midi, SC_midi] = evalPGHIOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_speech, SC_speech] = evalPGHIOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\fma_electronic\';
soundfiles = findMp3Files(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_electronic, SC_electronic] = evalPGHIOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\fma_rock\';
soundfiles = findMp3Files(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_rock, SC_rock] = evalPGHIOnFolder(soundfiles, M, red, L);

plotStats(1, mean(ODG_midi, 1), M, tfrs, 'Perceptual quality of phaseless reconstruction', 'PEAQ PGHI', [-4,0.5])
plotStats(2, mean(SC_midi, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC PGHI', [-60,6])
plotStats(3, mean(ODG_speech, 1), M, tfrs, 'Perceptual quality of phaseless reconstruction', 'PEAQ FGLA', [-4,0.5])
plotStats(4, mean(SC_speech, 1), M, tfrs, 'Objective quality of phaseless reconstruction', 'SC FGLA', [-60,6])



