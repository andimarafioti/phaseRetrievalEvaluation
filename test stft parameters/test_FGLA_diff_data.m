clear all

ltfatstart(); % start the ltfat toolbox
phaseretstart;

L = 2^13 * 3 * 5;

d = 32* propdiv(L/32);

M = d(find(d>=64 & d<L/2));
M = [32 M];
red = [8, 2];

tfrs = (M.^2./(L.*red)')';

%%
examples = 128;
base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_midi_FGLA, SC_midi_FGLA] = evalFGLAOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_speech_FGLA, SC_speech_FGLA] = evalFGLAOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\fma_electronic\';
soundfiles = findMp3Files(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_electronic_FGLA, SC_electronic_FGLA] = evalFGLAOnFolder(soundfiles, M, red, L);

save('fgla_diff_data_2.mat', 'ODG_midi_FGLA', 'SC_midi_FGLA', 'ODG_speech_FGLA', 'SC_speech_FGLA', 'ODG_electronic_FGLA', 'SC_electronic_FGLA', 'M', 'red', 'L')

