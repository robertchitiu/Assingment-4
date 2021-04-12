

%%  Part 1

%Using assingment 3 to calculate the value of R3 gave the value of 
%R3=55.4247. It is pretty clear the the circuit used is essentally acting
%as an amplifier, increasing the volate at the output. 
[C,G] = MNPA()
C 
G
%% Part 2
%When the capacitor is added it makes the a certain amount of time before
%the output voltage reaches its desired voltage. So when the capacitor cn
%is incresed this means that it will take long for the output voltage to
%stablize at the desired output voltage. If cn is decreased then it will
%take less time for this to happen. 
[C,G] = Noise()

%% Different capacitor values
Cn1()
%% Different capacitor values
Cn2()
%% Different time steps
time1()
%% Different time steps
time2()

%% Part 3
% So now what is happening is the there is no longer a linery input being
% added. This does complicate things. When looking that the formula
% C*dv/dt+GV=F this will not be suffient to simulate this circuit. So what
% need to be done is by using this new formula C*dv/dt+GV + B(V) = F. This
% new formula has the input B(V) which accounts and deals with the
% non-linear term. So the same procces would take place in order to find
% the C , G , F matrix. But in our new formulas we must take in account the
% new non-linear term, by creating a B(V) matrix that is arranged in the
% order so that it fit properly in our simulation. Since this has been
% esstablished, going back into the code to modify all our operation for
% when V is being calulated a the output and added the B(V) term into the
% calculation. This would now funtion with the new non-linear term and
% produce a result incorporating the non-linear term. 
