function filenames = findWavFiles(base_folder)

dirinfo = dir(base_folder);
dirinfo(~[dirinfo.isdir]) = [];
filenames = [dir(fullfile(base_folder, '*.wav'))];

for K = 1 : length(dirinfo)
  thisdir = dirinfo(K).name;
  filenames = [filenames ; dir(fullfile(base_folder, thisdir, '*.wav'))];
end

end