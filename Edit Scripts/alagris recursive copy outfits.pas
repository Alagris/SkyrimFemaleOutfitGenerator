{
    Makes an OTFT (outfit) record from the selected ARMO (armor) records.
}
unit Alagrisscript;

var
    destinationFile: IInterface;
    outfitRecord: IInterface;

function Initialize : integer;
var
    i: integer;
    frm: TForm;
    clb: TCheckListBox;
begin
    frm := frmFileSelect;
    try
        // Initialize dialog
        frm.Caption := 'Select a plugin for outfit';
        clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
        clb.Items.Add('<new file>');
        clb.Items.Add('<new file - ESL flagged>');
        for i := 0 to Pred(FileCount) do
            clb.Items.InsertObject(2, GetFileName(FileByIndex(i)), FileByIndex(i));
        // Check if OK was pressed
        if frm.ShowModal <> mrOk then begin
            Result := 1;
            Exit;
        end;
        // Check which item was selected
        for i := 0 to Pred(clb.Items.Count) do
            if clb.Checked[i] then begin
            if i = 0 then begin
                destinationFile := AddNewFile;
            end;
            if i = 1 then begin
                destinationFile := AddNewFile;
                SetElementNativeValues(ElementByIndex(destinationFile, 0), 'Record Header\Record Flags\ESL', 1);
            end;
            if i > 1 then begin
                destinationFile := ObjectToElement(clb.Items.Objects[i]);
            end;
            Break;
            end;
    finally
        frm.Free;
    end;
    // Nothing was selected
    if not Assigned(destinationFile) then begin
        Result := 1;
        Exit;
    end;
end;

function RecusriveCopy(oldRecord: IInterface): IwbElement;
var
    recordSignature: string;
    oldRecordGroup: IInterface;
    newRecordGroup: IInterface;
    newRecord: IwbElement;
    newItems: IwbElement;
    oldItems: IwbElement;
    oldItem: IwbElement;
    newItem: IwbElement;
    i: integer;
begin

    recordSignature := Signature(oldRecord);
    if recordSignature <> 'LVLI' then exit;
    
    newRecordGroup := GroupBySignature(destinationFile, 'LVLI');
    if not Assigned(newRecordGroup) then begin
      newRecordGroup := Add(destinationFile, 'LVLI', true);
    end;
    oldRecordGroup := GroupBySignature(GetFile(oldRecord), 'LVLI');
    
    newRecord := MainRecordByEditorID(newRecordGroup, EditorID(oldRecord));    
    
    if not Assigned(newRecord) then begin
      newRecord := Add(newRecordGroup, 'LVLI', true);
      SetEditorID(newRecord, EditorID(oldRecord));                    
      oldItems := ElementByPath(oldRecord, 'LVLF\Calculate from all levels <= player''s level');
      
      SetElementNativeValues(newRecord, 'LVLF\Calculate from all levels <= player''s level', GetElementNativeValues(oldRecord, 'LVLF\Calculate from all levels <= player''s level'));
      SetElementNativeValues(newRecord, 'LVLF\Use All', GetElementNativeValues(oldRecord, 'LVLF\Use All'));
      SetElementNativeValues(newRecord, 'LVLF\Calculate for each item in count', GetElementNativeValues(oldRecord, 'LVLF\Calculate for each item in count')); 
      SetElementNativeValues(newRecord, 'LVLD', GetElementNativeValues(oldItems, 'LVLD'));
      oldItems := ElementByPath(oldRecord, 'Leveled List Entries');
      if ElementCount(oldItems) > 0 then begin
        newItems := Add(newRecord, 'Leveled List Entries', true);
        AddMessage('Count: '+IntToStr(ElementCount(oldItems)));
        for i := 0 to ElementCount(oldItems)-1 do begin
          oldItem := ElementByIndex(oldItems, i);
          if i = 0 then begin
            newItem := ElementByIndex(newItems, 0);             
          end else begin
            newItem := Add(newItems, 'Leveled List Entry', true);
          end;
          SetNativeValue(ElementByPath(newItem, 'LVLO\Count'), GetNativeValue(ElementByPath(oldItem, 'LVLO\Count')));
          SetNativeValue(ElementByPath(newItem, 'LVLO\Level'), GetNativeValue(ElementByPath(oldItem, 'LVLO\Level')));
          newItem := ElementByPath(newItem, 'LVLO\Reference');
          oldItem := ElementByPath(oldItem, 'LVLO\Reference'); 
          oldItem := LinksTo(oldItem);
          AddMessage(FullPath(oldItem)+' -> '+GetFileName(GetFile(oldItem))+' = '+GetFileName(GetFile(oldRecord)));
          if GetFileName(GetFile(oldRecord)) = GetFileName(GetFile(oldItem)) then begin
            oldItem := RecusriveCopy(oldItem);
          end else begin
            AddRequiredElementMasters(oldItem, destinationFile, False);
          end;
          newItem := ElementAssign(newItem, LowInteger, oldItem, false);
          AddMessage(EditorID(newRecord)+':'+EditorID(newItem));
        end;
      end;
    end;
    Result := newRecord;
end;



function Process(selectedElement: IInterface): integer;
begin 
   RecusriveCopy(selectedElement);
end;
end.
