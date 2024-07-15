CFAmounts = [10 10 100];
CFDates     = datenum(datetime({'Jan312015','May312015','Dec312015'},'InputFormat','MMMddyyyy'));
InstSet   = instadd('CashFlow', CFAmounts, CFDates, Settle, Basis)