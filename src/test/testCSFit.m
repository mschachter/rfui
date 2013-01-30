function testCSFit()

    np = 100;
    xbnd = [-pi, pi];    
    x = rand(np, 1)*(xbnd(2) - xbnd(1)) + xbnd(1);
    y = sin(x) + randn(length(x), 1)*1e-1;
    
    n2fit = 25;
    dataIndices = randsample(1:length(x), n2fit);
    
    %Normal cubic spline
    cs1 = CSFit(x(dataIndices), y(dataIndices), 'natural');
    
    %Smoothing cubic spline, p=0.5
    sparams = containers.Map();
    sparams('p') = 0.5;
    cs2 = CSFit(x(dataIndices), y(dataIndices), 'smoothing', sparams);
    
    %Smoothing cubic spline, p=0.0
    sparams('p') = 0.0;
    cs3 = CSFit(x(dataIndices), y(dataIndices), 'smoothing', sparams);
        
    figure(); hold on;
    plot(x, y, 'ko');
    plot(x, cs1.eval(x), 'ro');
    plot(x, cs2.eval(x), 'bo');
    plot(x, cs3.eval(x), 'co');
    legend('Original Data', 'Normal', 'Smoothing (p=0.5)', 'Smoothing (p=0.0)');
    
    fprintf('Normal R^2=%.4f\n', cs1.R2);    
    fprintf('Smoothing (p=0.5) R^2=%.4f\n', cs2.R2);
    fprintf('Smoothing (p=0.0) R^2=%.4f\n', cs3.R2);
end
