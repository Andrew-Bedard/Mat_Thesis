
%Allows one to select outline of image and output it as a collection of
%coordinates

I = imread('Fox_late-gastrula2.jpg');
I = rgb2gray(I);
figure, imshow(I)
BW = roipoly(I);

%Now requires the selection of the inside of the polygon to copy and paste
%into workspace

%outline from Fox_late-gastrula2.jpg
%out_ln = [128.995667244367 58.9488734835355;130.226169844021 56.9800693240901;131.210571923743 53.28856152513;131.456672443674 50.8275563258232;130.718370883882 49.1048526863085;129.98006932409 45.659445407279;129.241767764298 43.4445407279029;128.011265164645 40.9835355285962;126.534662045061 38.5225303292894;125.304159445407 35.815424610052;123.581455805893 32.8622183708839;120.874350086655 30.6473136915078;118.167244367418 28.6785095320624;115.706239168111 26.4636048526863;111.522530329289 23.7564991334489;107.584922010399 21.5415944540728;103.893414211438 19.5727902946274;99.9558058925476 18.0961871750433;95.7720970537262 17.3578856152513;92.5727902946274 16.8656845753899;89.3734835355286 16.6195840554593;87.1585788561525 16.3734835355286;83.713171577123 16.1273830155979;80.2677642980936 16.3734835355286;76.5762564991334 16.3734835355286;73.6230502599653 16.8656845753899;70.4237435008665 17.603986135182;66.4861351819757 18.5883882149047;63.2868284228769 20.0649913344887;59.5953206239168 21.5415944540728;56.6421143847487 23.0181975736568;52.9506065857885 24.7409012131716;49.7512998266897 26.9558058925476;46.551993067591 28.9246100519931;44.0909878682842 30.6473136915078;40.8916811091854 33.1083188908145;37.6923743500866 35.3232235701906;34.9852686308492 38.2764298093587;32.2781629116118 40.9835355285962;29.5710571923743 44.182842287695;27.8483535528596 47.3821490467937;26.6178509532062 50.3353552859619;25.6334488734835 53.7807625649913;24.6490467937608 57.7183708838821;23.4185441941074 61.6559792027729;22.9263431542461 66.3318890814558;22.188041594454 70.0233968804159;21.6958405545927 74.6993067590988;21.449740034662 78.6369150779896;21.6958405545927 82.5745233968804;21.6958405545927 86.7582322357019;22.188041594454 91.188041594454;23.9107452339688 94.8795493934142;26.3717504332755 98.817157712305;29.078856152513 101.770363951473;32.5242634315424 104.723570190641;35.7235701906412 107.430675909879;39.9072790294627 110.137781629116;44.3370883882149 112.844887348354;48.766897746967 115.30589254766;53.1967071057192 116.782495667244;57.6265164644714 118.75129982669;61.0719237435008 119.735701906412;65.2556325823223 120.720103986135;69.9315424610052 122.196707105719;74.607452339688 123.181109185442;78.5450606585788 123.181109185442;83.4670710571924 123.181109185442;88.8812824956672 122.688908145581;93.8032928942807 121.704506065858;97.4948006932409 121.212305025997;102.170710571924 119.243500866551;106.354419410745 117.520797227036;109.061525129983 115.798093587522;112.014731369151 113.337088388215;114.475736568458 111.368284228769;116.690641247834 108.907279029463;119.15164644714 106.200173310225;121.612651646447 103.246967071057;122.8431542461 100.293760831889;123.827556325823 98.078856152513;124.565857885615 94.6334488734835;123.335355285962 90.2036395147314;121.612651646447 87.0043327556326;120.136048526863 84.0511265164645;118.659445407279 81.8362218370884;116.198440207972 79.6213171577123;114.721837088388 77.8986135181976;114.721837088388 75.6837088388215;115.952339688042 73.7149046793761;117.182842287695 70.761698440208;118.659445407279 68.7928942807626;120.382149046794 67.5623916811092;123.089254766031 65.5935875216638;125.550259965338 64.3630849220104;128.257365684575 62.394280762565];

%Convert poly vertecies from out_ln into set of x and y coordinates for
%plotting. If comparing with Edge from PST, use : imshow(Edge), hold on;
%before using the following.
%x_ln = [out_ln(:,1)];
%y_ln = [out_ln(:,2)];
%plot(x,y);