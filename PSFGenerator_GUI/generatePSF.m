
function isdone = generatePSF(em,na,xyres,zres,xysize,zsize,rs,ri,dstart,numPSF,w4,w7,w8,w12)

isdone = 0;

depth = dstart;

for d=1:numPSF
    PSFem = PSFa(em,na,xyres,zres,xysize,zsize,rs,ri,depth,w4,w7,w8,w12);
    PSF = PSFem.*PSFem;
    PSF(isnan(PSF)) = eps;

    PSF = PSF./sum(PSF(:));
    depth = (depth+zres)/10;
    
    if (d <10)
        eval(['h0000' num2str(d) ' = PSF;']);
        eval(['save h0000' num2str(d) ' h0000' num2str(d) '']);
    elseif (d<100)
        eval(['h000' num2str(d) ' = PSF;']);
        eval(['save h000' num2str(d) ' h000' num2str(d) '']); 
    elseif (d<1000)
        eval(['h00' num2str(d) ' = PSF;']);
        eval(['save h00' num2str(d) ' h00' num2str(d) '']); 
    elseif (d<10000)
        eval(['h0' num2str(d) ' = PSF;']);
        eval(['save h0' num2str(d) ' h0' num2str(d) '']); 
    elseif (d<100000)
        eval(['h' num2str(d) ' = PSF;']);
        eval(['save h' num2str(d) ' h' num2str(d) '']); 
    end
end

isdone = 1;