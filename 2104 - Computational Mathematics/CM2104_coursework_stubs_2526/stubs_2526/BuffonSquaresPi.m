%% Task 2 - modified version of “Buffon’s needle” that drops squares
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

function [p,crossings] = BuffonSquaresPi(width,length,throws)
if nargin < 3
    error('BuffonSquaresPi requires width, length, and throws.');
end

if ~(isnumeric(width) && isnumeric(length) && isnumeric(throws)) || width <= 0 || length <= 0 || throws <= 0
    error('width, length and throws must be positive numbers.');
end

crossings = 0;
halfL = length/2;

corners = halfL * [
    -1, -1;
    1, -1;
    1,  1;
    -1,  1
    ];

% used to project between vertices for crossings
edges = [1 2; 2 3; 3 4; 4 1];

% the rotation matrix, as an inline function
R = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

for i = 1:throws
    centreX = width * rand();
    centreY = width * rand();
    theta = pi*rand();

    rotated = (R(theta) * corners')';

    pts = rotated + [centreX, centreY];
    x = pts(:,1);
    idx = floor(x/width);
    crossings = crossings + sum( ...
        idx(edges(:,1)) ~= idx(edges(:,2)) ...
    );
end

totalNeedles = throws * 4;
if crossings == 0
    p = NaN;
else
    p = (2 * length * totalNeedles) / (crossings * width);
end

if nargout < 1
    error('At least one output argument (p) must be requested.');
end
end