%uplink = [Pi1Up.'; Pi2Up.'; Pi3Up.'; Pi4Up.'; Pi5Up.'; Pi6Up.'];
%up2 = [Pi7Up.'; Pi12Up.'];
%downlink = [Pi1Down.'; Pi2Down.'; Pi3Down.'; Pi4Down.'; Pi5Down.'; Pi6Down.'];
%down2 = [Pi7Down.'; Pi12Down.'];
downlink = [Pi1.'; Pi2.'; Pi3.'; Pi4.'; Pi5.'; Pi6.'];
%bar(uplink)
%xlabel("Pi Devices")
%ylabel("Average Throughput (Mb/s)")
%title("Uplink Throughput")

figure()
bar(downlink)
xlabel("Pi Devices")
ylabel("Average Throughput (Mb/s)")
title("Downlink Throughput")

