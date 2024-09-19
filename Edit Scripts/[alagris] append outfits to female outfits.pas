{
    Makes an OTFT (outfit) record from the selected ARMO (armor) records.
}
unit Alagrisscript;

var
    destinationFile: IInterface;
    outfitRecord: IInterface;
    outfitItemPrefix: String;

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
        InputQuery('Armor item prefix (optional)', 'OTFT INAM prefix', outfitItemPrefix);
    finally
        frm.Free;
    end;
    // Nothing was selected
    if not Assigned(destinationFile) then begin
        Result := 1;
        Exit;
    end;
end;

function Process(selectedElement: IInterface): integer;
var
    recordSignature: string;
    outfitRecordGroup: IInterface;
    newOutfitRecord: IwbElement;
    defaultOutfitElement: IwbElement;
    oldOutfitRecord: IwbElement;
    newOutfitRecordId: string;
    newOutfitItems: IwbElement;
    oldOutfitItems: IwbElement;
    oldOutfitItem: IwbElement;
    newOutfitItem: IwbElement;
    i: integer;
begin
    AddRequiredElementMasters(selectedElement, destinationFile, False);

    recordSignature := Signature(selectedElement);
    if recordSignature <> 'OTFT' then exit;
    
    outfitRecordGroup := GroupBySignature(destinationFile, 'OTFT');
    if not Assigned(outfitRecordGroup) then exit;
    
    newOutfitRecordId := 'Female'+EditorID(selectedElement);
    newOutfitRecord := MainRecordByEditorID(outfitRecordGroup, newOutfitRecordId);    
    
    if Assigned(newOutfitRecord) then begin
      oldOutfitItems := ElementByPath(selectedElement, 'INAM');
      newOutfitItems := ElementByPath(newOutfitRecord, 'INAM');
      if outfitItemPrefix  = '*' then begin
          for i := ElementCount(newOutfitItems)-1 downto 0 do begin
            newOutfitItem := RemoveByIndex(newOutfitItems, i, true);
            AddMessage('Remove '+EditorID(LinksTo(newOutfitItem))+' from '+EditorID(newOutfitRecord));
          end;
      end;
      for i := 0 to ElementCount(oldOutfitItems)-1 do begin
        oldOutfitItem := LinksTo(ElementByIndex(oldOutfitItems, i));
        
        if (outfitItemPrefix = '*') or StartsStr(outfitItemPrefix, EditorID(oldOutfitItem)) then begin      
          newOutfitItem := ElementAssign(newOutfitItems, HighInteger, oldOutfitItem, false);
          AddMessage(EditorID(selectedElement)+':'+EditorID(oldOutfitItem)+'->'+EditorID(newOutfitRecord));             
        end;
      end;
    end;
end;

end.
