function [] = Collision_MFP() 

numpart=5000; 
color=['k' 'b' 'g' 'r' 'm'];
x0=1.5*rand(1,numpart)/10^7; %starting points
y0=1*rand(1,numpart)/10^7;

watchers = randi(numpart, 5,1);

Kb=1.38 * 10^ -23;%boltzman contant
T=300;%tempurature in K
m=0.26 * 9.1 * 10^ -31;%mass of electron
dt=0.1*10^-13; 
q=1.6*10^-19;
time=0;

%velocities of the particle
Vth=sqrt(3*Kb*T/m);%thermal velocity
Vran=Vth*randn(1,numpart);
o=rand(1,numpart)*2*pi; %angle of movement
Vx=Vran.*sin(o);
Vy=Vran.*cos(o);

%Mean free path
To=0.2*10^-12; %mean time between colision
Pscat=(1 - exp(-dt/To)); %probability of scattering

%tempurature plot
%{
tempa=0;
temp = (Vran.^2 * m)/(3*Kb);
for a=1:numpart 
   tempa = tempa + temp(a);
end
tempave= tempa/numpart;
To=zeros(1,numpart);
%}
    
for i=2:300
    x1=x0+Vx*dt;
    y1=y0+Vy*dt;
    
    Current_neg =  length(x1(x1<0));
    Current_pos =  length(x1(x1>1.4*10^-7));
    Vave = sum(Vx)/length(Vx);
    time = time + dt;
    Flow = Vave * (Current_pos - Current_neg )*10^15*q*100*10^-7;
    
    figure (2)
    plot(time,Flow,'o')
    xlabel('Time')
    ylabel('Current')
    hold on
    
    random = rand(1,numpart);
    Vran(Pscat>random)=Vth*randn();
    o(Pscat>random)=rand()*2*pi;
    Vx(Pscat>random) = Vran(Pscat>random).*sin(o(Pscat>random));
    Vy(Pscat>random) = Vran(Pscat>random).*cos(o(Pscat>random));
    To(Pscat>random) = 0;
    
    %top bondary condition
    Vy(y1>=100*10^-9)=-1*Vy(y1>=100*10^-9);
    x1(y1>=100*10^-9)=(100*10^-9-y0(y1>=100*10^-9)).*(x1(y1>=100*10^-9)-x0(y1>=100*10^-9))./(y1(y1>=100*10^-9)-y0(y1>=100*10^-9)) + x0(y1>=100*10^-9);
    y1(y1>=100*10^-9)=100*10^-9;
    %bottom Bondary condition
    Vy(y1<=0)=-1*Vy(y1<=0);
    x1(y1<=0)=(0-y0(y1<=0)).*(x1(y1<=0)-x0(y1<=0))./(y1(y1<=0)-y0(y1<=0)) + x0(y1<=0);
    y1(y1<=0)=0;
    %left bondary condition
    y1(x1<0)=(y1(x1<0)-y0(x1<0))./(x1(x1<0)-x0(x1<0)).*(0-x0(x1<0))+y0(x1<0);
    x1(x1<0)=0;
    %right bondary condition
    y1(x1>150*10^-9)=(y1(x1>150*10^-9)-y0(x1>150*10^-9))./(x1(x1>150*10^-9)-x0(x1>150*10^-9)).*(150*10^-9-x0(x1>150*10^-9))+y0(x1>150*10^-9);
    x1(x1>150*10^-9)=150*10^-9; 
    
    for j=1:5
        figure(1)
        plot([x0(watchers(j)) x1(watchers(j))], [y0(watchers(j)) y1(watchers(j))],color(j),'linewidth',1)
        xlim([0, 150*10^-9]);
        ylim([0, 100*10^-9]);
        hold on
    end
    
    
   %Left side condition
    x1(x1==150*10^-9 & Vx>0)=0;
    %Right side condition
    x1(x1==0 & Vx<0)=150*10^-9;
    
    xround = round(x1.*10^9);
    yround = round(y1.*10^9);
    
    for w=1:numpart
        if xround(w)>0 && yround(w)>0
            Vx(w)=Vx(w)+ 6.6*10^5*q*dt/m;
        end
    end
    x0=x1;y0=y1;
    pause(0.1);
end
xy = hist3([x0;y0]');
figure(3)
surf(xy)
end


