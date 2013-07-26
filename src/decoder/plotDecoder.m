function plotDecoder(results)

    t = results.t;
    y = results.y;
    ypred = results.validationPred;
    vi = results.validationIndex;
    
    rf = squeeze(results.modelParams.w1);
    t_rf = results.modelParams.delays * results.desiredDt;
    [ncells,nlags] = size(rf);

    figure(); hold on;
    plot(t(vi), y(vi), 'k-', 'linewidth', 2);
    plot(t(vi), ypred, 'r-', 'linewidth', 2);
    legend('Real', 'Model');
    title(sprintf('Population Decoding of %s: CC=%0.2f', results.varName, results.validationCC));
    xlabel('Time (s)');
    ylabel(results.varName);
    axis('tight');

    figure(); hold on;
    imagesc(t_rf, 1:ncells, rf);    
    set(gca,'YDir','normal')
    ylabel('Cell #');
    xlabel('Lag (s)');
    title('Decoding Weights');
    axis('tight');