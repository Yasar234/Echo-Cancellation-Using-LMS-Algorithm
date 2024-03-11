function hlms = lms_echo( lmsa,lmsb,lmsc,lmsd,lmse )
%LMS_ECHO Summary of this function goes here
%   Detailed explanation goes here




 hlms = adaptfilt.fdaf(lmsa, lmsb, lmsc, lmsd, lmse);

end

