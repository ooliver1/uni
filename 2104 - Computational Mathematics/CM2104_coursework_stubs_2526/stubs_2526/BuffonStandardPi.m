%% Task 1 - standard version of “Buffon’s needle”
% INPUTS, in order:
% width = the width of the floorboards;
% length = the length of the needles;
% throws = the number of needles thrown.
%
% OUTPUTS, in order:
% p = the estimate of pi,
% crossings = the number of needles that cross a plank;
%
% NOTE: should you need further input or output variables when integrating
% the function to the GUI, you must implement the necessary  checks  using
% nargin and nargout to  ensure  the  function  works  correctly  outside
% the GUI with the input and output combinations specified above.

function [p,crossings] = BuffonStandardPi(width,length,throws)
if nargin < 3
    error('BuffonStandardPi requires width, length, and throws.');
end

% assume two cracks, one plank
centre = width * rand(throws, 1);
angle = pi * rand(throws, 1);
half_length_projection = (length / 2) * sin(angle);
% passes the left side, or passes the right
crossings = sum(centre <= half_length_projection | centre >= (width - half_length_projection));

% P = 2L/pi d
% pi = 2L / P d
% pi = 2L th / cr d
if crossings == 0
    p = NaN;
else
    p = (2 * length * throws) / (crossings * width);
end

if nargout < 1
    error('At least one output argument (p) must be requested.');
end
end
