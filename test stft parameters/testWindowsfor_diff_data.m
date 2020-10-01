clear all

%ltfatstart(); % start the ltfat toolbox
%phaseretstart;

L = 2^11 * 3 * 5;

d = 32* propdiv(L/32);

M = d(find(d>=64 & d<L/2));
M = [32 M];
red = [32, 8, 2];

tfrs = (M.^2./(L.*red)')';

%%
examples = 128;
base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\Lakh\new-simple-piano\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_midi_PGHI, SC_midi_PGHI, ODG_midi_SPSI, SC_midi_SPSI] = evalPGHIandSPSIOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\LJSpeech-1.1\wavs\';
soundfiles = findWavFiles(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_speech_PGHI, SC_speech_PGHI, ODG_speech_SPSI, SC_speech_SPSI] = evalPGHIandSPSIOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\fma_electronic\';
soundfiles = findMp3Files(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_electronic_PGHI, SC_electronic_PGHI, ODG_electronic_SPSI, SC_electronic_SPSI] = evalPGHIandSPSIOnFolder(soundfiles, M, red, L);

base_folder = '\\kfsnas08.kfs.oeaw.ac.at\Denklast\amarafioti\Documents\Datasets\fma_rock\';
soundfiles = findMp3Files(base_folder);
soundfiles = soundfiles(1:examples);
[ODG_rock_PGHI, SC_rock_PGHI, ODG_rock_SPSI, SC_rock_SPSI] = evalPGHIandSPSIOnFolder(soundfiles, M, red, L);



