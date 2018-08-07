%===============================================
% Script: Vector Analyzer Network Data Acquisition - 4 Ports
% Purpose: Gathers the transmission coefficient and reflection 
%          coefficient of a 4-Port system
%===============================================

delete(instrfindall);
clear;
clc;
newobjs = instrfind;
% Define where the graphs will be saved
fp_name = 'C:\Tanner\GPIB\s parameter measurements\Round\4port\COLT_L001_test';
n=1;

warning('off','MATLAB:serial:fread:unsuccessfulRead');

% Specify the virtual serial port created by USB driver.
sport = serial('COM8');

% The controller terminates internal query responses with CR and
% LF. Responses from the instrument are passed through as is. (See Prologix
% Controller Manual)
sport.Terminator = 'LF'; % terminator from HP8712 is LF

sport.Timeout = 1;
sport.InputBufferSize = 50000;

% Open virtual serial port
fopen(sport);

% Send Prologix Controller query version command
fprintf(sport, '++ver');

% Read and display response
ver = fgets(sport);
fprintf("PROLIGIX Controller version %s\n", ver);

fprintf("Press ENTER to continue.");
pause;

% Configure as Controller (++mode 1), instrument address 5, and with
% read-after-write (++auto 1) enabled
fprintf(sport, '++mode 1');
fprintf(sport, '++addr 16');
fprintf(sport, '++auto 1');

% Send id query command to HP54201A
fprintf(sport, '*idn?');
idn = fgets(sport);
fprintf("Talking to : %s\n", idn);

while n <= 4
% ================== S21 Parameter Test =====================
    fprintf("Configuring for Broadband Passive Transmission measurement.\n");
    pause(1);
    fprintf(sport, "conf 'bban:tran';calc:form mlog;*wai");

    fprintf("Pausing for instrument data acquisition.\n");
    for i=5:-1:1
        fprintf("%d ",i);
        pause(1);
    end

    fprintf("\r\nRequesting channel 1 data from HP8712B\n");
    sport.Timeout = 60;
    fprintf(sport,"TRAC? CH1FDATA");
    dat = fgets(sport);
    sport.Timeout = 1;
    s21 = str2num(dat);
    fprintf("Getting frequency data from HP8712B\n");
    fprintf(sport,"sense:frequency:start?");
    start = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:frequency:stop?");
    stop = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:sweep:points?");
    points = str2num(fgets(sport));
    f = linspace(start, stop, points);

    fprintf("Generating S21 plot\n");
    a = plot(f,s21);
    title(strcat("S21 Parameter (Round/T4/CFF_L004) Format ",num2str(n)));
    xlabel("Frequency of Continuous wave (MHz)");
    ylabel(" Insertion Loss (dB)");
    grid on;
    
    saveas(gcf,fullfile(fp_name,strcat('Round_S21_Format_',num2str(n))),'png');

    fprintf("Press ENTER to continue.");
    pause;

    clear dat;
% ==================== Transmission Impedance Test =====================
    fprintf("\nConfiguring for Broadband Passive Transmission Impedance.\n");
    pause(1);
    fprintf(sport, "conf 'bban:tran';calc:form mimp;*wai");

    fprintf("Pausing for instrument data acquisition.\n");
    for i=5:-1:1
        fprintf("%d ",i);
        pause(1);
    end


    fprintf("\r\nRequesting channel 1 data from HP8712B\n");
    sport.Timeout = 60;
    fprintf(sport,"TRAC? CH1FDATA");
    dat = fgets(sport);
    sport.Timeout = 1;
    s21 = str2num(dat);
    fprintf("Getting frequency data from HP8712B\n");
    fprintf(sport,"sense:frequency:start?");
    start = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:frequency:stop?");
    stop = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:sweep:points?");
    points = str2num(fgets(sport));
    f = linspace(start, stop, points);

    fprintf("Generating transmission impedance plot\n");
    a = plot(f,s21);
    title(strcat("Transmission Impedance(Round/T4/CFF_L004) Format: ",num2str(n)));
    xlabel("Frequency of Continuous Wave (MHz)");
    ylabel("Impedance (Ohms)");
    grid on;

    saveas(gcf,fullfile(fp_name,strcat('Round_Transmission_MImp_Format_',num2str(n))),'png');

    fprintf("Press ENTER to continue.");
    pause;

    clear dat;

% ==================== S11 Parameter Test ========================
    fprintf("\nConfiguring for Broadband Passive Reflection measurement.\n");
    pause(1);
    fprintf(sport, "conf 'bban:refl';calc:form mlog;*wai" );

    fprintf("Pausing for instrument data acquisition.\n");
    for i=5:-1:1
        fprintf("%d ", i);
        pause(1);
    end;

    clear dat;
    fprintf("\nRequesting channel 1 data from HP8712B\n");
    sport.Timeout = 60;
    fprintf(sport,"TRAC? CH1FDATA");
    dat = fgets(sport);
    sport.Timeout = 1;
    s11 = str2num(dat);
    fprintf("Getting frequency data from HP8712B\n");
    fprintf(sport,"sense:frequency:start?");
    start = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:frequency:stop?");
    stop = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:sweep:points?");
    points = str2num(fgets(sport));
    f = linspace(start, stop, points);

    fprintf("Generating S11 plot\n");
    plot(f,s11);
    title(strcat("S11 Parameter(Round/T4/CFF_L004)Format: ",num2str(n)));
    xlabel("Frequency MHz");
    ylabel("Return Loss (dB)");
    grid on;

    saveas(gcf,fullfile(fp_name,strcat('Round_S11_Format_',num2str(n))),'png');
    
    fprintf("Press ENTER to continue.\n");
    pause;
    
    clear dat;
 
% ================= Reflection Impedance Test ==================  
    fprintf("\nConfiguring for Broadband Passive Reflection Impedance.\n");
    pause(1);
    fprintf(sport, "conf 'bban:refl';calc:form mimp;*wai");

    fprintf("Pausing for instrument data acquisition.\n");
    for i=5:-1:1
        fprintf("%d ",i);
        pause(1);
    end


    fprintf("\r\nRequesting channel 1 data from HP8712B\n");
    sport.Timeout = 60;
    fprintf(sport,"TRAC? CH1FDATA");
    dat = fgets(sport);
    sport.Timeout = 1;
    s21 = str2num(dat);
    fprintf("Getting frequency data from HP8712B\n");
    fprintf(sport,"sense:frequency:start?");
    start = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:frequency:stop?");
    stop = str2num(fgets(sport))/1e6;
    fprintf(sport,"sense:sweep:points?");
    points = str2num(fgets(sport));
    f = linspace(start, stop, points);

    fprintf("Generating reflection impedance plot\n");
    a = plot(f,s21);
    title(strcat("Reflection Impedance (Round/T4/CFF_L004) Format: ",num2str(n)));
    xlabel("Frequency of Continuous Wave (MHz)");
    ylabel("Impedance (Ohms)");
    grid on;

    saveas(gcf,fullfile(fp_name,strcat('Round_Reflection_MImp_Format_',num2str(n))),'png');

    % You will be prompted to configure the device under test to the next
    % format until the last format is reached.
    n = n+1;
    if n <= 4
    fprintf(strcat("\r\n **** Pause and configure device under test to format ",num2str(n),'\n'));
    fprintf("Press ENTER to continue.\n");
    pause;
    end
end



fclose('all');
delete(sport);
