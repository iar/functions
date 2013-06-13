function [mmm]=month(month_number)
%Converts month date in number format to three day month

month_number = mod(month_number,12);

%by: Michael Hutchins
switch month_number
    case 1
        mmm='Jan';
    case 2
        mmm='Feb';
    case 3
        mmm='Mar';
    case 4
        mmm='Apr';
    case 5 
        mmm='May';
    case 6 
        mmm='Jun';
    case 7
        mmm='Jul';
    case 8
        mmm='Aug';
    case 9
        mmm='Sep';
    case 10
        mmm='Oct';
    case 11
        mmm='Nov';
    case 0
        mmm='Dec';
end
end