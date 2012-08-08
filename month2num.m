%Converts month string 'mmm' to month number
function [month]=month2num(mmm)
switch mmm
    case 'Jan'
    	month=1;
    case 'Feb'
    	month=2;
    case 'Mar'
    	month=3;
    case 'Apr'
    	month=4;
    case 'May'
    	month=5;
    case 'Jun'
    	month=6;
    case 'Jul'
    	month=7;
    case 'Aug'
    	month=8;
    case 'Sep'
    	month=9;
    case 'Oct'
    	month=10;
    case 'Nov'
    	month=11;
    case 'Dec'
        month=12;

end
end