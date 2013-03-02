function testCSFit()

    np = 100;
    xbnd = [-pi, pi];    
    x = rand(np, 1)*(xbnd(2) - xbnd(1)) + xbnd(1);
    y = sin(x) + randn(length(x), 1)*1e-1;
    
    n2fit = 25;
    dataIndices = randsample(1:length(x), n2fit);
    
    %Smoothing cubic spline, 2 degrees of freedom
    sparams = containers.Map();
    sparams('dof') = 2;
    cs2 = CSFit(x(dataIndices), y(dataIndices), sparams);
    
    %Smoothing cubic spline, 4 degrees of freedom
    sparams = containers.Map();
    sparams('dof') = 4;
    cs3 = CSFit(x(dataIndices), y(dataIndices), sparams);
        
    figure(); hold on;
    plot(x, y, 'ko');    
    plot(x, cs2.eval(x), 'bo');
    plot(x, cs3.eval(x), 'ro');
    legend('Original Data', '2 DoF', '4 DoF');
    
    fprintf('Smoothing (DoF=2) R^2=%.4f\n', cs2.R2);
    fprintf('Smoothing (DoF=4) R^2=%.4f\n', cs3.R2);
end
