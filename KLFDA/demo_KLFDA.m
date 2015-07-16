% test_KLFDA.m
%
% (c) Masashi Sugiyama, Department of Compter Science, Tokyo Institute of Technology, Japan.
%     sugi@cs.titech.ac.jp,     http://sugiyama-www.cs.titech.ac.jp/~sugi/software/LFDA/

clear all;

rand('state',0);
randn('state',0);

%%%%%%%%%%%%%%%%%%%%%% Generating data
n1a=100;
n1b=100;
n2=100;
X1a=[randn(2,n1a).*repmat([1;2],[1 n1a])+repmat([-6;0],[1 n1a])];
X1b=[randn(2,n1b).*repmat([1;2],[1 n1b])+repmat([ 6;0],[1 n1b])];
X2= [randn(2,n2 ).*repmat([1;2],[1 n2 ])+repmat([ 0;0],[1 n2 ])];
X=[X1a X1b X2];
Y=[ones(n1a+n1b,1);2*ones(n2,1)];

%%%%%%%%%%%%%%%%%%%%%% Computing LFDA solution

%Gaussian kernel
K1=Kmatrix_Gauss(X,1);
[T1,Z1]=KLFDA(K1,Y,1);

% linear kernel
K2=X'*X;
[T2,Z2]=KLFDA(K2,Y,1);

%%%%%%%%%%%%%%%%%%%%%% Displaying original 2D data
figure(1)
clf
hold on

set(gca,'FontName','Helvetica')
set(gca,'FontSize',12)
h=plot(X(1,Y==1),X(2,Y==1),'bo');
h=plot(X(1,Y==2),X(2,Y==2),'rx');
axis equal
axis([-10 10 -10 10])
title('Original 2D data')

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 12 12]);
print -depsc original_data

%%%%%%%%%%%%%%%%%%%%%% Displaying projected data (Gauss kernel)
figure(2)
clf

subplot(2,1,1)
hold on
set(gca,'FontName','Helvetica')
set(gca,'FontSize',12)
hist(Z1(Y==1),linspace(min(Z1),max(Z1),30));
h=get(gca,'Children');
set(h,'FaceColor','b')
axis([min(Z1) max(Z1) 0 inf])
title('1D projection by KLFDA (Gauss kernel)')

subplot(2,1,2)
hold on
set(gca,'FontName','Helvetica')
set(gca,'FontSize',12)
hist(Z1(Y==2),linspace(min(Z1),max(Z1),30));
h=get(gca,'Children');
set(h,'FaceColor','r')
axis([min(Z1) max(Z1) 0 inf])

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 12 12]);
print -depsc projected_data_KLFDA_Gauss

%%%%%%%%%%%%%%%%%%%%%% Displaying projected data (linear kernel)
figure(3)
clf

subplot(2,1,1)
hold on
set(gca,'FontName','Helvetica')
set(gca,'FontSize',12)
hist(Z2(Y==1),linspace(min(Z2),max(Z2),30));
h=get(gca,'Children');
set(h,'FaceColor','b')
axis([min(Z2) max(Z2) 0 inf])
title('1D projection by KLFDA (linear kernel)')

subplot(2,1,2)
hold on
set(gca,'FontName','Helvetica')
set(gca,'FontSize',12)
hist(Z2(Y==2),linspace(min(Z2),max(Z2),30));
h=get(gca,'Children');
set(h,'FaceColor','r')
axis([min(Z2) max(Z2) 0 inf])

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[0 0 12 12]);
print -depsc projected_data_KLFDA_linear

