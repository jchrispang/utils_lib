function HillOutput = Hill(x,y,noParam,maximum,slope,halfActiv,intercept);
    % Fits data (x and y) using a Hill function. The Hill function is 
    % either a 3- or 4-parameter Hill function. The 3-parameter Hill 
    % function is of the form: 
    
    %   (maximum*xData^slope)  /  (halfActiv^slope + xData^slope) 
    
    % where maximum is the maximum point of the Hill function, slope is the
    % Hill function's slope and halfActiv is the half activation point of 
    % the Hill function.
    
    % The 4-parameter Hill function is similar but now includes the
    % intercept, and is of the form:
    
    % intercept + ((maximum*xData^slope) / (halfActiv^slope + xData^slope))
    
    % The function requires some initial guesses. Then, using the method of
    % least squares fitting, the function finds the Hill coefficients that
    % best describe the data.
    
    % Function inputs % 
    
    %   1) x: your x-axis data
    %   2) y: your y-axis data
    %   3) noParam: the number of parameters for your Hill function. Input
    %       either 3 for a 3-parameter Hill function or 4 for a 
    %       4-parameter Hill function.
    %   4) maximum: initial guess for the maximum point of the Hill
    %       function.
    %   5) slope: initial guess for the slope of the Hill function. 
    %   6) halfActiv: initial guess for the half activation point of the 
    %        Hill function.
    %   7) intercept: initial guess for the point of intercept for the 
    %        Hill function. Leave empty is using a 3-parameter Hill 
    %        function.
    % Function outputs (HillOutput) %
        
    %   Output consists of two arrays. The first array consists of your 
    %   x-axis data (1st column or row) and the Hill function data
    %   (2nd column or row). The second array consists of the Hill function
    %   coefficients from the least squares fitting. In order, they are the
    %   intercept (if using 4-parameter Hill function), the slope, the  
    %   half-activation point and the maximal point of the Hill function.
    
    % Example %
    
    %   HillOutput = Hill(xData,yData,4,1,0.05,0.5,0);
    %       This gives a 4-paramter hill function taking 1 as the initial 
    %       guess for the maximal point of the Hill function, 0.05 as the
    %       initial guess for the slope, 0.5 as the initial guess for the
    %       half-activation point and 0 as the initial guess for the
    %       intercept.
    
    % Original: Timothy Olsen, 2018 (from Mathworks FileExchange)
    
    % creates the function for determining the Hill function's coefficients
    if noParam == 3;
        F = @(z,xdata) (z(1)*xdata.^z(2))  ./ (z(3).^z(2)+xdata.^z(2));
        z0 = [maximum,slope,halfActiv];
    elseif noParam == 4;
        F = @(z,xdata) z(1) +  ( (z(2)*xdata.^z(3)) ./ ...
            (z(4).^z(3)+xdata.^z(3)) ); 
        z0 = [intercept,maximum,slope,halfActiv];
    else
        error('Error: number of input parameters (noParam) not 3 or 4');
    end
    % finds the Hill function based on least squares fitting
    options = optimoptions('lsqcurvefit','Display','off');
    z = lsqcurvefit(F,z0,x,y,[],[],options); 
    
    % plots data x and y as scatter points and the Hill function as a line
%     figure
%     scatter(x,y,'k');
%     hold on
%     plot(x,F(z,x),'Linewidth',2,'Color','m');
%     title([num2str(noParam) ' parameter Hill function']);
%     xlabel('xData');
%     ylabel('yData');
    
    % Output %
    if noParam == 3;
        HillOutput = [{[x,F(z,x)]},{[z(3),z(4),z(2)]}];
    elseif noParam == 4;
        HillOutput = [{[x,F(z,x)]},{[z(1),z(3),z(4),z(2)]}];
    end