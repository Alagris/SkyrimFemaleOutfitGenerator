unit userscript;

function Initialize: integer;
var
	f: IwbFile;
	grp: IwbGroupRecord;
	destFile: IwbFile;
	destGrp: IwbGroupRecord;
	i: integer;
	j: integer;
	oldRecord: IwbElement;
	winningRecord: IwbElement;
	signature: string;
begin
    Result := 0;
    destFile := AddNewFileName('smashtest.esp');
    signature := 'NPC_';
    destGrp := Add(destFile, signature, true);

    for i := 0 to Pred(FileCount) do begin
    	f := FileByIndex(i);
    	grp := GroupBySignature(f, signature);
    	if Assigned(grp) then begin
    		for j:=0 to ElementCount(grp) do begin
    			oldRecord := ElementByIndex(grp, j);
    			if IsWinningOverride(oldRecord) then begin
    				AddMessage(FullPath(oldRecord));
    				// Add(, 'LVLI', true);
    			end;
    		end;
    		
    	end;

    	
    	
    end;
end;

function Process(e: IInterface): integer;
begin
    
    Result := 0;
end;

function Finalize(e: IInterface): integer;
begin
    Result := 0;
end;
end.
