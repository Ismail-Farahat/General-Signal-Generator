%%%%%%%%%%%%%%%%%%%%%  SIMPLE GENERATOR  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear, clc, close all;
%%%%%%%%%%%%%%%%%%  TO GET THE PARAMETERS OF THE SIGNAL  %%%%%%%%%%%%%%%%%%%%%%%%%%

% START THE GENERATOR
fprintf("Please, Enter Signal Parameters: \n");
% To Get the Sampling Frequency from user.
SF = input("Sampling Frequency = ");
% To check if the given frequency value is valid or not
while SF<0
    SF = input("Please, enter a postive value for Sampling Frequency = ");
end
    
% To Get the Start Time from user.
start_time = input("Start Time = ");
% To Get the End Time from user.
end_time = input("End Time = ");

% To Get the Number of Break Points from user.
no_break_points = input("Number of Break Points = ");
% This WHILE LOOP is to check that the user enter only positive integer value
while floor(no_break_points) ~= no_break_points || no_break_points<0
    no_break_points = input("Please, Enter the integer value of Break Points Number correctly : ");
    % This WHILE LOOP is to check that the user enter only positive value
    while no_break_points<0
        no_break_points = input("Please, enter a postive value for Break Points Number = ");
    end
    continue
end

% To Get Break Points from user.
break_points = zeros(1,no_break_points);
for k = 1:no_break_points
    break_points(k) = input(['Break Point ' num2str(k) ': Enter the break point time = ']);
end

% To attach the start and end times to the break points
time_points = [start_time break_points end_time];
% To sort the time points
sort(time_points,'ascend');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FINISHED  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%  TO GET THE WHOLE SIGNAL  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_tot = [];       % Total Time for all the Regions
signal_tot = [];     % Total Signal for all the Regions
allowed_signals = ["dc", "ramp", "poly", "exp", "sin", "n"];
for m = 1:no_break_points+1
    % Time Samples for the current region
    region_start = time_points(1,m);
    region_end = time_points(1,m+1);
    t = linspace(region_start, region_end, abs(region_end - region_start)*SF);
    %
    fprintf("ALLOWED SIGNALS: dc, ramp, poly(polynomial), exp(exponential), sin(sinusodial), n(none) \n");
    region_signal = input(['Region ' num2str(m) ': Enter the signal type: '], 's');
    % This WHILE LOOP is to check that the user enter only Allowed Types of Signals
    while sum(contains(region_signal,allowed_signals)) ~= 1
        region_signal = input(['Region ' num2str(m) ': Please, Enter The Signal Type Correctly :'], 's');
        continue
    end
    % Getting The Parameters for every signal type.
    if region_signal == "dc"
        dc_amplitude = input("Enter DC Signal Amplitude = ");
        signal = dc_amplitude * ones(size(t));
    elseif region_signal == "ramp"
        ramp_slope = input("Enter Ramp Signal Slope = ");
        ramp_intercept = input("Enter Ramp Signal Intercept = ");
        signal = ramp_slope * t + ramp_intercept;
    elseif region_signal == "poly"
        no_poly_terms = input("Enter the number of terms of the polynomial signal(without intercept) = ");
        all_poly= 0;
        for i = 1:no_poly_terms
            poly_amplitude = input(['Enter Polynomial Term ' num2str(i) ' Amplitude = ']);
            poly_power = input(['Enter Polynomial Term ' num2str(i) ' Power = ']);
            poly = poly_amplitude * (t.^poly_power);
            all_poly = all_poly + poly;
        end
        poly_intercept = input("Enter Polynomial Signal Intercept = ");
        signal = all_poly + poly_intercept;
    elseif region_signal == "exp"
        exp_amplitude = input("Enter Exponential Signal Amplitude = ");
        exp_exponent = input("Enter Exponential Signal Exponent = ");
        signal = exp_amplitude * exp(exp_exponent * t);
    elseif region_signal == "sin"
        sin_amplitude = input("Enter Sinusodial Signal Amplitude = ");
        sin_freq = input("Enter Sinusodial Signal Frequency = ");
        sin_phase = input("Enter Sinusodial Signal Phase = ");
        signal = sin_amplitude * sin(2*pi*sin_freq * t + sin_phase);
    else
        signal = zeros(size(t));
    end
    %
    time_tot = [time_tot t];
    signal_tot = [signal_tot signal];
end

plot(time_tot, signal_tot);
grid on;
title("THE SIGNAL (the original)");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FINISHED  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% OPERATIONS ON THE SIGNAL  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = time_tot;
signal = signal_tot;
fprintf("ALLOWED OPERATIONS ON THE SIGNAL: \n");
fprintf("ts:time shift , as:amplitude scale , tr:time reversal , e:expand , c:compress , n:none \n");

operation = "y";
allowed_operations = ["ts", "as", "tr", "e", "c", "n"];
while operation == "y"
    operation = input("Enter the Required Operation : ",'s');
    % This WHILE LOOP is to check that the user enter only Allowed Operations.
    while sum(contains(operation,allowed_operations)) ~= 1
        operation = input("Please, Enter The Operation you want Correctly :", 's');
        continue
    end
    %
    if(operation == "ts")
        tShiftValue = input("enter the time shift value: ");
        t= t+tShiftValue ;
            if tShiftValue > 0
                signal = [signal zeross(1,tShiftValue)];
            else
                signal = [zeros(1,tShiftValue) signal];
            end
        elseif(operation == "as")
            ampScale = input("enter the amplification factor: ");
            signal = ampScale * signal ;
            elseif(operation == "tr")
                t = flip(-t);
                signal = flip(signal);
                elseif(operation == "e")
                    expandingFactor = input("enter the expand factor: ");
                    start_time = expandingFactor*start_time;
                    end_time=expandingFactor*end_time;
                    t= linspace(start_time,end_time,abs((end_time-start_time))*SF);
                    signal=resample(signal,expandingFactor,1);
                    elseif(operation == "c")
                        compressionFactor = input("enter the compression factor: ");
                        start_time = (1/compressionFactor)*start_time;
                        end_time=(1/compressionFactor)*end_time;
                        t= linspace(start_time,end_time,abs((end_time-start_time))*SF);
                        signal=resample(signal,1,compressionFactor);
                        elseif(operation == "n")
                            signal;
    else
        return;
    end
    % To check if the user want another operation on the signal
    operation = input("Do you want to do any other operation? (y/n): ", 's');
end

figure;
plot(t,signal);
grid on;
title("THE SIGNAL (after the reguired operations)");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FINISHED  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%  THE END OF THE CODE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%