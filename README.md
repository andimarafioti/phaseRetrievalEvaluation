# [Time-Frequency Phase Retrieval for Audio --- The Effect of Transform Parameters]()


In audio processing applications, phase retrieval (PR) is often performed from short-time Fourier transform (STFT) coefficients. Although PR performance has been observed to depend on the considered STFT parameters and audio data, the extent of this dependence has not been systematically evaluated yet. To address this, we studied the performance of three PR algorithms for various types of audio content and various STFT parameters such as redundancy, time-frequency ratio, and type of the window. The quality of PR was studied in terms of auditory-based and signal-based measures, namely objective difference grade, and signal-to-noise ratio of the STFT magnitude. Our results show that PR quality improved with increasing redundancy, with a strong relevance of the time-frequency ratio. The effect of the audio content was smaller but still observable. Interestingly, for optimal PR quality, each of the three algorithms required a different set of parameters, demonstrating the relevance of individual parameter sets for a fair comparison across PR algorithms. Based on these results, we developed a tool for finding optimal STFT parameters, considering arbitrary PR algorithms and types of audio content.  

# Instructions
To get started, initialize and update the submodules (LTFAT, Phaseret, PEAQ)
```
git submodule init
git submodule update
```

# Usage

In order to use our implementation to find the best set of STFT parameters for a phase retrieval algorithm, we provide two scripts inside of the  'findBestParams' folder: 'findBestParams.m' and 'testFindBestParams.m'. The first one, contains the function that analyses a phase retrieval algorithm over a set of STFT parameters and returns the set of parameters that perform best. To clear any doubts as to how this function should be used, we also provide the script 'testFindBestParams.m' as an example.


## Resources

- The paper will be available after going through peer-review.


### Acknowledgments

This project accompanies the research work on phase retrieval done at the Acoustics Research Institute in Vienna. The paper was submitted to an IEEE journal and is under review.

