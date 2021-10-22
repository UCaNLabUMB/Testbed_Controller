figure(1)
x = [Downlink; Downlink107; Downlink112];
g = [ones(size(Downlink)); 2*ones(size(Downlink107)); 3*ones(size(Downlink112))];
boxplot(x, g)
xlabel("Scenario")
ylabel("Throughput (Mb/s)")
title("Downlink")

figure(2)
x = [Uplink; Uplink107; Uplink112];
g = [ones(size(Uplink)); 2*ones(size(Uplink107)); 3*ones(size(Uplink112))];
boxplot(x, g)
xlabel("Scenario")
ylabel("Throughput (Mb/s)")
title("Uplink")


