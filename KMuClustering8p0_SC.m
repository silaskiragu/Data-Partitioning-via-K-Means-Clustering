%% Created By: Sylvia Chin
%% Date: 07/03/17
%% Objectve: To Sort Unlabeled Pseudorandom Generated Data via K-Means
%% Clustering Method

%% Clear Memory & Command Window
clc
clear all
close all

%% 1) Generate Pseudorandom x-y coordinate values in preparation to plot random data.
%% Prototype:Automate the rand values for troubleshooting
x_mu=0;
y_mu=0;
x_iso=5;
y_iso=5;
cluster_pts=50;

%% Generate R.V. Data Points from Multi-variate Gaussian Distributions: 600x2 matrix => [X Y]
var=[10 0; 0 10];                                           % [X variance X-Rotation ; Y-Rotation Y Variance]
s1=mvnrnd([x_mu+x_iso y_mu+y_iso],var,cluster_pts);     
s2=mvnrnd([x_mu-x_iso y_mu+y_iso],var,cluster_pts);
s3=mvnrnd([x_mu+x_iso y_mu-y_iso],var,cluster_pts);
s4=mvnrnd([x_mu+x_iso y_mu+y_iso],var,cluster_pts);     
s5=mvnrnd([x_mu-x_iso y_mu+y_iso],var,cluster_pts);
s6=mvnrnd([x_mu+x_iso y_mu-y_iso],var,cluster_pts);
data_xy=[s1;s2;s3;s4;s5;s6];                                % Vector array of all random multivariant pts

%% 2) Generate Pseudorandom x-y coordinate values in preparation to plot centroids:
%% Generate R.V. Centroid Points from Multi-variate Gaussian Distribution: 6x2 matrix => [X Y]
k=6;                                                        % # of clusters = # of centroids
dev=0;                                                                                              
var2=[10 1;1 10];                                                 
sc=mvnrnd([x_mu+x_iso+dev y_mu+y_iso+dev],var2,cluster_pts);% k # of Centroids' x-y locations will be randomly extracted from 100 Gaussian x-y coordinates
centroid_xy=sc(ceil(rand(k,1)*length(sc)),:);               % k rows-by-2 col Centroid x-y locations will be assigned to nearest fraction of  
                                                            % "cent_pts" total # of rows
                                                            
%% 3a) Plot & Assign Initial Colors to Random Data:
subplot(211);

xd=data_xy(:,1);                                            % Data Point's X-Coordinates                                            
yd=data_xy(:,2);                                            % Data Point's Y-Coordinates 

C=['r','g','c','b','m','k'];                                % Color vector for distinguishing random gaussian sets 
plot(xd(1:cluster_pts),yd(1:cluster_pts),'.','Color',C(length(C)),'Markersize',10);
hold on

for a=1:k-1
    plot(xd(a*cluster_pts:(a+1)*cluster_pts),yd(a*cluster_pts:(a+1)*cluster_pts),'.','Color',C(a),'Markersize',10);
    hold on
end

title('Initial State: Multi-Variant Gaussian Pseudorandom Unlabeled Data','Fontsize',12);
xlabel('X Location: based on Gaussian PDF of X');
ylabel({'Y Location: Based on' 'Gaussian PDF of Y'});

%% 3b) Plot Initial Location of Centroids: 

centroid_x=centroid_xy(:,1);
centroid_y=centroid_xy(:,2);

for b=1:k
plot(centroid_x, centroid_y,'x','Color',C(length(k)),'MarkerSize',10,'LineWidth',2);
text(centroid_x(b,1), centroid_xy(b,2),num2str(b),'Color',[0 0 0],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left')       
hold on;
end

%% 4) State # of iterations for Centroids to be re-assigned a k-mean value:
iter=50;
%% 5) Determine Euclidean Distances b/w Each Data & All Centroids:
table=zeros(length(data_xy),k+2);                           % Allocating placeholders for a 600 x K+2 matrix
table_kmu=zeros(k,iter);                                    % Allocating placeholders for a k x iter matrix

for update_num=1:iter                                       % Number of updates on centroids X-Y location
    
    for i=1:length(data_xy)
        
        for j=1:k
        eucl_dist(i,j)=norm(data_xy(i,:)-centroid_xy(j,:)); % Per loop, (Eucli_Dist Matrix) 1x2 = (Data Matrix) 1x2 - (Centroid Matrix) 1x2
        table(i,j)=eucl_dist(i,j);                          % Allocating Distances b/w centroids relative to each data point (600 x k) w/in overall data table
        end
        [min_dist cluster_index]=min(table(i,1:k));         % Search for nearest centroid index to data point & coresponding distance b/w centroids relative to each data point
        table(i,k+1)=min_dist;                              % Allocating miniumum distance to column k+1
        table(i,k+2)=cluster_index;                         % Allocating centroid index (aka assigned cluster #) to column k+1
        
    end
    
 %% 6) Determine New X-Y Coordinates for Each Centroid Based on Averages of Each Data Point's X-Y Coordinates Per Their Assigned Clusters:
 subplot(212);
    for j=1:k
        assign=(table(:,k+2)==j);                       % For all rows that are true
        kmu(j,:)=mean(data_xy(assign,:));               % For all data points assigned to same cluster # j, avg. out their X-Y coords. & assign this avg. as the cluster's centroids NEW X-Y coords. 
        centroid_xy(j,:)=kmu(j,:);                      % THE NEW CENTROID COORDINATE: For each iteration, the centroid will be updated with new x-y coordinate based on distance b/w each cluster's new avg. of data_xy & data_xy pts 
        plot(centroid_xy(j,1), centroid_xy(j,2),'x','Color',C(length(k)),'MarkerSize',10,'LineWidth',2);
        text(centroid_xy(j,1), centroid_xy(j,2),num2str(j),'Color',[0 0 0],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left')                    
        hold on
    end

        
    for j=1:k
        sort_data_xy=data_xy(table(:,k+2)==j,:);        % Prepare to plot all pts to be sort out to their assigned cluster by color   
        data_newx=sort_data_xy(:,1);                
        data_newy=sort_data_xy(:,2);
        plot(data_newx, data_newy,'.','Color',C(j));
        hold on
    end
    title(['K-Mu Clustering Data (Iteration = ',num2str(update_num),')']);
    xlabel('X Location: Based on Gaussian PDF of X');
    ylabel({'Y Location: Based on' 'Gaussian PDF of Y'});
    pause(0.1)
    hold off

    
end

