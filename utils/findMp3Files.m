function filenames = findMp3Files(base_folder)

dirinfo = dir(base_folder);
dirinfo(~[dirinfo.isdir]) = [];
filenames = [dir(fullfile(base_folder, '*.mp3'))];

for K = 1 : length(dirinfo)
  thisdir = dirinfo(K).name;
  filenames = [filenames ; dir(fullfile(base_folder, thisdir, '*.mp3'))];
end

end