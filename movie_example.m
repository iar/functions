aviobj=avifile('movie_name.avi');

%insert figure code here in for loop

    pause(1);
    F=getframe(gcf);
    aviobj=addframe(aviobj,F);

%end for loop

aviobj=close(aviobj);


!mencoder mf://*.png -mf w=400:h=400 -ovc lavc -lavcopts vcodec=xvid -of avi -o output.avi