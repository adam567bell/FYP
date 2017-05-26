function [Rm,Io,weight,diam,length]=plane_motor_model(Kv,max_watts)

length=6.5088*(max_watts)^0.2964;

%this was derived from motor database timelock1.xlsx
%maxpower=0.008277638*(length*diam)^1.513392202
%reversed poorly!!
diam=1/length*41.165101*(max_watts)^0.58308731;

%this was derived from motor database timelock1.xlsx
Rm=3285770636.3*(length*diam.^2*Kv)^-1.0197542*10^-3;

%this was derived from motor database timelock1.xlsx
Io=7.50785*10^-7*(length*diam.^2*Kv)^0.805527904;


weight=0.1976*(max_watts)+54.431;

end