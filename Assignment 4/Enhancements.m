function [] = Enhancements(Ex,Ey)
clf; %used to clear pre exisiting graph

numpart=10000; %number of electrons 
color=['k' 'b' 'g' 'r' 'm'];

x0 = (2).*rand(1,numpart)./10^7 ;%starting points x ranged 
y0 = ((0.65-0.35).*rand(1,numpart) + 0.35)./10^7;%starting points y ranged
watchers = randi(numpart, 5,1); %number of electrons being watched

Kb=1.38 * 10^ -23;%boltzman contant
T=300;%tempurature in K
m=0.26*9.1 * 10^ -31;%mass of electron
dt=0.05*10^-13;%change in time 
q=1.6*10^-19;

%velocities of the particle
Vth=sqrt(3*Kb*T/m);%thermal velocity
Vran=Vth*randn(1,numpart); %random velocity being assigned 
o=rand(1,numpart)*2*pi; %angle of movement
Vx=Vran.*sin(o); %Velocity in the x
Vy=Vran.*cos(o); %Velocity in the y

To=0.2*10^-12; %mean time between colision
Pscat=(1 - exp(-dt/To)); %probability of scattering
random=rand(1,numpart); %random value for each electron

%tempurature plot
tempa=0;
temp = (Vran.^2 * m)/(3*Kb);
for s=1:numpart 
   tempa = tempa + temp(s);
end
tempave= tempa/numpart;

plot(Box(0.5*10^-7,1*10^-7,0,0.35*10^-7))%Box 1 being plotted 
plot(Box(0.5*10^-7,1*10^-7,0.65*10^-7,1*10^-7))%Box 2 being plotted
xlim([0, 150*10^-9]);
ylim([0, 100*10^-9]);
hold on

Current_neg = 0;
Current_pos = 0;
time = 0;

nx=100;
ny=150;
cond=11.68*8.54*10^-12; %10^-2;
b=0.1;
Rave=0;


[cMap] = Conductivity_Map (50,100,35,65,nx,ny,cond);
%Creating g matix
[Volt,G,B] = G_Matrix(nx,ny,cMap,b);
%E-Field and Current Flow 
[Ex,Ey,Vmap] = E_field_J (nx,ny,cMap,Volt);

for i=2:200
   
    x1=x0+Vx*dt; %new position
    y1=y0+Vy*dt; %new position   
    
    Current_neg =  length(x1(x1<0));
    Current_pos =  length(x1(x1>1.4*10^-7));
    Vave = sum(Vx)/length(Vx);
    Flow = Vave * (Current_pos - Current_neg )*10^15*q*100*10^-7;
    R=b/Flow;
    
    Rave= (Rave+R)/2;
    
    if rem(i,2)==0
    b=b+0.1;
    [cMap] = Conductivity_Map (50,100,35,65,nx,ny,cond);
    [Volt,G,B] = G_Matrix(nx,ny,cMap,b);
    [Ex,Ey,Vmap] = E_field_J (nx,ny,cMap,Volt);
    
    figure(2)
    plot(b,Flow,'o')
    hold on
    end

    
    %Making the electron scatter according to the scattering probalility
    Vran(Pscat>random)=Vth*rand();
    o(Pscat>random)=rand()*2*pi;
    Vx(Pscat>random) = Vran(Pscat>random).*sin(o(Pscat>random));
    Vy(Pscat>random) = Vran(Pscat>random).*cos(o(Pscat>random));
    random= rand(1,numpart);
   
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
    
    %Box1 condition top
    x1(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)=(0.35*10^-7-y0(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)).*(x1(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)-x0(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0))./(y1(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)-y0(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)) + x0(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0);
    y1(y0>0.35*10^-7 & y1>0.3*10^-7 & y1<=0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)=0.35*10^-7;
    Vy(y1==0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0)=-1*Vy(y1==0.35*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy<0);
    
    %Box1 condition left side
    y1(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0) = (y0(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0).*(x1(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0)-0.5*10^-7)+y1(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0).*(0.5*10^-7-x0(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0)))./(x1(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0)-x0(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0));
    x1(x1>=0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0)=0.5*10^-7;
    Vx(x1==0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0)=-1*Vx(x1==0.5*10^-7 & x1<0.7*10^-7 & y1<0.35*10^-7 & Vx>0); %left side
    
    %Box1 condition right side
    y1(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0)=(y0(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0).*(x1(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0)-1*10^-7)+y1(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0).*(1*10^-7-x0(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0)))./(x1(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0)-x0(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0));
    x1(x1<=1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0)=1*10^-7;
    Vx(x1==1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0)=-1*Vx(x1==1*10^-7 & x1>0.8*10^-7 & y1<0.35*10^-7 & Vx<0);
    
    %Box 2 condition top
    x1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)=(0.65*10^-7-y0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)).*(x1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)-x0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0))./(y1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)-y0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)) + x0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0);
    %x1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)=(x1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0).*(y0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)-0.65*10^-7)-x0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0).*(y1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)+0.65*10^-7))./(y0(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)-y1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0));
    %x1=(x0.*(0.65*10^-7-y1)+x1.*(y0-0.65*10^-7))./(y0-y1)
    y1(y0<0.65*10^-7 & y1<0.7*10^-7 & y1>=0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)=0.65*10^-7;
    Vy(y1==0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0)=-1*Vy(y1==0.65*10^-7 & x1>0.5*10^-7 & x1<1*10^-7 & Vy>0);
    
    %Box 2 condition left side
    y1(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0) = (y0(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0).*(x1(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0)-0.5*10^-7)+y1(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0).*(0.5*10^-7-x0(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0)))./(x1(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0)-x0(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0));
    x1(x1>=0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0) = 0.5*10^-7;
    Vx(x1==0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0) = -1*Vx(x1==0.5*10^-7 & x1<=0.7*10^-7 & y1>0.65*10^-7 & Vx>0); %left side
 
    %Box 2 condition right side
    y1(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0)=(y0(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0).*(x1(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0)-1*10^-7)+y1(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0).*(1*10^-7-x0(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0)))./(x1(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0)-x0(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0));
    x1(x1<=1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0)=1*10^-7;
    Vx(x1==1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0)=-1*Vx(x1==1*10^-7 & x1>0.8*10^-7 & y1>0.65*10^-7 & Vx<0);
 
    %plotting the electrons being watched
    for j=1:5
        figure (1)
        plot([x0(watchers(j)) x1(watchers(j))], [y0(watchers(j)) y1(watchers(j))],color(j),'linewidth',1)
        hold on
    end
  
    %Left side condition
    x1(x1==150*10^-9 & Vx>0)=0;
    %Right side condition
    x1(x1==0 & Vx<0)=150*10^-9;
 
    xround = round(x1.*10^9);
    yround = round(y1.*10^9);
    
    for w=1:numpart
        if xround(w)>0 && xround(w)<=150 
            if yround(w)>0 && yround(w)<=100
            Vx(w)=Vx(w)+ Ex(yround(w),xround(w))* 10^8 * q * dt/m;
            Vy(w)=Vy(w)+ Ey(yround(w),xround(w)) * 10^8*q*dt/m;
            
            end
        end
    end
    x0=x1;y0=y1;
    pause(0.00000001);
end

Rave=Rave
end
