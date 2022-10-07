%
%converts from internal representation of timestamps to real timestamps
%
%internal representation (indTimestamps) is relative to the currently processed block (0=start of current block)
%rawTimestamps is absolute value retrieved from file. file has only one timestamp per block. each block
%consists of 512 values. 
%
%Fs: sampling rate
%
%if indTimestamps empty - > convert entire rawTimestamps to realTimestamps (multiply out blocks)
%
%orig: urut/april04
%updates: 
%urut/feb07. added Fs parameter.
%urut/april07. added fileformat parameter.
%
function realTimestamps = convertTimestamps_css( rawTimestamps, indTimestamps, Fs, fileFormat )



if fileFormat<=2 || fileFormat==6 || fileFormat==8
    %for neuralynx fileformat, convert to blocks

    realTimestamps = rawTimestamps(indTimestamps);

else
    %for other formats, take raw timestamp
    realTimestamps = rawTimestamps(indTimestamps);
    realTimestamps = realTimestamps';
end



