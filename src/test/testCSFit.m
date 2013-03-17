function testCSFit()

    np = 100;
    xbnd = [-pi, pi];    
    x = rand(np, 1)*(xbnd(2) - xbnd(1)) + xbnd(1);
    x = sort(x);
    y = sin(x) + randn(length(x), 1)*1e-1;
    
    
    n2fit = 25;
    dataIndices = randsample(1:length(x), n2fit);
    dataIndices = sort(dataIndices);
    
    %Smoothing cubic spline, 2 degrees of freedom
    cs2 = CSFit(x(dataIndices), y(dataIndices), 1);
    
    %Smoothing cubic spline, 4 degrees of freedom
    cs3 = CSFit(x(dataIndices), y(dataIndices), 4);
    
    %Smoothing cubic spline, 4 degrees of freedom and only 3 knots (2
    %spline pieces
    cs4 = CSFit(x(dataIndices), y(dataIndices), 4, 3);
        
    figure(); hold on;
    plot(x, y, 'ko');    
    plot(x, cs2.eval(x), 'b-'); %eval can also take no arguments to evaluate at the original points
    plot(x, cs3.eval(x), 'r--');
    plot(x, cs4.eval(x), 'g-.');
    legend('Original Data', '2 DoF', '4 DoF', '4 DoF, 3 knots');
    hold off;
    
    fprintf('Smoothing (DoF=2) R^2=%.4f\n', cs2.R2);
    fprintf('Smoothing (DoF=4) R^2=%.4f\n', cs3.R2);
    fprintf('Smoothing (DoF=4) R^2=%.4f\n', cs4.R2);
end
