%kkwinset ' '
% This MatLab function was automatically generated by a converter (KhorosToMatLab) from the Khoros kwinset.pane file
%
% Parameters: 
% InputFile: i1 'Input Object', required: 'Input object to inset subband to.'
% InputFile: i2 'Input Subband', required: 'input subband for inseting.'
% OutputFile: o 'Output Object', required: 'Resulting output data object'
% Toggle: attr 'Use Input 2 Sub-Object Position (unless overridden below)', default: 0: 'Insert at i2 subobject position (attribute) - w,h,d,t,e will override if specified'
% Integer: wl 'Width ', default: 1: 'Number of layers in the width direction.'
% Integer: hl 'Height ', default: 1: 'Number of layers in the height direction.'
% Integer: dl 'Depth ', default: 1: 'Number of layers in the depth direction.'
% Integer: tl 'Time ', default: 1: 'Number of layers in the time direction.'
% Integer: el 'Elements ', default: 1: 'Number of layers in the elements direction.'
%
% Example: o = kkwinset({i1, i2}, {'i1','';'i2','';'o','';'attr',0;'wl',1;'hl',1;'dl',1;'tl',1;'el',1})
%
% Khoros helpfile follows below:
%
%  PROGRAM
% kwinset - inset of subbands into a wavelet object
%
%  DESCRIPTION
% NOTE: The terms band and subband in this routine refers to Wavelet Analysis.
% The Inset Subband operator, kwinset, insets data from "Input 2" (i2) into
% "Input 1" (i1) at the specified position, replacing the data in
% "Input 1".  The resulting \fIOutput\fP object (o) size will be at
% least the size of Input 1, and may be larger, depending on the specified
% position values and the size of "Input 2".
% 
% The inset operation is based on implicit indexing.  This means
% that if location or time data exist, the inset
% operation is not done in terms an interpretation of
% the location/time data values, but in terms of the
% implicit indexing of these data (which is specified
% by the Width, Height, Depth, Time, Elements indices
% of the polymorphic data model).  If location and/or time
% data exist in either input object, the output object will
% also contain location and/or time data.
% 
% The position in Input 1 where Input 2 will be inset
% can be determined from the Sub-Object Position attribute
% that is stored in Input 2, or specified by the Width (w and wl),
% Height (h and hl) , Depth (d and dl), Time (t and tl), and Elements (e and el)
% Select Subband and Select Level parameters.  The combination of these
% two parameters (Subband Selection and Subband Level) will define the size of 
% the subband to be inseted .  Basicaly, what "Subband Inset" does is to 
% get the total size of a selected dimension defined by the Select Subband
% parameter and divide this dimension  by two to the number defined by
% the related Subband Level parameter, the obtained number defines the
% size of the subband in that dimension.  If the Select Subband parameter
% for a selected dimension is equal to "High" then the origin of the
% subband in that dimension will be equal to the size of the subband in that
% dimension, if the Select Subband  parameter for a selected dimension is
% "Low" the subband origin in that dimension is set to 0.  The previous
% process is repeated for each selected dimension.  The subobject position 
% attribute is automatically set by programs such as the Extract Subband 
% operator (kwextract).  Using a combination of the subobject position attribute 
% and the explicit coordinates is valid.
% 
% In some instances, padding is necessary to
% maintain the integrity of the polymorphic data model -
% for example when the final size of the Output
% object is larger than that of Input 1.  The Real
% and Imaginary Pad Values (real, imag) define the values that
% will be used when padding.
% 
% If padding occurs, and the option to "Identify padded data added
% by this program as Valid" is selected (valid TRUE), all padded data
% is considered valid and, if either input object contains a validity mask,
% the output object will have a mask, and the mask value for the padded
% data will be 1.  The output object will not contain a mask if
% neither input object has a mask.  If padded data is to
% be identified as Invalid (valid FALSE), the padded data will be
% masked as invalid (0).  In this case, even if neither input object has
% a validity mask, the output object will have one.
% 
%  "Data Type" 5
% .cI $DATAMANIP/repos/shared/man/sections/value_type_2input
% 
%  "Map Data" 5
% .cI $DATAMANIP/repos/shared/man/sections/map_2input
% 
%  "Failure Modes" 5
% This program will fail if either input object lacks value data.
%
%  
%
%  EXAMPLES
%
%  "SEE ALSO"
% kinsert, kextract
%
%  RESTRICTIONS 
%
%  REFERENCES 
%
%  COPYRIGHT
% Copyright (C) 1993 - 1997, Khoral Research, Inc.  All rights reserved.
% 


function varargout = kkwinset(varargin)
if nargin ==0
  Inputs={};arglist={'',''};
elseif nargin ==1
  Inputs=varargin{1};arglist={'',''};
elseif nargin ==2
  Inputs=varargin{1}; arglist=varargin{2};
else error('Usage: [out1,..] = kkwinset(Inputs,arglist).');
end
if size(arglist,2)~=2
  error('arglist must be of form {''ParameterTag1'',value1;''ParameterTag2'',value2}')
 end
narglist={'i1', '__input';'i2', '__input';'o', '__output';'attr', 0;'wl', 1;'hl', 1;'dl', 1;'tl', 1;'el', 1};
maxval={0,0,0,0,2,2,2,2,2};
minval={0,0,0,0,2,2,2,2,2};
istoggle=[0,0,0,1,1,1,1,1,1];
was_set=istoggle * 0;
paramtype={'InputFile','InputFile','OutputFile','Toggle','Integer','Integer','Integer','Integer','Integer'};
% identify the input arrays and assign them to the arguments as stated by the user
if ~iscell(Inputs)
Inputs = {Inputs};
end
NumReqOutputs=1; nextinput=1; nextoutput=1;
  for ii=1:size(arglist,1)
  wasmatched=0;
  for jj=1:size(narglist,1)
   if strcmp(arglist{ii,1},narglist{jj,1})  % a given argument was matched to the possible arguments
     wasmatched = 1;
     was_set(jj) = 1;
     if strcmp(narglist{jj,2}, '__input')
      if (nextinput > length(Inputs)) 
        error(['Input ' narglist{jj,1} ' has no corresponding input!']); 
      end
      narglist{jj,2} = 'OK_in';
      nextinput = nextinput + 1;
     elseif strcmp(narglist{jj,2}, '__output')
      if (nextoutput > nargout) 
        error(['Output nr. ' narglist{jj,1} ' is not present in the assignment list of outputs !']); 
      end
      if (isempty(arglist{ii,2}))
        narglist{jj,2} = 'OK_out';
      else
        narglist{jj,2} = arglist{ii,2};
      end

      nextoutput = nextoutput + 1;
      if (minval{jj} == 0)  
         NumReqOutputs = NumReqOutputs - 1;
      end
     elseif isstr(arglist{ii,2})
      narglist{jj,2} = arglist{ii,2};
     else
        if strcmp(paramtype{jj}, 'Integer') & (round(arglist{ii,2}) ~= arglist{ii,2})
            error(['Argument ' arglist{ii,1} ' is of integer type but non-integer number ' arglist{ii,2} ' was supplied']);
        end
        if (minval{jj} ~= 0 | maxval{jj} ~= 0)
          if (minval{jj} == 1 & maxval{jj} == 1 & arglist{ii,2} < 0)
            error(['Argument ' arglist{ii,1} ' must be bigger or equal to zero!']);
          elseif (minval{jj} == -1 & maxval{jj} == -1 & arglist{ii,2} > 0)
            error(['Argument ' arglist{ii,1} ' must be smaller or equal to zero!']);
          elseif (minval{jj} == 2 & maxval{jj} == 2 & arglist{ii,2} <= 0)
            error(['Argument ' arglist{ii,1} ' must be bigger than zero!']);
          elseif (minval{jj} == -2 & maxval{jj} == -2 & arglist{ii,2} >= 0)
            error(['Argument ' arglist{ii,1} ' must be smaller than zero!']);
          elseif (minval{jj} ~= maxval{jj} & arglist{ii,2} < minval{jj})
            error(['Argument ' arglist{ii,1} ' must be bigger than ' num2str(minval{jj})]);
          elseif (minval{jj} ~= maxval{jj} & arglist{ii,2} > maxval{jj})
            error(['Argument ' arglist{ii,1} ' must be smaller than ' num2str(maxval{jj})]);
          end
        end
     end
     if ~strcmp(narglist{jj,2},'OK_out') &  ~strcmp(narglist{jj,2},'OK_in') 
       narglist{jj,2} = arglist{ii,2};
     end
   end
   end
   if (wasmatched == 0 & ~strcmp(arglist{ii,1},''))
        error(['Argument ' arglist{ii,1} ' is not a valid argument for this function']);
   end
end
% match the remaining inputs/outputs to the unused arguments and test for missing required inputs
 for jj=1:size(narglist,1)
     if  strcmp(paramtype{jj}, 'Toggle')
        if (narglist{jj,2} ==0)
          narglist{jj,1} = ''; 
        end;
        narglist{jj,2} = ''; 
     end;
     if  ~strcmp(narglist{jj,2},'__input') && ~strcmp(narglist{jj,2},'__output') && istoggle(jj) && ~ was_set(jj)
          narglist{jj,1} = ''; 
          narglist{jj,2} = ''; 
     end;
     if strcmp(narglist{jj,2}, '__input')
      if (minval{jj} == 0)  % meaning this input is required
        if (nextinput > size(Inputs)) 
           error(['Required input ' narglist{jj,1} ' has no corresponding input in the list!']); 
        else
          narglist{jj,2} = 'OK_in';
          nextinput = nextinput + 1;
        end
      else  % this is an optional input
        if (nextinput <= length(Inputs)) 
          narglist{jj,2} = 'OK_in';
          nextinput = nextinput + 1;
        else 
          narglist{jj,1} = '';
          narglist{jj,2} = '';
        end;
      end;
     else 
     if strcmp(narglist{jj,2}, '__output')
      if (minval{jj} == 0) % this is a required output
        if (nextoutput > nargout & nargout > 1) 
           error(['Required output ' narglist{jj,1} ' is not stated in the assignment list!']); 
        else
          narglist{jj,2} = 'OK_out';
          nextoutput = nextoutput + 1;
          NumReqOutputs = NumReqOutputs-1;
        end
      else % this is an optional output
        if (nargout - nextoutput >= NumReqOutputs) 
          narglist{jj,2} = 'OK_out';
          nextoutput = nextoutput + 1;
        else 
          narglist{jj,1} = '';
          narglist{jj,2} = '';
        end;
      end
     end
  end
end
if nargout
   varargout = cell(1,nargout);
else
  varargout = cell(1,1);
end
global KhorosRoot
if exist('KhorosRoot') && ~isempty(KhorosRoot)
w=['"' KhorosRoot];
else
if ispc
  w='"C:\Program Files\dip\khorosBin\';
else
[s,w] = system('which cantata');
w=['"' w(1:end-8)];
end
end
[varargout{:}]=callKhoros([w 'kwinset"  '],Inputs,narglist);