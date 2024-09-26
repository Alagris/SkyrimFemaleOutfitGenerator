{
  New script template, only shows processed records
  Assigning any nonzero value to Result will terminate script
}
        
unit userscript;
var
  destfile: IwbFile;
// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
  Result := 0;
end;

function Process(selectedElement: IInterface): integer;
begin
  if Signature(selectedElement) = 'ARMO' then begin
    if not Assigned(destfile) then begin
      destfile := GetFile(selectedElement);
      AddMessage(GetFileName(destfile));
    end;
    AddMessage('e := addToLVLI_(destFile, e, ''ARMO'', '''+EditorID(selectedElement)+''', ''0'', ''1'', ''0'', ''0'');')
  end;
end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.

