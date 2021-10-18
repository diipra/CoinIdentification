clear;
clc;
%% Mengambil Gambar
A = imread('koin-uts8.jpeg'); 
G = rgb2gray(A);
%% kalkulasi histogram untuk gambar
[counts,x] = imhist(G,16);
stem(x,counts);
%% Meghitung threshold global meggunakan histogram  
T = otsuthresh(counts);
%% membuat gambar binari mengunakan treshold dan menampilkan gambar
BW = imbinarize(G,T);
H = im2bw(G);
BW1= imfill (BW, 'holes');
figure
imshowpair(A,BW1,'montage') %Menampilkan Hasil
%% menyeleksi properti dari regionprops di gambar dan menyajikan dalam tabel
stats = regionprops('table',BW1,'Centroid',...
    'Area','MajorAxisLength','MinorAxisLength');
stats.MajorAxisLength(stats.MajorAxisLength<50)=0;
stats.MinorAxisLength(stats.MinorAxisLength<50)=0;
stats
%% menghitug nilai centroid dari koin 
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
%% melingkari koin 
hold on
viscircles(centers,radii);
hold off
%% penghitungan nilai awal koin
rp100=0;
rp200=0;
rp500=0;
rp1000=0;
%% looping pelabelan koin
iter = size(stats.Area);
for n = 1:iter
    % jika ukuran kecil tidak ditampilkan karena akan mengganggu proses
    % pemindaian gambar
    if (stats.Area(n) < 1000) nilai = ''; 
        
    % jika luas < 12200 maka dikenali sebagai koin 100
    elseif (stats.Area(n) < 12200) nilai = 100
            rp100=rp100+1;
  
    % jika luas < 14000 maka dikenali sebagai koin 1000
    elseif (stats.Area(n) < 14000) nilai = 1000
            rp1000=rp1000+1;
    
    % jika luas < 18000 maka dikenali sebagai koin 200
    elseif (stats.Area(n) < 18000) nilai = 200
             rp200=rp200+1;
    
    % jika luas < 19000 maka dikenali sebagai koin 500
    elseif (stats.Area(n) < 19000) nilai = 500
             rp500=rp500+1; 
    end
   
    %Menampilkan nilai koin pada centroid objek
    text(centers(n)-30,centers(n,2),num2str(nilai),...
        'Color','b','FontSize',12,'FontWeight','bold');
end
%% Judul plot gambar berupa total koin
title(['RP 100 = ',num2str(rp100),' Buah', ', RP 200 = ',num2str(rp200),' Buah',', RP 500 = ',num2str(rp500),' Buah',', RP 1000 = ',num2str(rp1000),' Buah',])