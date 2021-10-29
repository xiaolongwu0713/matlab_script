function [ vcontribs ] = electrodesContributions( M, subjstructs, kernel, param, cutoff,dis_cutoff)
%ELECTRODESCONTRIBUTIONS    Compute the coefficients of activated vertices.
%
%   Computes contribution values of subject electrode grids at affected brain
%   model vertices (those vertices that are near the electrodes as specified
%   by the parameters) - see also INPUT: kernel.
%
%   The output vcontribs is required by the
%   activateBrain( M, vcontribs, subjstructs, range, cmapstruct, viewstruct ) function
%
%
%   CALLING SEQUENCE:
%       [ vcontribs ] = electrodesContributions( M, subjstructs, kernel, param, cutoff)
%
%   INPUT:
%       M:              struct('vert', Vx3matrix) - brain model (eventually the one altered by projectElectrodes.m, see <help projectElectrodes>)
%       subjstructs:    field of structures, for each subject: struct('electrodes', Nsubjx3matrix)
%       kernel:         a function whose values (at a certain vertex distance from an electrode) is being used for the multiplication of the electrode value (the multiplication is done by activateBrain); the multiplier is understood to be the contribution of an electrode to the vertex
%           possible values: 'linear', 'gaussian'
%       param:          parameter of the kernel function
%                       (for 'linear', this is the point of the linear function at which it is zero; for 'gaussian', this is the standart deviation)
%       cut-off:        only those vertices vert whose distance(vert, electrode) < cuf-off are considered to be altered by a near electrode (the more distant ones will not be displayed by activateBrain)
%            
%   OUTPUT:
%       vcontribs:      struct('vertNo', index, 'contribs', [subj#, el#, mult;...]) - structure containing the vertices that are near the electrode grids; this structure contains the multipliers
%
%   REMARK:
%       There are several electrodes on subject's electrode grid that can
%       contribute with its multipliers to a vertex; the contribution is then a 
%       scalar product (a weigted sum) of these multipliers and electrode values;
%       only the contributions of distinct subjects are averaged by activateBrain.
%
%   Example:
%       [ vcontribs ] = electrodesContributions( M, subjstructs, 'linear', 10, 10)
%           computes contributions using linear 'fade-out' function,
%           supposing that the interelectrode distance is 10 (the parameter
%           cutoff might be set to a higher value when using a single
%           subject (nicer smearing), but should be set equal to param for
%           multiple subject usage (so that zero values far from the
%           subject electrode do not contribute to the averaging at a
%           vertex close to the electrode of another subject)
%
%   See also DEMO, PROJECTELECTRODES, ACTIVATEBRAIN.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Updated by Guangye Li @liguangye.hust@Gmail.com @USA @2018.02.01

%CONTRIBUTION PART---------------
%For the projected electrodes, compute the contribution values
Vv2 = length(M.vert);
affvert = [];
vcontribs = [];
NMAX = 1 / (sqrt(2*pi) * param); %precompute; value of the pdf at 0 shall be 1
Ss = length(subjstructs);
for subj = 1 : Ss,
   disp(sprintf('Computing the electrode contributions to the vertices:'));
   disp(sprintf('   processing subject %d', subj));   
   Ee = size(subjstructs(subj).trielectrodes, 1);
   d_e_trie=zeros(1,Ee);
   for eg = 1 : Ee, %************以每个投影点为大循环！！！！
       disp(sprintf('      processing electrode %d', eg));       
       
       dvect = zeros(1, Vv2);
       disp(sprintf('           computing distances', eg));     
       trielectrode = subjstructs(subj).trielectrodes(eg, :); %reallocate
       electrodes=subjstructs(subj).electrodes(eg, :); 
       vert = M.vert; %reallocate 计算原始电极和投影电极之间的距离
       d_e_trie(eg)=norm(electrodes-trielectrode);
       for v = 1 : Vv2, %***********以每个大脑顶点为小循环
%       compute the distance ||eg - v||^2 and store into a vector dvect
%       计算大脑顶点到投影电极之间的距离 //以每个投影电极为原点，计算所有范围内的顶点
           delta = trielectrode - vert(v, :);
           dvect(v) = delta * delta';
       end
       disp(sprintf('           OK', eg));       
       disp(sprintf('           computing contributions', eg));       
              
%       find all vertices closevert that are closer to eg than sigma2
%       寻找一个投影点附近所有符合范围要求的顶点
       closevert = find(dvect < cutoff^2); %closevert是顶点的序号 见75和79行 closevert为抽取出来的v 是一个数据组
       if isempty(closevert),
           disp(sprintf('No close vertices from electrode %d of subject %d were found', eg, subj));
       end
       
       for k = 1 : length(closevert), %k表示有多少个在要求范围内的顶点
           vs = closevert(k); %so that special conditions do not need to be tested instead of "for vs = closevert"
%          vs是顶点序号，即vcontribs里面的No.
%           compute the contribution value mult of eg to vs by feeding the distance dvect(vs) into a normalized gaussian kernel function
           switch kernel
               case 'gaussian'
                   sigma = param;
                   mult = exp(-0.5 * (d_e_trie(eg)/dis_cutoff)^2)*exp(-0.5 * dvect(vs) / sigma^2) / (sqrt(2*pi) * sigma * NMAX);
               case 'linear'
                   x0 = sqrt(dvect(vs)); %sqrt and exp are built-in
                   if x0 > param || d_e_trie(eg)>dis_cutoff,
                       mult = 0;
                   else
                       mult = (1 - x0 / param)*(1-d_e_trie(eg)/dis_cutoff);
                   end
               otherwise             
                   error('Unknown kernel type. Please refer to <help electrodescontribs>.');
           end
            
%           check whether vs already in affvert
           ix = find(affvert == vs); %如果出现相同的顶点（即一个顶点在多个投影坐标的指定范围之内）
%           if yes
%               add [subj, eg, mult] to its existing structure
           if ~isempty(ix),
               vcontribs(ix).contribs = [vcontribs(ix).contribs; subj, eg, mult]; %subj表示几个受试者或几组数据？ eg表示哪个投影坐标点（所以通道要和坐标位置对应，要转换）。mult表示衰减系数。
%           else               
%               put [subj, eg, mult] to a newly created structure, put vs
%               into affvert
           else
               vcontribs(end + 1).vertNo = vs; %vcontribs是一个struct  vcontribs(end+1)代表劈一个格子放置数据
               vcontribs(end).contribs = [subj, eg, mult]; %vcontribs(end+1)后和vcontribs(end)是同一行
               affvert(end + 1) = vs; %affvert是用来放置所有出现过的顶点
           end
       end
       disp(sprintf('           OK', eg));
   end
end