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

function [p, crossings, centreX, centreY, angle, crossing_mask] = BuffonStandardPi(width, length, throws, planks, plank_length)
arguments (Input)
    width (1,1) {mustBePositive}
    length (1,1) {mustBePositive}
    throws (1,1) {mustBePositive}
    planks (1,1) {mustBePositive} = 2
    plank_length (1,1) {mustBePositive} = 10
end
arguments (Output)
    p (1,1) double
    crossings (1,1) uint32
    centreX (1,:) double
    centreY (1,:) double
    angle (1,:) double
    crossing_mask (1,:) logical
end

if nargin < 3
    error('BuffonStandardPi requires width, length, and throws.');
end

total_width = planks * width;
centreX = total_width * rand(throws, 1);
centreY = plank_length * rand(throws, 1);
angle = pi * rand(throws, 1);
% half-length projection of needle, to find if a needle passes a crack
proj = (length/2) .* sin(angle);

% find the closest crack, to the left or right
offset = mod(centreX, width);
dist_to_boundary = min(offset, width - offset);

crossing_mask = proj >= dist_to_boundary;
crossings = sum(crossing_mask);

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
