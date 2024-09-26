{
  New script template, only shows processed records
  Assigning any nonzero value to Result will terminate script
}
        
unit userscript;
var
  code: string;
  visited: string;
  destfile: IwbFile;
// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
  visited := '#';
  code := 'unit userscript;'#13#10;
  code := code + 'function Initialize: integer;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    Result := 0;'#13#10;
  code := code + 'end;'#13#10;
  code := code + 'function FileByName(fn: string): IwbFile;'#13#10;
  code := code + 'var'#13#10;
  code := code + '    i: integer;'#13#10;
  code := code + '    f: IwbFile;'#13#10;
  code := code + '    fname: string;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    for i := 0 to Pred(FileCount) do begin'#13#10;
  code := code + '        f := FileByIndex(i);'#13#10;
  code := code + '        fname := GetFileName(f);'#13#10;
  code := code + '        if fname = fn then begin'#13#10;
  code := code + '            Result := f;'#13#10;
  code := code + '            exit;'#13#10;
  code := code + '        end;'#13#10; 
  code := code + '    end;'#13#10; 
  code := code + 'end;'#13#10;
  code := code + 'function newOTFT(destFile: IwbFile; eID:string): IwbElement;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    if Assigned(MainRecordByEditorID(GroupBySignature(destFile,''OTFT''), eID)) then begin'#13#10;
  code := code + '        exit;'#13#10;  
  code := code + '    end;'#13#10;  
  code := code + '    Result := Add(GroupBySignature(destFile, ''OTFT''), ''OTFT'', true);'#13#10;  
  code := code + '    SetEditorID(Result, eID);'#13#10;  
  code := code + '    Result := Add(Result, ''INAM'', true);'#13#10;
  code := code + 'end;'#13#10;
  code := code + 'function addToOTFT(destFile: IwbFile; e: IwbElement; filename, signat, ref:string): IwbElement;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    AddMasterIfMissing(destFile, filename);'#13#10;
  code := code + '    Result := Add(e, ''Item'', true);'#13#10;
  code := code + '    SetEditValue(Result, Name(MainRecordByEditorID(GroupBySignature(FileByName(filename), signat), ref)));'#13#10;
  code := code + 'end;'#13#10;
  code := code + 'function addToOTFT_(destFile: IwbFile; e: IwbElement; signat, ref:string): IwbElement;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    Result := Add(e, ''Item'', true);'#13#10;
  code := code + '    SetEditValue(Result, Name(MainRecordByEditorID(GroupBySignature(destFile, signat), ref)));'#13#10;
  code := code + 'end;'#13#10;
  code := code + 'function generate(destFile: IwbFile): integer;'#13#10;
  code := code + 'var'#13#10;
  code := code + '    e:IwbElement;'#13#10;
  code := code + 'begin'#13#10;

  Result := 0;
end;

function Process(selectedElement: IInterface): integer;
begin
  destfile := GetFile(selectedElement);
  RecProcess(selectedElement);
end;
// called for every record selected in xEdit
function RecProcess(selectedElement: IInterface): integer;
var
  recordSignature: string;
  items: IwbElement;
  item: IwbElement;
  ref: IwbMainRecord;
  i: integer;
begin

  recordSignature := EditorID(selectedElement)+'#';
  i := pos('#'+recordSignature, visited);
  if i = 0 then visited := visited + recordSignature
  else exit;
  recordSignature := Signature(selectedElement);

  if recordSignature = 'LVLI' then begin
    items := ElementByPath(selectedElement, 'Leveled List Entries');  
    for i := 0 to ElementCount(items)-1 do begin
        item := ElementByIndex(items, i);    
        ref := LinksTo(ElementByPath(item, 'LVLO\Reference'));
        if GetFileName(GetFile(ref)) = GetFileName(destfile) then begin
          RecProcess(ref);
        end;
    end;
        
    code := code + '    e := newLVLI(destFile, '''+
      EditorID(selectedElement)+''', '''+
      GetElementEditValues(selectedElement, 'LVLD')+''', '''+
      GetElementEditValues(selectedElement, 'LVLF\Use All')+''', '''+
      GetElementEditValues(selectedElement, 'LVLF\Calculate for each item in count')+''', '''+
      GetElementEditValues(selectedElement, 'LVLF\Calculate from all levels <= player''s level')+
    ''');'#13#10;
    for i := 0 to ElementCount(items)-1 do begin
        item := ElementByIndex(items, i);    
        ref := LinksTo(ElementByPath(item, 'LVLO\Reference'));
        if GetFileName(GetFile(ref)) = GetFileName(destfile) then begin
          code := code + '    addToLVLI_(destFile, e, '''+Signature(ref)+''', '''+EditorID(ref)+''', '''+GetElementEditValues(item, 'LVLO\Count')+''', '''+GetElementEditValues(item, 'LVLO\Level')+''');'#13#10;
        end else begin
          code := code + '    addToLVLI(destFile, e, '''+GetFileName(GetFile(ref))+''', '''+Signature(ref)+''', '''+EditorID(ref)+''', '''+GetElementEditValues(item, 'LVLO\Count')+''', '''+GetElementEditValues(item, 'LVLO\Level')+''');'#13#10;
        end;
     end;  
     code := code + '    RemoveByIndex(e, 0, true);'#13#10;
  end;
end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  code := code + 'end;'#13#10;
  code := code + 'function Process(e: IInterface): integer;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    generate(GetFile(e));'#13#10;
  code := code + '    Result := 0;'#13#10;
  code := code + 'end;'#13#10;
  code := code + 'function Finalize(e: IInterface): integer;'#13#10;
  code := code + 'begin'#13#10;
  code := code + '    Result := 0;'#13#10;
  code := code + 'end;'#13#10;
  code := code + 'end.'#13#10;
  AddMessage(code);
  Result := 0;
end;

end.

