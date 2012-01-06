function simulateModel()

settings = tfSettings();

load([settings.dataDir,'DynModels-120106-0959.mat']);

noOdorModel = fitModels{2};
odorModel = fitModels{3};

spins = [720 540 360 180 90 -90 -180 -360 -540 -720];
angles = 3.75:3.75:360;

figure(gcf);
for spinN = 1:10
    subplot(10,2,sfa(10,2,spinN,1)); hold on;
    xlim([0 360]);
    ylim([-500 500]);
    subplot(10,2,sfa(10,2,spinN,2)); hold on;
    plot(angles,noOdorModel(angles,ones(1,96).*spins(spinN)),'b');
    plot(angles,odorModel(angles,ones(1,96).*spins(spinN)),'r');
    xlim([0 360]);
    ylim([-500 500]);
end

