clear all
close all
I = imread('objetos.jpeg');
figure(1); imshow(I);
IM = rgb2gray(I);
%figure(2); imshow(IM);

%limpieza de imagen
IMW = wiener2(IM,[30,30]);
%figure(3); imshow(IMW);

umbral = graythresh(IMW);
BW = imbinarize(IMW,umbral);
%figure(4); imshow(BW);

%limpieza de imagen 2, se mantienen las figuras
%con area mayor a 100 pixeles y menores de 75000
IL = bwareafilt(BW,[100 75000]);
%IL = bwareaopen(BW,100);
%figure(5); imshow(IL);

%S = strel('disk',1);
%ILL = imclose(IL,S);
%figure, imshow(ILL);

%obtencion de las propiedades a utilizar de los objetos
stats=regionprops(IL,'Perimeter','Area','Centroid','BoundingBox','MajorAxisLength','MinorAxisLength');

hold on;
for k=1:length(stats)
    thisboundingbox=stats(k).BoundingBox;
    
    if stats(k).Area>10000
        rectangle('position',[thisboundingbox(1), thisboundingbox(2),...
            thisboundingbox(3), thisboundingbox(4)], 'EdgeColor','r','LineWidth',2);
    else
        rectangle('position',[thisboundingbox(1), thisboundingbox(2),...
            thisboundingbox(3), thisboundingbox(4)], 'EdgeColor','b','LineWidth',2); 
    end
    if stats(k).Perimeter^2/stats(k).Area > 18
        %triangulo
        %obtencion y conversion del area en cm
        Areat = stats(k).Area;
        Areaat = Areat/10000;
        areat = sprintf('%2.2f',Areaat);
        text(stats(k).Centroid(1),stats(k).Centroid(2),strcat('Area: ',num2str(areat),'cm^2'),...
            'Color','b','FontWeight','bold','FontSize',10,'HorizontalAlignment','center');
    elseif stats(k).Perimeter^2/stats(k).Area < 14.3 
        %circulo
        Areac = stats(k).Area;
        %obtencion del diametro y radio en cm
        centers = stats(k).Centroid; 
        diameters = mean([stats(k).MajorAxisLength stats(k).MinorAxisLength],2); 
        radii = (diameters/2)/10^2;
        radi = sprintf('%2.2f',radii);
        %conversion del area en cm
        Areaac = Areac/10000;
        areac = sprintf('%2.2f',Areaac);
        text(stats(k).Centroid(1),stats(k).Centroid(2),strcat('Area: ',num2str(areac),'cm^2'),...
            'Color','b','FontWeight','bold','FontSize',10,'HorizontalAlignment','right');
        text(stats(k).Centroid(1),stats(k).Centroid(2)+30,strcat('Radio: ',num2str(radi),'cm'),...
            'Color','b','FontWeight','bold','FontSize',10,'HorizontalAlignment','right');
    else 
        %cuadrado
        Areas = stats(k).Area;
        %obtencion de longitud de un lado en cm
        altooo = mean([stats(k).MajorAxisLength stats(k).MinorAxisLength],2);
        altoo = altooo/100;
        alto = sprintf('%2.2f',altoo);
        %convercion del area a cm^2
        Areaas = Areas/10000;
        areas = sprintf('%2.2f',Areaas);
        text(stats(k).Centroid(1)-20,stats(k).Centroid(2),strcat('Area: ',num2str(areas),'cm^2'),...
            'Color','b','FontWeight','bold','FontSize',10,'HorizontalAlignment','left');
        text(stats(k).Centroid(1)-20,stats(k).Centroid(2)+30,strcat('Alto: ',num2str(alto),'cm'),...
            'Color','b','FontWeight','bold','FontSize',10,'HorizontalAlignment','left');
    end
end
