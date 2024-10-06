{
    Makes an OTFT (outfit) record from the selected ARMO (armor) records.
}
unit Alagrisscript;

var
    destinationFile: IInterface;
    outfitRecordGroup: IInterface;
    lvlnRecordGroup: IInterface;
    npcRecordGroup: IInterface;
    lvliRecordGroup: IInterface;
    hasPantiesofskyrim: Boolean;
    filePantiesofskyrim: IwbFile;
    fileUSSEP: IwbFile;
    fileUpdate: IwbFile;
    fileDeviousLore: IwbFile;
    fileCocoBikini: IwbFile;
    fileWizardHats: IwbFile;
    fileWitchyHats: IwbFile;
    hasTAWOBA: Boolean;
    fileTAWOBA: IwbFile;
    fileTAWOBALeveledList: IwbFile;
    hasTEWOBA: Boolean;
    hasCoT: Boolean;
    fileTEWOBA: IwbFile;
    hasModularMage: Boolean;
    fileModularMage: IwbFile;
    fileSkyrim: IwbFile;
    fileCocoWitch: IwbFile;
    fileForgottenPrincess: IwbFile;
    fileCocoAhri: IwbFile;
    fileFairyQueen: IwbFile;
    fileCocoDemon: IwbFile;
    fileCocoLingerie: IwbFile;
    fileCocoLace: IwbFile;
    fileHS2Bunny: IwbFile;
    fileKSOMage: IwbFile;
    fileMegacore: IwbFile;
    fileAlternateStart: IwbFile;
    fileCocoAssassin: IwbFile;
    fileChristineUndead: IwbFile;
    fileChristineNocturnal: IwbFile;
    fileChristineBlackMagic: IwbFile;
    fileChristineDeadlyDesire: IwbFile;
    fileChristinePriestess: IwbFile;
    fileChristineExnem: IwbFile;
    fileSkimpyMaid: IwbFile;
    fileShinoSchool: IwbFile;
    fileDXFI: IwbFile;
    fileDXFII: IwbFile;
    fileDXsT: IwbFile;
    fileChristineKitchen: IwbFile;
    fileChristineAphrodite: IwbFile;
    fileChildOfTalos: IwbFile;
    fileCocoSlave: IwbFile;
    fileCocoLolita: IwbFile;
    fileMelodicBunny: IwbFile;
    fileHaruBondage: IwbFile;
    fileMystKnight: IwbFile;
    fileNiniCatMaid: IwbFile;
    fileNiniChatNoir: IwbFile;
    fileNiniBlacksmith: IwbFile;
    AnyMagePrefix: string;
    AnyNecromancerPrefix: string;
    AnyWarlockPrefix: string;
    KitchenLingerie: IwbMainRecord;
    KitchenLingerieId: string;
    KitchenLingerieOutfit: IwbMainRecord;
    AnyLingerieId: string;
    AnyLingerie: IwbMainRecord;
    AnyDawnguardId: string;
    AnyDawnguard: IwbMainRecord;
    AnyForswornId: string;
    AnyForsworn: IwbMainRecord;
    AnyFineClothes: IwbMainRecord;
    AnyFineClothesId: string;
    AnyFarmClothes: IwbMainRecord;
    AnyFarmClothesId: string;
    AnyJarl: IwbMainRecord;
    AnyJarlId: string;
    Any: IwbMainRecord;
    AnyLingerieOutfit: IwbMainRecord;
    AnyThievesGuild: IwbMainRecord;
    AnyThievesGuildId: string;
    AnyBeggar: IwbMainRecord;
    AnyBeggarId: string;
    AnyPrisoner: IwbMainRecord;
    AnyPrisonerOutfit: IwbMainRecord;
    AnyPrisonerId: string;
    AnyAssassin: IwbMainRecord;
    AnyAssassinId: string;
    AnyBlacksmith: IwbMainRecord;
    AnyBlacksmithId: string;
    AnyBarkeeper: IwbMainRecord;
    AnyBarkeeperId: string;
    AnyMonk: IwbMainRecord;
    AnyMonkId: string;
    AnyVampirePrefix: string;
    npcFileHydSlavegirls: IwbFile;
    npcFileDawnguard: IwbFile;
    npcFileAnciProf: IwbFile;
    npcFileDragonborn: IwbFile;
    npcFileHearthfires: IwbFile;
    npcFileCCContest: IwbFile;
    npcFileCCBloodfall: IwbFile;
    npcFileCCAdv: IwbFile;
    npcFileMoreBCamp: IwbFile;
    npcFileMiasL: IwbFile;
    npcFileAAvd: IwbFile;
    npcFileJKsS: IwbFile;
    npcFileSoD: IwbFile;
    npcFileSoDs: IwbFile;
    npcFileToH: IwbFile;
    npcFileSimSlav: IwbFile;
    smashedFiles: string;
    numSpecialNpcItems: integer;

function ElementTypeStr(e: IwbElement): string;
var 
  typ: string;
begin
  Case ElementType(e) of
    etFile:
      Result := 'etFile';
    etMainRecord:
      Result := 'etMainRecord';
    etGroupRecord:
      Result := 'etGroupRecord';
    etSubRecord:
      Result := 'etSubRecord';
    etSubRecordStruct:
      Result := 'etSubRecordStruct';
    etSubRecordArray:
      Result := 'etSubRecordArray';
    etSubRecordUnion:
      Result := 'etSubRecordUnion';
    etArray:
      Result := 'etArray';
    etStruct:
      Result := 'etStruct';
    etValue:
      Result := 'etValue';
    etFlag:
      Result := 'etFlag';
    etStringListTerminator:
      Result := 'etStringListTerminator';
    etUnion:
      Result := 'etUnion';
    etStructChapter:
      Result := 'etStructChapter';
  end; 
end;

function VarTypToStr(v : Variant): string;
begin
 Case varType(v) of
    varEmpty:
        Result := 'Empty';
    varNull:
        Result := 'Null';
    varSingle:
        Result := 'Single';
    varDouble:
        Result := 'Double';
    varCurrency:
        Result := 'Currency';
    varDate:
        Result := 'Date';
    varOleStr:
        Result := 'UnicodeString';
    varStrArg:
        Result := 'COM-compatible string';
    varString:
        Result := 'Pointer to a dynamic string';
    varDispatch:
        Result := 'Pointer to an Automation object';
    varBoolean:
        Result := 'Wordbool';
    varVariant:
        Result := 'Variant';
    varUnknown:
        Result := 'unknown';
    varShortInt:
        Result := 'ShortInt';
    varSmallint:
        Result := 'Smallint';
    varInteger:
        Result := 'Integer';
    varInt64:
        Result := 'Int64';
    varByte:
        Result := 'Byte';
    varWord:
        Result := 'Word';
    varLongWord:
        Result := 'LongWord';
    varError:
        Result := 'ERROR determining variant type';
 else
   Result := 'Unable to determine variant type';
 end;
end;

function DebugPrintElemRec(oldElem: IwbElement): IwbElement;
var
  oldItem: IwbElement;
  i : integer;
begin
  for i:=0 to ElementCount(oldElem)-1 do begin
    oldItem := ElementByIndex(oldElem, i);
    //newItem := ElementByIndex(newElem, i);
    //newItem := ElementByIndex(newItem, i);
    AddMessage(ElementTypeStr(oldItem)+' :: '+VarTypToStr(GetNativeValue(oldItem)) +' : '+FullPath(oldItem) + ' = '+GetEditValue(oldItem)+' -> '+EditorID(LinksTo(oldItem)));
    DebugPrintElemRec(oldItem);      
  end;
  //Result := newElem;
end;


function AddMasterDependencies(src, dst: IwbFile): integer;
begin
    AddMasterDependenciesExclusive(src, dst);
    AddMasterIfMissing(dst, GetFileName(src));
end;

function AddMasterDependenciesExclusive(src, dst: IwbFile): integer;
var
    i: integer;
    m: IwbFile;
begin
    for i := 0 to MasterCount(src)-1 do begin
        m := MasterByIndex(src, i);
        if not Assigned(m) then begin raise Exception.Create('unreachable '+GetFileName(src)+' '+IntToStr(i)); end;
        AddMasterIfMissing(dst, GetFileName(m));
        AddMasterDependencies(m, dst);
    end;
end;
function CopyOverAllNPCs(src, dst: IwbFile; modifyNpcs: Boolean): integer;
var
    srcNpcGrp: IwbGroupRecord;
    dstNpcGrp: IwbGroupRecord;
    srcRec: IwbMainRecord;
    dstRec: IwbMainRecord;
    i:integer;
begin
    if Assigned(src) then begin
        srcNpcGrp := GroupBySignature(src, 'NPC_');
        dstNpcGrp := GroupBySignature(dst, 'NPC_');
        if not Assigned(dstNpcGrp) then begin raise Exception.Create('No NPC_ in '+GetFileName(dst)); end;
        if Assigned(srcNpcGrp) then begin
            AddMessage('Copying NPCs from '+GetFileName(src)+' to '+GetFileName(dst));
            AddMasterDependencies(src, dst);
            for i:=0 to ElementCount(srcNpcGrp)-1 do begin
                srcRec := ElementByIndex(srcNpcGrp, i);
                if not Assigned(MainRecordByEditorID(dstNpcGrp, EditorID(srcRec))) then begin
                    if isFemale(srcRec) then begin
                        dstRec := wbCopyElementToFile(srcRec, dst, false, true);
                        if Signature(dstRec) <> 'NPC_' then begin
                            raise Exception.Create('unreachable '+GetFileName(src)+' : '+FullPath(srcRec)+' -> '+FullPath(dstRec));
                        end;
                        if modifyNpcs then begin
                            RecursiveCopyNPC(dstRec, false);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function AddAllBooksToLVLI(dst: IwbFile; clb: TCheckListBox): integer;
var
    src: IwbFile;
    srcGrp: IwbGroupRecord;
    dstGrp: IwbGroupRecord;
    srcRec: IwbMainRecord;
    dstRec: IwbMainRecord;
    bookLvli: IwbMainRecord;
    bookList: IwbElement;
    i:integer;
    j: integer;
    group: string;
    newlyCreated: Boolean;
begin
    group := 'BOOK';
    dstGrp := GroupBySignature(dst, group);
    if not Assigned(dstGrp) then begin 
        dstGrp := Add(dst, group, true);
    end;
    bookLvli := MainRecordByEditorID(GroupBySignature(dst, 'LVLI'), 'LItemBookSexy');
    newlyCreated := not Assigned(bookLvli);
    if newlyCreated then begin
        AddMasterDependencies(fileSkyrim, dst);
        bookLvli := getOrCopy(fileSkyrim, dst, 'LVLI', 'LItemBook4All', false);
        bookList := ElementByPath(bookLvli, 'Leveled List Entries');
        bookLvli := getOrCreateLVLI(dst, 'LItemBookSexy', '0', '0', '0', '0');
        assignToLVLI(bookList, bookLvli, '1', '1');
    end;
    if Signature(bookLvli) <> 'LVLI' then begin raise Exception.Create('Book lvli not LVLI. Is '+FullPath(bookLvli)) end;    
    bookList := Add(bookLvli, 'Leveled List Entries', true);
    if not Assigned(bookList) then begin raise Exception.Create('Book list nil: '+FullPath(bookLvli)) end;    
    for i := 0 to Pred(clb.Items.Count) do begin
        if clb.Checked[i] then begin
            src := ObjectToElement(clb.Items.Objects[i]);
            srcGrp := GroupBySignature(src, group);
            if Assigned(srcGrp) then begin 
                AddMasterDependencies(src, dst);
                for i:=0 to ElementCount(srcGrp)-1 do begin
                    srcRec := ElementByIndex(srcGrp, i);
                    AddMessage('Adding book '+FullPath(srcRec)+' to '+FullPath(bookList));
                    assignToLVLI(bookList, srcRec, '1', '1');
                end;
            end;
        end;
    end;
    if newlyCreated then begin
        RemoveByIndex(bookList, 0, true);
    end;
end;
function getOrCopyByRef(srcElem:IwbMainRecord; dstFile:IwbFile; asNew:Boolean):IwbMainRecord;
var
    dstGrp: IwbGroupRecord;
begin
    if Assigned(srcElem) then begin
        dstGrp := GroupBySignature(dstFile, Signature(srcElem));
        Result := MainRecordByEditorID(dstGrp, EditorId(srcElem));
        if not Assigned(Result) then begin
            if asNew then begin
                AddMessage('Copying '+FullPath(srcElem)+' to '+GetFileName(dstFile));
            end else begin
                AddMessage('Overriding '+FullPath(srcElem)+' in '+GetFileName(dstFile));
            end
            Result := wbCopyElementToFile(srcElem, dstFile, asNew, true);
            // if asNew then begin 
            //     SetLoadOrderFormID(Result, GetLoadOrderFormID(srcElem));
            // end;
        end;
        if not Assigned(Result) then begin raise Exception.Create('unreachable') end;
    end;
end;
function getOrCopy(srcFile, dstFile:IwbFile; group, editorId:string; asNew:Boolean):IwbMainRecord;
var
    srcGrp: IwbGroupRecord;
begin
    srcGrp := GroupBySignature(srcFile, group);
    if not Assigned(srcGrp) then begin raise Exception.Create('No '+group+' in '+GetFileName(srcFile)) end;
    Result := MainRecordByEditorID(srcGrp, editorId);
    if not Assigned(Result) then begin raise Exception.Create('No '+group+' '+editorId+' in '+GetFileName(srcFile)) end;
    Result := getOrCopyByRef(Result, dstFile, asNew);
    if not Assigned(Result) then begin raise Exception.Create('unreachable') end;
end;
function OverrideOutfit(src, dst: IwbFile; otftId: string): IwbMainRecord;
var
    srcOtft: IwbGroupRecord;
begin
    if Assigned(src) then begin
        srcOtft := MainRecordByEditorID(GroupBySignature(src, 'OTFT'), otftId);
        if not Assigned(srcOtft) then begin raise Exception.Create('Outfit not found '+otftId+' in '+GetFileName(src)) end;
        Result := getOrCopyByRef(srcOtft, dst, false);
        if not Assigned(Result) then begin raise Exception.Create('unreachable') end;
        ModifyFemaleOutfit(srcOtft, Result);
    end;
end;

function IsAnyChecked(clb: TCheckListBox): Boolean;
var 
    i: integer;
begin
    Result := false;
    for i := 0 to Pred(clb.Items.Count) do begin
        if clb.Checked[i] then begin
            Result := true;
            exit;
        end;
    end;
end;
function GenerateSmash(newFileName: string; clb: TCheckListBox; makeSmash: Boolean): IwbFile;
var 
    npcFile: IwbFile;
    i: integer;
    modifyNpcs: Boolean;
    rebWorth: Boolean;
    nakedStart: Boolean;
begin
    AddMessage('Creating new mod:'+newFileName);
    Result := AddNewFileName(newFileName);
    if not Assigned(Result) then begin raise Exception.Create('unreachable'); end;
    Add(Result, 'OTFT', true);
    Add(Result, 'NPC_', true);

    // the order matters. Once a record has been copied it is not overwritten again.
    // So the patches should come first before the original mods. Skyrim.esm comes last. 
    if Assigned(ObjectToElement(clb.Items.Objects[0])) then begin raise Exception.Create('unreachable. This should be a special element'); end;
    modifyNpcs := not clb.Checked[0];
    nakedStart := clb.Checked[1];
    rebWorth := clb.Checked[3]; // TODO rebalance item value
    if modifyNpcs then begin
        SetupRecordGroups(Result);
        if nakedStart then begin
            implNakedStart(Result);
        end;
        generateLvlListsAndEnchArmorForClothingMods(Result, makeSmash);
    end;
    for i := 1 to Pred(clb.Items.Count) do begin
        if clb.Checked[i] then begin
            npcFile := ObjectToElement(clb.Items.Objects[i]);
            CopyOverAllNPCs(npcFile, Result, modifyNpcs);
        end;
    end;
    if Assigned(npcFileMiasL) then begin
        AddMasterDependencies(npcFileMiasL, Result);
        OverrideOutfit(npcFileMiasL, Result, 'AQSS_MiaClothedSlave');
    end;
end;
function implNakedStart(destFile: IwbFile): integer;
var
    elems: IwbElement;
    props: IwbElement;
    qust: IwbMainRecord;
    i: integer;
begin
    AddMasterDependencies(fileAlternateStart, destFile);
    qust := getOrCopy(fileAlternateStart, destFile, 'QUST', 'MQ101', false);
    if not Assigned(qust) then begin raise Exception.Create('unreachableE') end;
    elems := ElementByPath(qust, 'Aliases');
    if not Assigned(elems) then begin raise Exception.Create('unreachableA') end;
    elems := ElementByIndex(elems, 1);
    if not Assigned(elems) then begin raise Exception.Create('unreachableB') end;
    elems := ElementByPath(elems, 'Items');
    if not Assigned(elems) then begin raise Exception.Create('unreachableC') end;
    for i := 0 to ElementCount(elems) do begin
        SetElementEditValues(ElementByIndex(elems, i), 'CNTO\Count', '0');
    end;
    elems := ElementByPath(qust, 'VMAD\Scripts');
    if not Assigned(elems) then begin raise Exception.Create('unreachableG') end;
    elems := ElementByIndex(elems, 2);
    if not Assigned(elems) then begin raise Exception.Create('unreachableH') end;
    props := ElementByPath(elems, 'Properties');
    if not Assigned(props) then begin raise Exception.Create('unreachableI') end;
    elems := ElementByIndex(props, 175);
    if not Assigned(elems) then begin raise Exception.Create('unreachableJ') end;
    elems := ElementByPath(elems, 'Value\Object Union\Object v2\FormID');
    if not Assigned(elems) then begin raise Exception.Create('unreachableK') end;
    if EditorID(LinksTo(elems)) <> 'ClothesPrisonerTunic' then begin raise Exception.Create('expected ClothesPrisonerTunic but was '+EditorID(LinksTo(elems))) end;
    SetEditValue(elems, nil);
    elems := ElementByIndex(props, 176);
    if not Assigned(elems) then begin raise Exception.Create('unreachableJ') end;
    elems := ElementByPath(elems, 'Value\Object Union\Object v2\FormID');
    if not Assigned(elems) then begin raise Exception.Create('unreachableK') end;
    if EditorID(LinksTo(elems)) <> 'ClothesPrisonerShoes' then begin raise Exception.Create('expected ClothesPrisonerShoes but was '+EditorID(LinksTo(elems))) end;
    SetEditValue(elems, nil);

    AddMasterDependencies(fileSkyrim, destFile);
    elems := getOrCopy(fileSkyrim, destFile, 'NPC_', 'Player', false);
    RemoveElement(elems, 'DOFT');
    ClearNpcItems(elems);
end;
function FileByName(fn: string): IwbFile;
var
    i: integer;
    f: IwbFile;
    fname: string;
begin
    for i := 0 to Pred(FileCount) do begin
        f := FileByIndex(i);
        fname := GetFileName(f);
        if fname = fn then begin
            Result := f;
            exit;
        end;
    end;
end;
function createLVLI(destFile: IwbFile; eID, lvld, useAll, calcEach, calcLvl:string): IwbMainRecord;
begin
    Result := Add(GroupBySignature(destFile, 'LVLI'), 'LVLI', true);
    SetEditorID(Result, eID);
    SetElementEditValues(Result, 'LVLD', lvld);
    SetElementEditValues(Result, 'LVLF\Calculate from all levels <= player''s level', calcLvl);
    SetElementEditValues(Result, 'LVLF\Calculate for each item in count', calcEach);
    SetElementEditValues(Result, 'LVLF\Use All', useAll);
end;
function getOrCreateLVLI(destFile: IwbFile; eID, lvld, useAll, calcEach, calcLvl:string): IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(destFile,'LVLI'), eID);
    if Assigned(Result) then begin
        exit;
    end;
    Result := createLVLI(destFile, eID, lvld, useAll, calcEach, calcLvl);
end;
function newLVLI(e:IwbElement; destFile: IwbFile; eID, lvld, useAll, calcEach, calcLvl:string): IwbElement;
begin
    if Assigned(e) then RemoveByIndex(e, 0, true);
    if Assigned(MainRecordByEditorID(GroupBySignature(destFile,'LVLI'), eID)) then begin
        exit;
    end;
    Result := Add(createLVLI(destFile, eID, lvld, useAll, calcEach, calcLvl), 'Leveled List Entries', true);
end;
function assignToCont(e: IwbElement; ref: IwbMainRecord; count:string): IwbElement;
begin
    if not Assigned(e) then begin
        raise Exception.Create('nothing to assign to. Ref='+FullPath(ref));
    end;
    if not Assigned(ref) then begin
        raise Exception.Create('Tried to assign nil to '+FullPath(e));
    end;
    Result := ElementByPath(e, 'Items');
    if Assigned(Result) then begin
        Result := Add(Result, 'Item', true);
    end else begin
        Result := Add(e, 'Items', true);
        Result := ElementByIndex(Result, 0);
    end;
    if not Assigned(Result) then begin
        raise Exception.Create('unreachable '+FullPath(e));
    end;
    Result := Add(Result, 'CNTO', true);
    if not Assigned(Result) then begin
        raise Exception.Create('unreachable '+FullPath(e));
    end;
    AddMessage('CONT '+Name(ref)+' -> '+FullPath(Result));
    e := ElementByPath(Result, 'Item');
    if not Assigned(e) then begin
        raise Exception.Create('unreachable '+FullPath(Result));
    end;
    ElementAssign(e, LowInteger, ref, false);
    if GetEditValue(e) <>  Name(ref) then begin raise Exception.Create('failed assign '+FullPath(e)+' = '+GetEditValue(e)+' <> '+FullPath(ref)); end;
    e := ElementByPath(Result, 'Count');
    if not Assigned(e) then begin
        raise Exception.Create('unreachable '+FullPath(Result));
    end;
    SetEditValue(e, count);
end;
function addToCont(e: IwbElement; filename: IwbFile; signat, ref, count:string): IwbMainRecord;
var
    r: IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(filename, signat), ref);
    if not Assigned(Result) then begin
        raise Exception.Create('Element not found: '+GetFileName(filename)+' '+signat+' '+ref);
    end;
    assignToCont(e, Result, count);
end;
function assignToLVLI(e: IwbElement; ref: IwbMainRecord; count, level:string): IwbElement;
begin
    if not Assigned(e) then begin exit; end;
    if not Assigned(ref) then begin
        raise Exception.Create('Tried to assign nil to '+FullPath(e));
    end;
    Result := Add(e, 'Leveled List Entry', true);
    if not Assigned(Result) then begin
        raise Exception.Create('unreachable '+FullPath(e)+' , '+Name(ref));
    end;
    AddMessage('LVLI (asgn) '+Name(ref)+' -> '+FullPath(Result));
    SetElementEditValues(Result, 'LVLO\Reference', Name(ref));
    SetElementEditValues(Result, 'LVLO\Count', count);
    SetElementEditValues(Result, 'LVLO\Level', level);
    if GetElementEditValues(Result, 'LVLO\Reference') <>  Name(ref) then begin raise Exception.Create('failed lvli assign '+FullPath(Result)+' = '+GetElementEditValues(Result, 'LVLO\Reference')+' <> '+FullPath(ref)); end;
end;
function addToLVLI(e: IwbElement; filename: IwbFile; signat, ref, count, level:string): IwbMainRecord;
var
    r: IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(filename, signat), ref);
    if not Assigned(Result) then begin
        raise Exception.Create('Element not found: '+GetFileName(filename)+' '+signat+' '+ref);
    end;
    assignToLVLI(e, Result, count, level);
end;
function addToLVLIMaybe(e: IwbElement; filename: IwbFile; signat, ref, count, level:string): IwbMainRecord;
var
    r: IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(filename, signat), ref);
    if Assigned(Result) then begin
        assignToLVLI(e, Result, count, level);
    end;
end;

function EnchId(level: string; magic_type:string): string; 
begin
    Result := 'EnchRobesCollege';
    if level = 'Novice' then ench_lvl = 1;
    else if level = 'Apprentice' then ench_lvl = 2;
    else if level = 'Adept' then ench_lvl = 3;
    else if level = 'Expert' then ench_lvl = 4;
    else if level = 'Master' then ench_lvl = 5;
    else begin
        Result := 'EnchRobesFortify';
        if level = 'Minor' then ench_lvl = 1;
        else if level = '' then ench_lvl = 2;
        else if level = 'Major' then ench_lvl = 3;
        else if level = 'Eminent' then ench_lvl = 4;
        else if level = 'Extreme' then ench_lvl = 5;
        else if level = 'Peerless' then ench_lvl = 6;
        else raise Exception.Create('Undefined magic level '+level);
    end;
    Result := Result + magic_type + '0' + IntToStr(ench_lvl);
end;
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/// THIS PART IS AUTO-GENERATED WITH THE serialize.pas SCRIPT
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
function GenerateEnchantedItemMaybe_(destFile, originalFile: IwbFile;oldItemId, newItemId, newName, ench:string): IwbMainRecord;
var
    template: IwbMainRecord;
    enchR: IwbMainRecord;
begin
    if oldItemId = newItemId then begin 
        raise Exception.Create('old and new id is the same: '+oldItemId);
    end;
    Result := MainRecordByEditorID(GroupBySignature(destFile, 'ARMO'), newItemId);
    if not Assigned(Result) then begin
        template := MainRecordByEditorID(GroupBySignature(originalFile, 'ARMO'), oldItemId);
        if Assigned(template) then begin
            enchR := MainRecordByEditorID(GroupBySignature(fileSkyrim, 'ENCH'), ench);
            if not Assigned(enchR) then begin 
                raise Exception.Create('Undefined enchantment '+ench);
            end;
            Result := wbCopyElementToFileWithPrefix(template, destFile, true, true, '', '', '');
            SetEditorID(Result, newItemId);
            SetElementEditValues(Result, 'TNAM', Name(template));
            SetElementEditValues(Result, 'EITM', Name(enchR));
            AddMessage('ENCH '+EditorID(Result)+' from '+FullPath(template));
            SetElementEditValues(Result, 'FULL', GetElementEditValues(template, 'FULL')+newName);
        end;
    end;
end;
function GenerateEnchantedItemMaybe(destFile, originalFile: IwbFile;oldItemId, newItemId, magic_type, ench:string): IwbMainRecord;
begin
    if magic_type = 'MagickaRate' then begin
        Result := GenerateEnchantedItemMaybe_(destFile, originalFile, oldItemId, newItemId+magic_type, '', ench);
    end else begin
        Result := GenerateEnchantedItemMaybe_(destFile, originalFile, oldItemId, newItemId+magic_type, ' of '+magic_type, ench);
    end;
end;
function GenerateEnchantedItem(destFile, originalFile: IwbFile;oldItemId, newItemId, magic_type, ench:string): IwbMainRecord;
begin
    Result := GenerateEnchantedItemMaybe(destFile, originalFile, oldItemId, newItemId, magic_type, ench);
    if not Assigned(Result) then begin 
        raise Exception.Create('Armor '+oldItemId+' not found in '+GetFileName(originalFile));
    end;
end;
function GenerateEnchantedItem_(destFile, originalFile: IwbFile;oldItemId, newItemId, newName, ench:string): IwbMainRecord;
begin
    Result := GenerateEnchantedItemMaybe_(destFile, originalFile, oldItemId, newItemId, newName, ench);
    if not Assigned(Result) then begin 
        raise Exception.Create('Armor '+oldItemId+' not found in '+GetFileName(originalFile));
    end;
end;

function GenerateModularMagePanty(destFile: IwbFile; templateSuffix, level, magic_type, ench:string): IwbMainRecord;
begin
    Result := GenerateEnchantedItemMaybe(destFile, fileModularMage, '_ModularMage'+level+templateSuffix, '_ModularMage'+level+templateSuffix, magic_type, ench);
end;

function GenerateModularMagePantiesForMagicTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type, ench:string): IwbElement;
var
    i:integer;
    newEnchanted: IwbMainRecord;
begin
    e := newLVLI(e, destFile, 'MM_'+level+'MagePanties'+magic_type, '0', '0', '1', '1');
    newEnchanted := GenerateModularMagePanty(destFile, 'StringThong', level, magic_type, ench);
    if not Assigned(newEnchanted) then begin
        raise Exception.Create('Couldn''t find _ModularMage'+level+'StringThong in '+GetFileName(fileModularMage));
    end;
    assignToLVLI(e, newEnchanted, '1', '1');
    for i:= 1 to 8 do begin
        newEnchanted := GenerateModularMagePanty(destFile, 'Panties'+IntToStr(i), level, magic_type, ench);
        if Assigned(newEnchanted) then begin
            assignToLVLI(e, newEnchanted, '1', '1');
        end;
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSkirtCurtain'+magic_type, '0', '0', '1', '1');
    for  i:= 1 to 3 do begin
        newEnchanted := GenerateModularMagePanty(destFile, 'Skirt'+IntToStr(i), level, magic_type, ench);
        if Assigned(newEnchanted) then begin
            assignToLVLI(e, newEnchanted, '1', '1');
        end;
    end;
    Result := e;
end;

function GenerateKSOEnchantedItem(destFile: IwbFile; oldItemId, magic_type, ench:string): IwbMainRecord;
begin
    Result := GenerateEnchantedItem(destFile, fileKSOMage, oldItemId, 'KSO'+oldItemId, magic_type, ench);
end;

function GenerateKSOForMagicTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    enchItem: IwbMainRecord;
begin
    e := newLVLI(e, destFile, 'KSO_'+level+'Robes'+magic_type, '0', '0', '1', '1');
    enchItem := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'UltraSkimpy', magic_type, 'EnchRobesCollege'+magic_type+'0'+IntToStr(levelNum));
    addToLVLI(e, destFile, 'ARMO', EditorID(enchItem), '1', '1');
    enchItem := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'UltraSkimpy2', magic_type, 'EnchRobesCollege'+magic_type+'0'+IntToStr(levelNum));
    addToLVLI(e, destFile, 'ARMO', EditorID(enchItem), '1', '1');

    e := newLVLI(e, destFile, 'KSO_'+magic_type+IntToStr(levelNum), '0', '1', '0', '0');
    addToLVLIMaybe(e, destFile, 'LVLI', 'KSO_'+level+'Hood', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'KSO_'+level+'Robes'+magic_type, '1', '1');
    if Assigned(fileModularMage) then begin
        addToLVLI(e, destFile, 'LVLI', 'MM_JourneymanHH', '1', '1');
    end else begin
        addToLVLI(e, fileUSSEP, 'LVLI', 'ClothesMGBoots', '1', '1');
    end;
    Result := e;
end;
function GenerateKSOForMagicType(destFile: IwbFile; e:IwbElement; magic_type:string): IwbElement;
begin
    e := GenerateKSOForMagicTypeAndLevel(destFile, e, 'Novice', magic_type, 1);
    e := GenerateKSOForMagicTypeAndLevel(destFile, e, 'Apprentice', magic_type, 2);
    e := GenerateKSOForMagicTypeAndLevel(destFile, e, 'Adept', magic_type, 3);
    e := GenerateKSOForMagicTypeAndLevel(destFile, e, 'Expert', magic_type, 4);
    e := GenerateKSOForMagicTypeAndLevel(destFile, e, 'Master', magic_type, 5);
    Result := e;
end;
function GenerateKSOHood(destFile: IwbFile; e:IwbElement; level, levelNum:string): IwbElement;
var
    newEnch: IwbMainRecord;
    s: string;
begin
    
    
    e := newLVLI(e, destFile, 'KSO_'+level+'Hood', '50', '0', '0', '1');
    newEnch := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'Hood', 'MagickaRate', 'EnchArmorFortifyMagicka'+levelNum);
    addToLVLI(e, destFile, 'ARMO', EditorID(newEnch), '1', '1');
    if level = 'Adept' then begin s := '' end else begin s := 'e' end; // typo in original mod
    newEnch := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'HoodLower'+s+'d', 'MagickaRate', 'EnchArmorFortifyMagicka'+levelNum);
    addToLVLI(e, destFile, 'ARMO', EditorID(newEnch), '1', '1');
    Result := e;
end;
function GenerateKSO(destFile: IwbFile; e:IwbElement): IwbElement;
begin
    e:=GenerateKSOHood(destFile, e, 'Adept', '04');
    e:=GenerateKSOHood(destFile, e, 'Apprentice', '03');
    e:=GenerateKSOHood(destFile, e, 'Novice', '02');
    GenerateKSOEnchantedItem(destFile, '_ClothesMGRobesArchmage', 'MagickaRate', 'MGArchMageRobeEnchant');
    GenerateKSOEnchantedItem(destFile, '_ClothesMGRobesArchmage1Hooded', 'MagickaRate', 'MGArchMageRobeHoodedEnchant');
    e := newLVLI(e, destFile, 'KSO_Archmage', '0', '0', '0', '1');
    addToLVLI(e, fileKSOMage, 'ARMO', '_ClothesMGRobesArchmage', '1', '1');
    addToLVLI(e, fileKSOMage, 'ARMO', '_ClothesMGRobesArchmage1Hooded', '1', '1');
    e := GenerateKSOForMagicType(destFile, e, 'Conjuration');
    e := GenerateKSOForMagicType(destFile, e, 'Restoration');
    e := GenerateKSOForMagicType(destFile, e, 'Destruction');
    e := GenerateKSOForMagicType(destFile, e, 'Illusion');
    e := GenerateKSOForMagicType(destFile, e, 'Alteration');
    e := GenerateKSOForMagicType(destFile, e, 'MagickaRate');
    Result := e;
end;
function GenerateModularMage(destFile: IwbFile; e:IwbElement): IwbElement;
begin
    e := newLVLI(e, destFile, 'MM_JourneymanHH', '0', '0', '0', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMageJourneymanHighHeelShoes', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMageJourneymanHighHeelShoes2', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMageJourneymanHighHeelBoots2', '1', '1');
    e := GenerateModularMageForLevel(destFile, e, 'Novice', 1);
    e := GenerateModularMageForLevel(destFile, e, 'Apprentice', 2);
    e := GenerateModularMageForLevel(destFile, e, 'Adept', 3);
    e := GenerateModularMageForLevel(destFile, e, 'Expert', 4);
    e := GenerateModularMageForLevel(destFile, e, 'Master', 5);
    Result := e;
end;

function GenerateModularMageForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
begin
    e := newLVLI(e, destFile, 'MM_'+level+'MageStockings', '0', '0', '0', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Stockings1', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Stockings2', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Stockings3', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Stockings4', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Stockings5', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'JourneyBoots', '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageStockings', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_JourneymanHH', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageFootwear', '0', '0', '0', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Variant1ThighHighBoots', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'ThighHighBoots', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'StirrupSocks', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageBootsStockings', '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageStockings', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageFootwear', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageBootsNoStockings', '0', '0', '0', '1');
    addToLVLI(e, fileUSSEP, 'ARMO', 'ClothesMGBoots', '1', '1');
    addToLVLI(e, fileUSSEP, 'ARMO', 'ClothesWarlockBoots', '1', '1');
    addToLVLI(e, fileUSSEP, 'ARMO', 'ClothesCollegeBootsCommonVariant1', '1', '1');
    addToLVLI(e, fileUSSEP, 'ARMO', 'ClothesCollegeBootsApprenticeVariant1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'HighHeels', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'HighHeelBoots', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageBoots', '0', '0', '0', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBootsStockings', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'JourneyBoots', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBootsNoStockings', '1', '1');
    if levelNum > 3 then begin // things that only expert and master have
        e := newLVLI(e, destFile, 'MM_'+level+'MageCoat', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Coat', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatCollar', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatOpen', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatOpenCollar', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageCoatOpen', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatOpen', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatOpenCollar', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageCoatClosed', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Coat', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatCollar', '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSkirt', '0', '0', '0', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Skirt1', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Skirt2', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Skirt3', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Skirt4', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'MiniSkirt', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'TightSkirt', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageSkirtShorts', '0', '1', '0', '0');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'MiniSkirt', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Shorts', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageArms', '0', '0', '0', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Sleeves1', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Sleeves2', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Sleeves3', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Armwraps', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'ArmCuffs', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Sleeves4', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Sleeves5', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageTopNormal', '0', '0', '0', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Corset1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Corset2', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Corset3', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Harness1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Harness2', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Harness3', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Top1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Top2', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Top3', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Top4', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'BeltTop1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'BeltTop2', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Bikini1', '1', '1');
    addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Bikini2', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'WrapTopShirt', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'WrapTop', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Dress2', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'StringBra', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Dress1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Dress', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'NipCurtains', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Bra1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Bra2', '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageJacket', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Jacket', '1', '1');
        addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'JacketCollar', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageMantle', '0', '0', '0', '1');
        addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle1', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle3', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle2', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageMantleShash', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle1Sash', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle3Sash', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageTopless', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Pasties', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Sash', '1', '1');
    end else begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageJacket', '0', '0', '0', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Jacket', '1', '1');
        addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'JacketCollar', '1', '1');
        addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle1', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle3', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Mantle2', '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageCorset', '0', '0', '0', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Corset1Topless', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Corset2Topless', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Corset3Topless', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CorsetTopless1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CorsetTopless2', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageScarf', '0', '0', '0', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Scarf', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Scarf1', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Scarf2', '1', '1');
    addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Scarf3', '1', '1');
    e := GenerateModularMageForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
    e := GenerateModularMageForTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
    e := GenerateModularMageForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
    e := GenerateModularMageForTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
    e := GenerateModularMageForTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
    e := GenerateModularMageForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    Result := e;
end;

function GenerateModularMageForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    ench: string;
begin
    ench := 'EnchRobesCollege'+magic_type+'0'+IntToStr(levelNum);
    e := GenerateModularMagePantiesForMagicTypeAndLevel(destFile, e, level, magic_type, ench);
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottomCurtain'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Garterbelt', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'PelvisCurtains', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottomPanty'+magic_type, '0', '1', '0', '0');
    end else begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottom'+magic_type, '0', '1', '0', '0');
    end;    
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MagePanties'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirt', '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottomShorts', '0', '0', '0', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtShorts', '1', '1');
        addToLVLIMaybe(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Shorts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottom'+magic_type, '0', '0', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottomPanty'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottomShorts', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottomCurtain'+magic_type, '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Jacket'+magic_type, '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
    if levelNum > 3 then addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Mantle'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageMantle', '1', '1');
    end;
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Arms'+magic_type, '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
    if levelNum>3 then begin
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
    end else begin
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
    end;
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1ArmsMantle'+magic_type, '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
    if levelNum>3 then begin addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageJacket', '1', '1'); 
    end else begin addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageMantle', '1', '1'); end;
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
    if levelNum>3 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Coat'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCoatOpen', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        if Assigned(fileWizardHats) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1'+magic_type, '0', '0', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet1Arms'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet1Jacket'+magic_type, '1', '1');
    addToLVLIMaybe(e, destFile, 'LVLI', 'MM_'+level+'MageSet1Coat'+magic_type, '1', '1');
    addToLVLIMaybe(e, destFile, 'LVLI', 'MM_'+level+'MageSet1Mantle'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet1ArmsMantle'+magic_type, '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottom2'+magic_type, '0', '0', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottomCurtain'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2ArmsMantle'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageMantleShash', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Jacket'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Mantle'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageMantleShash', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2'+magic_type, '0', '0', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2Arms'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2ArmsMantle'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2Jacket'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2Mantle'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Jacket'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3ArmsScarf'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageScarf', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3JacketScarf'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageScarf', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3'+magic_type, '0', '0', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3Arms'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3Jacket'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3ArmsScarf'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3JacketScarf'+magic_type, '1', '1');
    end else begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        if Assigned(fileWizardHats) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageScarf', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Onepiece', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Garterbelt', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '_ModularMage'+level+'Skirt2'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Coat'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCoat', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Onepiece', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Garterbelt', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '_ModularMage'+level+'Skirt2'+magic_type, '1', '1');
        if Assigned(fileWizardHats) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2'+magic_type, '0', '0', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2Arms'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2Coat'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirt', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MagePanties'+magic_type, '1', '1');
        if Assigned(fileWizardHats) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'CoatCollar', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Harness3', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Coat'+magic_type, '0', '1', '0', '0');
        if Assigned(fileWizardHats) then addToLVLI(e, destFile, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSkirt', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MagePanties'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageCoatClosed', '1', '1');
        addToLVLI(e, fileModularMage, 'ARMO', '_ModularMage'+level+'Harness3', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3'+magic_type, '0', '0', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3Arms'+magic_type, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3Coat'+magic_type, '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+magic_type+IntToStr(levelNum), '0', '0', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet1'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet2'+magic_type, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'MM_'+level+'MageSet3'+magic_type, '1', '1');
    Result := e;
end;


function GenerateAnyMage(destFile: IwbFile; numOfLevels: integer; newPrefix, combinedPrefixes: string; minMagRateLvl, maxMagRateLvl:integer): string;
var
    i: integer;
    e: IwbMainRecord;
begin
    if pos('#', newPrefix) <> 0 then begin raise Exception.Create('newPrefix shouldn''t have hashtags: '+combinedPrefixes+' -> '+newPrefix+', e='+FullPath(e)); end;
    AddMessage('Combining (Mage prefixes) '+combinedPrefixes+' into '+newPrefix);
    for i := 1 to numOfLevels do begin
        e := GenerateAnyMageForLevel(destFile, newPrefix, combinedPrefixes, i, minMagRateLvl, maxMagRateLvl);
    end;
    if StartsStr(newPrefix, EditorID(e)) then begin
        Result := newPrefix;
    end else begin
        if combinedPrefixes[1] <> '#' then begin raise Exception.Create('unreachable: '+newPrefix+' -> '+combinedPrefixes); end;
        Result := copy(combinedPrefixes, 2, length(combinedPrefixes)-1);
    end;
    if pos('#', Result) <> 0 then begin raise Exception.Create('unreachable: '+combinedPrefixes+' -> '+newPrefix+', Result='+Result+', e='+FullPath(e)); end;
end;
function GenerateAnyMageForLevel(destFile: IwbFile; newPrefix, combinedPrefixes: string; levelNum, minMagRateLvl, maxMagRateLvl:integer): IwbMainRecord;
begin
    GenerateAnyMageForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Conjuration', levelNum);
    GenerateAnyMageForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Restoration', levelNum);
    GenerateAnyMageForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Destruction', levelNum);
    GenerateAnyMageForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Illusion', levelNum);
    if (levelNum > minMagRateLvl) and (levelNum < maxMagRateLvl) then begin
        GenerateAnyMageForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'MagickaRate', levelNum);
    end;
    Result := GenerateAnyMageForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Alteration', levelNum);
end;
function GenerateAnyMageForTypeAndLevel(destFile: IwbFile; newPrefix, combinedPrefixes, magic_type:string; levelNum:integer): IwbMainRecord;
begin
    Result := combineLVLI(destFile, newPrefix+magic_type+IntToStr(levelNum), combinedPrefixes, magic_type+IntToStr(levelNum));
end;


function GenerateExnemDemonEnchPanties(destFile: IwbFile; e:IwbElement; level, magic_type, color:string; levelNum:integer): IwbElement;
var
    ei_panties: IwbMainRecord;
    lvl:string;
    ench:string;
begin 
    lvl := IntToStr(levelNum);
    ench :='EnchRobesFortify'+magic_type+'0'+lvl;
    e := newLVLI(e, destFile, 'Exnem demon Lower '+color+' '+magic_type+lvl, '0', '0', '1', '0');  
    ei_panties := GenerateEnchantedItem(destFile, fileChristineExnem, '00ExnemDemonicLower'+color, 'Exnem demon Lower '+color+magic_type+lvl, magic_type, ench);
    addToLVLI(e, destFile, 'ARMO', EditorID(ei_panties), '1', '1');
    ei_panties := GenerateEnchantedItem(destFile, fileChristineExnem, '00ExnemDemonicLower'+color+'Alt', 'Exnem demon Lower '+color+' Alt'+magic_type+lvl, magic_type, ench);
    addToLVLI(e, destFile, 'ARMO', EditorID(ei_panties), '1', '1');
    Result := e;
end;
function GenerateExnemDemonEnchClothingTypeAndLevelColor(destFile: IwbFile; e:IwbElement; level, magic_type, color:string; levelNum:integer): IwbElement;
begin 
    e := GenerateExnemDemonEnchPanties(destFile, e, level, magic_type, '', levelNum);
    e := GenerateExnemDemonEnchPanties(destFile, e, level, magic_type, 'Black', levelNum);
    e := GenerateExnemDemonEnchPanties(destFile, e, level, magic_type, 'White', levelNum);
    e := newLVLI(e, destFile, 'Exnem demon'+color+magic_type+IntToStr(levelNum), '0', '1', '0', '0');  
    addToLVLI(e, destFile, 'LVLI', 'Exnem demon Boots '+color, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'Exnem demon Gauntlets '+color, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'Exnem demon Lower '+color+' '+magic_type+IntToStr(levelNum), '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'Exnem demon Thighs '+color, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'Exnem demon Upper '+color, '1', '1');
    Result := e;
end;

function GenerateExnemDemonEnchClothingTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
begin 
    e := GenerateExnemDemonEnchClothingTypeAndLevelColor(destFile, e, level, magic_type, '', levelNum);
    e := GenerateExnemDemonEnchClothingTypeAndLevelColor(destFile, e, level, magic_type, 'Black', levelNum);
    e := GenerateExnemDemonEnchClothingTypeAndLevelColor(destFile, e, level, magic_type, 'White', levelNum);  
    e := newLVLI(e, destFile, 'Exnem demon set '+magic_type+IntToStr(levelNum), '0', '0', '0', '0');  
    addToLVLI(e, destFile, 'LVLI', 'Exnem demon'+magic_type+IntToStr(levelNum), '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'Exnem demonBlack'+magic_type+IntToStr(levelNum), '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'Exnem demonWhite'+magic_type+IntToStr(levelNum), '1', '1');
end;

function GenerateExnemDemonEnchClothing(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
begin
    e := GenerateExnemDemonEnchClothingTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
    e := GenerateExnemDemonEnchClothingTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
    e := GenerateExnemDemonEnchClothingTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
    e := GenerateExnemDemonEnchClothingTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
    e := GenerateExnemDemonEnchClothingTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
    if (levelNum > 1) and (levelNum < 6) then begin
        e := GenerateExnemDemonEnchClothingTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    end;
    Result := e;
end;
function GenerateExnemDemonBodyPartAndColor(destFile: IwbFile; e:IwbElement; bodyPart, color:string): IwbElement;
begin 
    e := newLVLI(e, destFile, 'Exnem demon '+bodyPart+' '+color, '0', '0', '1', '0');  
    addToLVLI(e, fileChristineExnem, 'ARMO', '00ExnemDemonic'+bodyPart+color, '1', '1');
    addToLVLI(e, fileChristineExnem, 'ARMO', '00ExnemDemonic'+bodyPart+color+'Alt', '1', '1');
    Result := e;
end;
function GenerateExnemDemonClothingColor(destFile: IwbFile; e:IwbElement; color:String): IwbElement;
begin
    e := GenerateExnemDemonBodyPartAndColor(destFile, e, 'Boots', color);
    e := GenerateExnemDemonBodyPartAndColor(destFile, e, 'Gauntlets', color);
    e := GenerateExnemDemonBodyPartAndColor(destFile, e, 'Thighs', color);
    e := GenerateExnemDemonBodyPartAndColor(destFile, e, 'Upper', color);
    addToLVLI(e, fileChristineExnem, 'ARMO', '00ExnemDemonicUpperSlutty'+color, '1', '1');
    addToLVLI(e, fileChristineExnem, 'ARMO', '00ExnemDemonicUpperSlutty'+color+'Alt', '1', '1');
    Result := e;
end;

function GenerateExnemDemonClothing(destFile: IwbFile; e:IwbElement): IwbElement;
begin 
    e := GenerateExnemDemonClothingColor(destFile, e, '');
    e := GenerateExnemDemonClothingColor(destFile, e, 'Black');
    e := GenerateExnemDemonClothingColor(destFile, e, 'White');
    Result := e;
end;
function GenerateExnemDemon(destFile: IwbFile; e:IwbElement): IwbElement;
var
    s:string;
    i : integer;
begin
    e := GenerateExnemDemonClothing(destFile, e);
    e := GenerateExnemDemonEnchClothing(destFile, e, 'Minor', 1);
    e := GenerateExnemDemonEnchClothing(destFile, e, 'Common', 2);
    e := GenerateExnemDemonEnchClothing(destFile, e, 'Major', 3);
    e := GenerateExnemDemonEnchClothing(destFile, e, 'Eminent', 4);
    e := GenerateExnemDemonEnchClothing(destFile, e, 'Extreme', 5);
    e := GenerateExnemDemonEnchClothing(destFile, e, 'Peerless', 6);
    Result := e;
end;


function GenerateCocoDemon(destFile: IwbFile; e:IwbElement): IwbElement;
var
    s:string;
    i : integer;
begin
    for i := 1 to 5 do begin 
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO demon'+s+' hair80', '90', '0', '0', '0');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_hairsmp'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+' mask60', '70', '0', '0', '0');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_mask'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+' horn60', '70', '0', '0', '0');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_horn'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+' tail60', '70', '0', '0', '0');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_tail'+s, '1', '1');
        
    end;
    e := GenerateCocoDemonForLevel(destFile, e, 'Minor', 1);
    e := GenerateCocoDemonForLevel(destFile, e, 'Common', 2);
    e := GenerateCocoDemonForLevel(destFile, e, 'Major', 3);
    e := GenerateCocoDemonForLevel(destFile, e, 'Eminent', 4);
    e := GenerateCocoDemonForLevel(destFile, e, 'Extreme', 5);
    e := GenerateCocoDemonForLevel(destFile, e, 'Peerless', 6);
    Result := e;
end;
function GenerateCocoDemonForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
begin
    e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
    e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
    e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
    e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
    e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
    if (levelNum > 1) and (levelNum < 6) then begin
        e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    end;
    Result := e;
end;
function GenerateCocoDemonForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    s:string;
    lvl:string;
    ei: IwbMainRecord;
    ei_panties: IwbMainRecord;
    ench:string;
    i:integer;
begin
    lvl := IntToStr(levelNum);
    ench :='EnchRobesFortify'+magic_type+'0'+lvl;
    for i := 1 to 5 do begin 
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO demon'+s+' modular '+magic_type+lvl, '0', '1', '0', '0');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_bra'+s, '1', '1');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_glove'+s, '1', '1');
        ei_panties := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_panties'+s, 'Demon_panties'+s+lvl, magic_type, ench);
        addToLVLI(e, destFile, 'ARMO', EditorID(ei_panties), '1', '1');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_stock'+s, '1', '1');

        e := newLVLI(e, destFile, 'COCO demon'+s+' two parts '+magic_type+lvl, '0', '1', '0', '0');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_bodybra'+s, 'Demon_bodybra'+s+lvl, magic_type, ench);
        addToLVLI(e, destFile, 'ARMO', EditorID(ei), '1', '1');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_bodystock'+s, '1', '1');
        addToLVLI(e, destFile, 'ARMO', EditorID(ei_panties), '1', '1');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_glove'+s, '1', '1');

        e := newLVLI(e, destFile, 'COCO demon'+s+' full body'+magic_type+lvl, '0', '0', '1', '0');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_bodyfucool'+s, 'Demon_bodyfucool'+s+lvl, magic_type, ench);
        addToLVLI(e, destFile, 'ARMO', EditorID(ei), '1', '1');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_bodyfu'+s, 'Demon_bodyfu'+s+lvl, magic_type, ench);
        addToLVLI(e, destFile, 'ARMO', EditorID(ei), '1', '1');

        e := newLVLI(e, destFile, 'COCO demon body'+s+magic_type+lvl, '0', '0', '1', '0');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' full body'+magic_type+lvl, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' two parts '+magic_type+lvl, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' modular '+magic_type+lvl, '1', '1');

        e := newLVLI(e, destFile, 'COCO demon'+s+magic_type+lvl, '0', '1', '0', '0');
        //addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_hair'+s, '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' tail60', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' horn60', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' mask60', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon'+s+' hair80', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO demon body'+s+magic_type+lvl, '1', '1');
        addToLVLI(e,fileCocoDemon, 'ARMO', 'Demon_heels'+s, '1', '1');
    end;
    e := newLVLI(e, destFile, 'COCO demon'+magic_type+lvl, '0', '0', '1', '0');
    addToLVLI(e, destFile, 'LVLI', 'COCO demon1'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO demon2'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO demon3'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO demon4'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO demon5'+magic_type+lvl, '1', '1');
    Result := e;
end;

function GenerateCocoWitch(destFile: IwbFile; e:IwbElement): IwbElement;
var
    s:string;
    i:integer;
begin
    for i := 1 to 4 do begin
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO witch'+s+' neck', '0', '0', '0', '0');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_neckA'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_neckB'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+' stock', '0', '0', '0', '0');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_stockB'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_stockA'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_stockB'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_stockA'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_stockA5', '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_stockA6', '1', '1'); 
        e := newLVLI(e, destFile, 'COCO witch'+s+' skirt', '0', '0', '0', '0');
        addToLVLIMaybe(e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s+'tou', '1', '1');
        addToLVLIMaybe(e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s+'po', '1', '1');
        addToLVLIMaybe(e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+' belt', '0', '0', '0', '0');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_beltlow'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_beltup'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+' bra', '0', '0', '0', '0');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_bra'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_bra'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_bra'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_bra5', '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_bra6', '1', '1');
    end;
    e := GenerateCocoWitchForLevel(destFile, e, 'Minor', 1);
    e := GenerateCocoWitchForLevel(destFile, e, 'Common', 2);
    e := GenerateCocoWitchForLevel(destFile, e, 'Major', 3);
    e := GenerateCocoWitchForLevel(destFile, e, 'Eminent', 4);
    e := GenerateCocoWitchForLevel(destFile, e, 'Extreme', 5);
    e := GenerateCocoWitchForLevel(destFile, e, 'Peerless', 6);
    Result := e;
end;
function GenerateCocoWitchForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
begin
    e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
    e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
    e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
    e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
    e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
    if (levelNum > 1) and (levelNum < 6) then begin
        e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    end;
    Result := e;
end;
function GenerateCocoWitchForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    s:string;
    lvl:string;
    ei: IwbMainRecord;
    ench:string;
    i:integer;
begin
    lvl := IntToStr(levelNum);
    ench :='EnchRobesFortify'+magic_type+'0'+lvl;
    GenerateEnchantedItem(destFile, fileCocoWitch, 'Witchi_pants5', 'Witchi_pants5'+lvl, magic_type, ench);
    GenerateEnchantedItem(destFile, fileCocoWitch, 'Witchi_pants6', 'Witchi_pants6'+lvl, magic_type, ench);
    for i := 1 to 4 do begin
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO witch'+s+' pants'+magic_type+lvl, '0', '0', '1', '0');
        GenerateEnchantedItem(destFile, fileCocoWitch, 'Witchi_pants'+s, 'Witchi_pants'+s+lvl, magic_type, ench);
        addToLVLI(e, destFile, 'ARMO', 'Witchi_pants'+s+lvl+magic_type, '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Witchi_pants'+s+lvl+magic_type, '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Witchi_pants'+s+lvl+magic_type, '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Witchi_pants5'+lvl+magic_type, '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Witchi_pants6'+lvl+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+magic_type+lvl, '0', '1', '0', '0');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'WitchiRing1', '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_shoes'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_glovel'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_knee'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_sho'+s, '1', '1');
        addToLVLI(e, fileCocoWitch, 'ARMO', 'Witchi_glover'+s, '1', '1');
        addToLVLI(e, destFile, 'LVLI',  'COCO witch'+s+' bra', '1', '1');
        addToLVLI(e, destFile, 'LVLI',  'COCO witch'+s+' pants'+magic_type+lvl, '1', '1');
        addToLVLI(e, destFile, 'LVLI',  'COCO witch'+s+' neck', '1', '1');
        addToLVLI(e, destFile, 'LVLI',  'COCO witch'+s+' stock', '1', '1');
        addToLVLI(e, destFile, 'LVLI',  'COCO witch'+s+' skirt', '1', '1');
        addToLVLI(e, destFile, 'LVLI',  'COCO witch'+s+' belt', '1', '1');
    end;
    e := newLVLI(e, destFile, 'COCO witch'+magic_type+lvl, '0', '0', '1', '0');
    addToLVLI(e, destFile, 'LVLI', 'COCO witch1'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO witch2'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO witch3'+magic_type+lvl, '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'COCO witch4'+magic_type+lvl, '1', '1');
    Result := e
end;
function GenerateDeadlyDesire(destFile: IwbFile; e:IwbElement): IwbElement;
begin
    e := GenerateDeadlyDesireForLevel(destFile, e, 'Minor', 1);
    e := GenerateDeadlyDesireForLevel(destFile, e, 'Common', 2);
    e := GenerateDeadlyDesireForLevel(destFile, e, 'Major', 3);
    e := GenerateDeadlyDesireForLevel(destFile, e, 'Eminent', 4);
    e := GenerateDeadlyDesireForLevel(destFile, e, 'Extreme', 5);
    e := GenerateDeadlyDesireForLevel(destFile, e, 'Peerless', 6);
    Result := e;
end;
function GenerateDeadlyDesireForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
begin
    e := GenerateDeadlyDesireForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
    e := GenerateDeadlyDesireForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
    if (levelNum > 1) and (levelNum < 6) then begin
        e := GenerateDeadlyDesireForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    end;
    Result := e;
end;
function GenerateDeadlyDesireForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    s:string;
begin
    s := IntToStr(levelNum);
    GenerateEnchantedItem_(destFile, fileChristineDeadlyDesire, '00DDPanty', '00DDPanty'+magic_type+s, '', 'EnchRobesFortify'+magic_type+'0'+s);
    e := newLVLI(e, destFile, 'CHDD Set Ench'+magic_type+s, '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'CHDD Upper', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'CHDD Shoulder', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'CHDD Boots', '1', '1');
    addToLVLI(e, destFile, 'ARMO', '00DDPanty'+magic_type+s, '1', '1');
    Result := e;
end;

function GenerateAnyVampire(destFile: IwbFile; numOfLevels: integer; newPrefix, combinedPrefixes: string; minMagRateLvl, maxMagRateLvl:integer): string;
var
    i: integer;
    e: IwbMainRecord;
begin
    if pos('#', newPrefix) <> 0 then begin raise Exception.Create('newPrefix shouldn''t have hashtags: '+combinedPrefixes+' -> '+newPrefix+', e='+FullPath(e)); end;
    AddMessage('Combining (Vamp prefixes) '+combinedPrefixes+' into '+newPrefix);
    for i := 1 to numOfLevels do begin
        e := GenerateAnyVampireForLevel(destFile, newPrefix, combinedPrefixes, i, minMagRateLvl, maxMagRateLvl);
    end;
    if StartsStr(newPrefix, EditorID(e)) then begin
        Result := newPrefix;
    end else begin
        if combinedPrefixes[1] <> '#' then begin raise Exception.Create('unreachable: '+newPrefix+' -> '+combinedPrefixes); end;
        Result := copy(combinedPrefixes, 2, length(combinedPrefixes)-1);
    end;
    if pos('#', Result) <> 0 then begin raise Exception.Create('unreachable: '+combinedPrefixes+' -> '+newPrefix+', Result='+Result+', e='+FullPath(e)); end;
end;
function GenerateAnyVampireForLevel(destFile: IwbFile; newPrefix, combinedPrefixes: string; levelNum, minMagRateLvl, maxMagRateLvl:integer): IwbMainRecord;
begin
    GenerateAnyVampireForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Conjuration', levelNum);
    if (levelNum > minMagRateLvl) and (levelNum < maxMagRateLvl) then begin
        GenerateAnyVampireForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'MagickaRate', levelNum);
    end;
    Result := GenerateAnyVampireForTypeAndLevel(destFile, newPrefix, combinedPrefixes, 'Destruction', levelNum);
end;
function GenerateAnyVampireForTypeAndLevel(destFile: IwbFile; newPrefix, combinedPrefixes, magic_type:string; levelNum:integer): IwbMainRecord;
begin
    Result := combineLVLI(destFile, newPrefix+' Ench'+magic_type+IntToStr(levelNum), combinedPrefixes, ' Ench'+magic_type+IntToStr(levelNum));
end;
/////// HERE IS A NICE TEMPLATE FOR MAKING MORE WARLOCK ENCHANTED STUFF IN THE FUTURE ////////
// function GenerateCocoDemon(destFile: IwbFile; e:IwbElement): IwbElement;
// begin
//     e := GenerateCocoDemonForLevel(destFile, e, 'Minor', 1);
//     e := GenerateCocoDemonForLevel(destFile, e, 'Common', 2);
//     e := GenerateCocoDemonForLevel(destFile, e, 'Major', 3);
//     e := GenerateCocoDemonForLevel(destFile, e, 'Eminent', 4);
//     e := GenerateCocoDemonForLevel(destFile, e, 'Extreme', 5);
//     e := GenerateCocoDemonForLevel(destFile, e, 'Peerless', 6);
//     Result := e;
// end;
// function GenerateCocoDemonForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
// begin
//     e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
//     e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
//     e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
//     e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
//     e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
//     e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
//     Result := e;
// end;
// function GenerateCocoDemonForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
// begin
// end;
/////// HERE IS A NICE TEMPLATE FOR MAKING MORE MAGE ENCHANTED STUFF IN THE FUTURE ////////
//
// function GenerateAnyMage(destFile: IwbFile; e:IwbElement): IwbElement;
// begin
//     e := GenerateAnyMageForLevel(destFile, e, 'Novice', 1);
//     e := GenerateAnyMageForLevel(destFile, e, 'Apprentice', 2);
//     e := GenerateAnyMageForLevel(destFile, e, 'Adept', 3);
//     e := GenerateAnyMageForLevel(destFile, e, 'Expert', 4);
//     e := GenerateAnyMageForLevel(destFile, e, 'Master', 5);
//     Result := e;
// end;
// function GenerateAnyMageForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
// begin
//     e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
//     e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
//     e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
//     e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
//     e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
//     e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
//     Result := e;
// end;
// function GenerateAnyMageForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
// begin
// end;
function CopyOverWholeESPOrAddAsDependency(srcFile, destFile: IwbFile; makeSmash: Boolean): IwbFile;
begin
    if makeSmash then begin
        CopyOverWholeESP(srcFile, destFile);
        Result := destFile;
    end else begin
        AddMasterDependencies(srcFile, destFile);
        Result := srcFile;
    end;
end;
function generateLvlListsAndEnchArmorForClothingMods(destFile: IwbFile; makeSmash: Boolean): integer;
var
    s: string;
    i: integer;
    e:IwbElement;
    otft:IwbElement;
    wardrobeLvli: IwbMainRecord;
begin
    if not makeSmash then begin
        if Assigned(fileTAWOBALeveledList) then begin
            raise Exception.Create('You should disable '''+GetFileName(fileTAWOBALeveledList)+''' to avoid conflicts!');
        end;
    end;
    wardrobeLvli := newLVLI(nil, destFile, 'UnderwearInWardrobe', '0', '0', '1', '0');
    if Assigned(filePantiesofskyrim) then begin
        filePantiesofskyrim := CopyOverWholeESPOrAddAsDependency(filePantiesofskyrim, destFile, makeSmash);
        addToLVLI(wardrobeLvli, filePantiesofskyrim, 'LVLI', 'Panties-Wardrobes', '1', '1');
    end;
    if Assigned(fileSkimpyMaid) then begin
        fileSkimpyMaid := CopyOverWholeESPOrAddAsDependency(fileSkimpyMaid, destFile, makeSmash);
        e := newLVLI(e, destFile, 'SkimpyMaidSet', '0', '1', '0', '0');
        addToLVLI(e, fileSkimpyMaid, 'ARMO', 'xxxSkimpyMaidShoes', '1', '1');
        addToLVLI(e, fileSkimpyMaid, 'ARMO', 'xxxSkimpyMaidCloth', '1', '1');
        addToLVLI(e, fileSkimpyMaid, 'ARMO', 'xxxSkimpyMaidHead', '1', '1');
        AnyBarkeeperId := AnyBarkeeperId + '#SkimpyMaidSet';
    end;
    if Assigned(fileCocoSlave) then begin
        fileCocoSlave := CopyOverWholeESPOrAddAsDependency(fileCocoSlave, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CocoSlave', '0', '0', '0', '0');
        addToLVLI(e, fileCocoSlave, 'ARMO', '00SlaveOG', '1', '1');
        addToLVLI(e, fileCocoSlave, 'ARMO', '00SlaveGold', '1', '1');
        AnyPrisonerId := AnyPrisonerId + '#CocoSlave';
    end;
    if Assigned(fileHaruBondage) then begin
        fileHaruBondage := CopyOverWholeESPOrAddAsDependency(fileHaruBondage, destFile, makeSmash);
        e := newLVLI(e, destFile, 'HaruBondage', '0', '0', '0', '0');
        addToLVLI(e, fileHaruBondage, 'ARMO', '00Collar', '1', '1');
        addToLVLI(e, fileHaruBondage, 'ARMO', '00Mask', '1', '1');
        addToLVLI(e, fileHaruBondage, 'ARMO', '00Outfit', '1', '1');
        AnyPrisonerId := AnyPrisonerId + '#HaruBondage';
    end;
    if Assigned(fileMelodicBunny) then begin
        fileMelodicBunny := CopyOverWholeESPOrAddAsDependency(fileMelodicBunny, destFile, makeSmash);
        e := newLVLI(e, destFile, '0RBunnysuitPlain', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPasties', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockings', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArms', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeck', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibs', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitBlue', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsBlue', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsBlue', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesBlue', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckBlue', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsBlue', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitBrown', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsBrown', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsBrown', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesBrown', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckBrown', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsBrown', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitGreen', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsGreen', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsGreen', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesGreen', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckGreen', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsGreen', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitPink', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsPink', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsPink', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesPink', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckPink', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsPink', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitRed', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsRed', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsRed', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesRed', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckRed', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsRed', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitWhite', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsWhite', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsWhite', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesWhite', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckWhite', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsWhite', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEars', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitArtoria', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsArtoria', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsArtoria', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesArtoria', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckArtoria', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEarsArtoria', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsArtoria', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitAhegao', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsAhegao', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsAhegao', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesAhegao', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckAhegao', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEarsAhegao', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsAhegao', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitDark', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsDark', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsDark', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesDark', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckDark', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEarsDark', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsDark', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuitGold', '0', '1', '0', '0');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitStockingsGold', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitRibsGold', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitPastiesGold', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitNeckGold', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitEarsGold', '1', '1');
        addToLVLI(e, fileMelodicBunny, 'ARMO', '0RBunnysuitArmsGold', '1', '1');
        e := newLVLI(e, destFile, '0RBunnysuit', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitPlain', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitBlue', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitBrown', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitGreen', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitPink', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitRed', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitWhite', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitArtoria', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitAhegao', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitDark', '1', '1');
        addToLVLI(e, destFile, 'LVLI', '0RBunnysuitGold', '1', '1');
        AnyLingerieId := AnyLingerieId + '#0RBunnysuit';
    end;
    if Assigned(fileMystKnight) then begin
        fileMystKnight := CopyOverWholeESPOrAddAsDependency(fileMystKnight, destFile, makeSmash);
        e := newLVLI(e, destFile, 'MysteriousKnightEbonite', '0', '1', '0', '0');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_BeltEbonite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_BootsEbonite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_CuirassEbonite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_GlovesEbonite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_LegMetalEbonite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_LegsarmorEbonite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_PauldronEbonite', '1', '1');
        e := newLVLI(e, destFile, 'MysteriousKnightGoldCape', '80', '0', '0', '0');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_CapeGoldBlack', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_CapeGoldWhite', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_CapeGoldRed', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_CapeGold', '1', '1');
        e := newLVLI(e, destFile, 'MysteriousKnightGold', '0', '1', '0', '0');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_BootsGold', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_NeckGold', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_GlovesGold', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_CuirassGold', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_BeltGold', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MysteriousKnightGoldCape', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_LegsarmorGold', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_LegMetalGold', '1', '1');
        addToLVLI(e, fileMystKnight, 'ARMO', '_dint_MK1_PauldronGold', '1', '1');
        e := newLVLI(e, destFile, 'MysteriousKnight', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'MysteriousKnightGold', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'MysteriousKnightEbonite', '1', '1');
        AnyDawnguardId := AnyDawnguardId + '#MysteriousKnight';
    end;
    e := newLVLI(e, destFile, 'DefaultFarmBoots', '0', '0', '0', '0');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmBoots01', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmBoots02', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmBoots03', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmBoots04', '1', '1');
    e := newLVLI(e, destFile, 'DefaultFarmBody', '0', '0', '0', '0');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothes01', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothes02', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothes03', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothes04', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothesVariant02', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothesVariant03', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothesVariant04', '1', '1');
    e := newLVLI(e, destFile, 'DefaultFarmBodyExtras', '0', '0', '0', '0');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothes03Hat', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmClothes03withExtras', '1', '1');
    e := newLVLI(e, destFile, 'DefaultFarmHat', '90', '0', '0', '0');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmHat01', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmHat02', '1', '1');
    addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesFarmHat03', '1', '1');
    e := newLVLI(e, destFile, 'DefaultFarmBodyHatBoots', '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmHat', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBody', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBoots', '1', '1');
    e := newLVLI(e, destFile, 'DefaultFarmBodyExtrasBoots', '0', '1', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBodyExtras', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBoots', '1', '1');
    e := newLVLI(e, destFile, 'DefaultFarmSet', '0', '0', '0', '0');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBodyExtrasBoots', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBodyHatBoots', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBodyHatBoots', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBodyHatBoots', '1', '1');
    addToLVLI(e, destFile, 'LVLI', 'DefaultFarmBodyHatBoots', '1', '1');
    AnyFarmClothesId := AnyFarmClothesId + '#4@DefaultFarmSet';
    if Assigned(fileCocoLolita) then begin
        fileCocoLolita := CopyOverWholeESPOrAddAsDependency(fileCocoLolita, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CocoLolita1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_top01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_smpskirt01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_stocking01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_gloves01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_headwear01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_shoes01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_Vest01', '1', '1');
        e := newLVLI(e, destFile, 'CocoLolita2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_gloves02', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_headwear02', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_shoes02', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_smpskirt02', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_stocking02', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_top02', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_Vest02', '1', '1');
        e := newLVLI(e, destFile, 'CocoLolita3', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_gloves01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_headwear01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_shoes01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_smpskirt03', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_stocking01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_top03', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_Vest03', '1', '1');
        e := newLVLI(e, destFile, 'CocoLolita4', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_gloves03', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_headwear01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_shoes01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_smpskirt04', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_stocking03', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_top04', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_Vest04', '1', '1');
        e := newLVLI(e, destFile, 'CocoLolita5', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_gloves04', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_headwear03', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_shoes03', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_smpskirt05', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_stocking04', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_top05', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_Vest05', '1', '1');
        e := newLVLI(e, destFile, 'CocoLolita6', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_gloves01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_headwear01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_shoes01', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_smpskirt04', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_stocking05', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_top06', '1', '1');
        addToLVLI(e, fileCocoLolita, 'ARMO', 'Lolitav1_Vest06', '1', '1');
        e := newLVLI(e, destFile, 'CocoLolita', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CocoLolita1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CocoLolita2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CocoLolita3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CocoLolita4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CocoLolita5', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CocoLolita6', '1', '1');
        AnyFarmClothesId := AnyFarmClothesId + '#CocoLolita';
        addToLVLI(wardrobeLvli, fileCocoLolita, 'ARMO', 'Lolitav1_stocking01', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoLolita, 'ARMO', 'Lolitav1_stocking02', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoLolita, 'ARMO', 'Lolitav1_stocking03', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoLolita, 'ARMO', 'Lolitav1_stocking04', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoLolita, 'ARMO', 'Lolitav1_stocking05', '1', '1');
    end;

    if Assigned(fileDXFI) then begin
        fileDXFI := CopyOverWholeESPOrAddAsDependency(fileDXFI, destFile, makeSmash);
        e := newLVLI(e, destFile, 'DXCallMeYoursTop', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursTop1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursTopGold1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursNonetTop1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursNonetTopGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXCallMeYoursSocks', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursSocks1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursSocksGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXCallMeYoursHeels', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursHeels1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursHeelsGold1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursHeelsChrome1', '1', '1');
        e := newLVLI(e, destFile, 'DXCallMeYoursChoker', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursChoker1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCallMeYoursChokerGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXCatMask', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCatMask1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXCatMaskGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXCallMeYours', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXCallMeYoursTop', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXCallMeYoursSocks', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXCallMeYoursHeels', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXCallMeYoursChoker', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXCatMask', '1', '1');
        e := newLVLI(e, destFile, 'DXTooHotForYouBodystocking', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXTooHotForYouBodystockingFishnet1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXTooHotForYouBodystocking1', '1', '1');
        e := newLVLI(e, destFile, 'DXTooHotForYoutop', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXTooHotForYoutop1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXTooHotForYoutopGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXTooHotForYouHeels', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXTooHotForYouHeels1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXTooHotForYouHeelsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXTooHotForYou', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXTooHotForYouBodystocking', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXTooHotForYoutop', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXTooHotForYouHeels', '1', '1');
        e := newLVLI(e, destFile, 'DXFireMeUpTop', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireMeUpTop1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireMeUpTopGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireMeUpHeels', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireMeUpHeels1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireMeUpHeelsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireMeUp', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXFireMeUpTop', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireMeUpHeels', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireBalls', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireBalls1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireBallsGold1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireHearts1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireHeartsGold1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireRings1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireRingsGold1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireXs1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireXsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireNavel', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelBall1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelBallGold1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelRing1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelRingGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireBracers', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireBracers1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireBracersGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireNoseRing', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireNoseRing1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireNoseRingGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireBowRing', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireBowRing1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireBowRingGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireStrapsBottom', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsBottom1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsBottomGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireStrapsTop', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsTop1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsTopGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesireEarrings', '0', '0', '0', '0');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireEarrings1', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesireEarringsSMPGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesire', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireBalls', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireNavel', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireBracers', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireNoseRing', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireBowRing', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireStrapsBottom', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireStrapsTop', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesireEarrings', '1', '1');
        addToLVLI(e, fileDXFI, 'ARMO', 'DXFireYourDesirePanty1', '1', '1');
        e := newLVLI(e, destFile, 'DXFI', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXCallMeYours', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXTooHotForYou', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireMeUp', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFireYourDesire', '1', '1');
        AnyLingerieId := AnyLingerieId + '#DXFI';
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXFireYourDesireStrapsTop', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXFireYourDesireStrapsBottom', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXTooHotForYouBodystocking', '1', '1');
    end;
    if Assigned(fileDXFII) then begin
        fileDXFII := CopyOverWholeESPOrAddAsDependency(fileDXFII, destFile, makeSmash);
        e := newLVLI(e, destFile, 'DXFIIWildDreamsGloves', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGloves1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGlovesBelts1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGlovesGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGlovesBeltsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIWildDreamsStocking', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsStockingGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsStocking1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIWildDreamsBra_Panty', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsBra_Panty1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsBra_PantyGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsAllbutBra_Panty1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsAllbutBra_PantyGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsOutfit1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsOutfitGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIWildDreamsArmlets', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsArmlets1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsArmletsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIWildDreamsCollar', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsCollar1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsCollarGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIWildDreamsPiercing', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsPiercingGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsPiercing1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIWildDreams', '0', '1', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIWildDreamsMask1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreamsGloves', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreamsStocking', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreamsBra_Panty', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreamsArmlets', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreamsCollar', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreamsPiercing', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsMonokini', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokiniwithoutChains1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokiniwithoutChainsGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokini1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokiniGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsEarrings', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsEarringsGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeartEarringsGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsEarrings1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeartEarrings1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsSnakeArmlet', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsSnakeArmletGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsSnakeArmlet1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsBracer', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsBracerGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsBracer1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsAnkle', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsAnkleChainGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsAnkleChain1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsGarter', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsGarter1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsGarterGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNightsHeels', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeels1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeelsGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNights16HeelsGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIExoticNights16Heels1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNights', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsMonokini', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsEarrings', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsSnakeArmlet', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsBracer', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsAnkle', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsGarter', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNightsHeels', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIBegForItBracers', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItBracers1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItBracersGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIBegForItSocks', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItSocks1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItSocksGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForIt16Socks1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForIt16SocksGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIBegForItOutfit', '0', '0', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItOutfitGold1', '1', '1');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItOutfit1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIBegForIt', '0', '1', '0', '0');
        addToLVLI(e, fileDXFII, 'ARMO', 'DXFIIBegForItMiniFishnet1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIBegForItOutfit', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIBegForItSocks', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIBegForItBracers', '1', '1');
        e := newLVLI(e, destFile, 'DXFII', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIWildDreams', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIExoticNights', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'DXFIIBegForIt', '1', '1');
        AnyLingerieId := AnyLingerieId + '#DXFII';
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXFIIWildDreamsBra_Panty', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXFIIWildDreamsCollar', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXFIIBegForItSocks', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'DXFIIExoticNightsMonokini', '1', '1');
    end;
    if Assigned(fileDXsT) then begin
        fileDXsT := CopyOverWholeESPOrAddAsDependency(fileDXsT, destFile, makeSmash);
        e := newLVLI(e, destFile, 'DXsT', '0', '1', '0', '0');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisDress1', '1', '1');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisBracelet1', '1', '1');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisHeels1', '1', '1');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisNecklace1', '1', '1');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisEarrings1', '1', '1');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisPearlThong1', '1', '1');
        addToLVLI(e, fileDXsT, 'ARMO', 'DXStLouisArmlet1', '1', '1');
        AnyLingerieId := AnyLingerieId + '#DXsT';
        addToLVLI(wardrobeLvli, fileDXsT, 'ARMO', 'DXStLouisPearlThong1', '1', '1');
    end;
    if Assigned(fileNiniBlacksmith) then begin
        fileNiniBlacksmith := CopyOverWholeESPOrAddAsDependency(fileNiniBlacksmith, destFile, makeSmash);
        e := newLVLI(e, destFile, 'NINI Blacksmith boots', '0', '0', '0', '0');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_boots', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_boots_b', '1', '1');
        e := newLVLI(e, destFile, 'NINI Blacksmith lo', '0', '0', '0', '0');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_lo', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_lo_b', '1', '1');
        e := newLVLI(e, destFile, 'NINI Blacksmith st', '0', '0', '0', '0');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_st', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_st_b', '1', '1');
        e := newLVLI(e, destFile, 'NINI Blacksmith up', '0', '0', '0', '0');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_up', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_up_b', '1', '1');
        e := newLVLI(e, destFile, 'NINI Blacksmith', '0', '1', '0', '0');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_belt', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_gaun', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00bs_hel', '1', '1');
        addToLVLI(e, fileNiniBlacksmith, 'ARMO', '00Bs_m', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'NINI Blacksmith boots', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'NINI Blacksmith lo', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'NINI Blacksmith st', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'NINI Blacksmith up', '1', '1');
        AnyBlacksmithId := AnyBlacksmithId + '#NINI Blacksmith';
    end;
    if Assigned(fileNiniChatNoir) then begin
        fileNiniChatNoir := CopyOverWholeESPOrAddAsDependency(fileNiniChatNoir, destFile, makeSmash);
        e := newLVLI(e, destFile, 'NINI ChatNoir suit', '0', '0', '0', '0');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirSuit', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirSuitSlutty', '1', '1');
        e := newLVLI(e, destFile, 'NINI ChatNoir', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'NINI ChatNoir suit', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirBoots', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirChoker', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirGloves', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirHead', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirOutfit', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirPanty', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirStraps', '1', '1');
        addToLVLI(e, fileNiniChatNoir, 'ARMO', '0ChatNoirTail', '1', '1');

        addToLVLI(wardrobeLvli, fileNiniChatNoir, 'ARMO', '0ChatNoirPanty', '1', '1');
        addToLVLI(wardrobeLvli, fileNiniChatNoir, 'ARMO', '0ChatNoirOutfit', '1', '1');
    end;
    if Assigned(fileNiniCatMaid) then begin
        fileNiniCatMaid := CopyOverWholeESPOrAddAsDependency(fileNiniCatMaid, destFile, makeSmash);
        e := newLVLI(e, destFile, 'NINI CatMaid top bot', '0', '1', '0', '0');
        addToLVLI(e, fileNiniCatMaid, 'ARMO', '0CatMaidLower', '1', '1');
        addToLVLI(e, fileNiniCatMaid, 'ARMO', '0CatMaidUpper', '1', '1');
        e := newLVLI(e, destFile, 'NINI CatMaid suit', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'NINI CatMaid top bot', '1', '1');
        addToLVLI(e, fileNiniCatMaid, 'ARMO', '0CatMaidSlutty', '1', '1');
        e := newLVLI(e, destFile, 'NINI CatMaid', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'NINI CatMaid suit', '1', '1');
        addToLVLI(e, fileNiniCatMaid, 'ARMO', '0CatMaidGloves', '1', '1');
        addToLVLI(e, fileNiniCatMaid, 'ARMO', '0CatMaidHeaddress', '1', '1');
        addToLVLI(e, fileNiniCatMaid, 'ARMO', '0CatMaidShoes', '1', '1');
        AnyBarkeeperId := AnyBarkeeperId + '#NINI CatMaid';
    end;
    if Assigned(fileChristineAphrodite) then begin
        fileChristineAphrodite := CopyOverWholeESPOrAddAsDependency(fileChristineAphrodite, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CHAphrodite', '0', '0', '0', '0');
        addToLVLI(e, fileChristineAphrodite, 'ARMO', '00GoW3AphroditeDress', '1', '1');
        addToLVLI(e, fileChristineAphrodite, 'ARMO', '00GoW3AphroditeDressDarker', '1', '1');
        addToLVLI(e, fileChristineAphrodite, 'ARMO', '00GoW3AphroditeDressGold', '1', '1');
        addToLVLI(e, fileChristineAphrodite, 'ARMO', '00GoW3AphroditeDressGoldDarker', '1', '1');
        AnyMonkId := AnyMonkId + '#CHAphrodite'
    end;
    if Assigned(fileChristineKitchen) then begin
        fileChristineKitchen := CopyOverWholeESPOrAddAsDependency(fileChristineKitchen, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CH Kitchen hands', '0', '0', '0', '0');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieHands01', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieHands02', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieHands03', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieHands04', '1', '1');
        e := newLVLI(e, destFile, 'CH Kitchen lower', '0', '0', '0', '0');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieLower01', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieLower02', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieLower03', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieLower04', '1', '1');
        e := newLVLI(e, destFile, 'CH Kitchen upper', '0', '0', '0', '0');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieUpper01', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieUpper02', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieUpper03', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieUpper04', '1', '1');
        addToLVLI(e, fileChristineKitchen, 'ARMO', '00KitchenLingerieUpper05', '1', '1');
        e := newLVLI(e, destFile, 'CH Kitchen', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CH Kitchen hands', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CH Kitchen lower', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CH Kitchen upper', '1', '1');
        KitchenLingerieId := KitchenLingerieId + '#CH Kitchen';
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'CH Kitchen upper', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'CH Kitchen lower', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'CH Kitchen hands', '1', '1');
    end;
    
    if Assigned(fileShinoSchool) then begin
        fileShinoSchool := CopyOverWholeESPOrAddAsDependency(fileShinoSchool, destFile, makeSmash);
        e := newLVLI(e, destFile, 'Shino top', '0', '0', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_todo_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_todo_az_con_ro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_todo_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_todo_az_con_ro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_todo_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_todo_az_con_ro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_todo_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_todo_az_con_ro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_blanco', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_blanco2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_blanco', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_blanco', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_blanco2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_blanco', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_blanco2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_blanco2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Shirt_a', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Shirt_b', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Shirt_c', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Shirt_d', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Shirt_e', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Shirt_f', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_short', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_short_real', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_short_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_short_real_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_short_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_short_real_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1a', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2a_sexy', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_a', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1b', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_b', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1c', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_c', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1d', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_D', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2b', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2b_sexy', '1', '1');
        e := newLVLI(e, destFile, 'Shino tie', '0', '0', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_1', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_3', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_4', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_5', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_1_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_1_VER', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_1_RO', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_2_AZ', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_3_aZ', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_2_RO', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_2_VER', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_3_RO', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_3_VER', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_4_AZ', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_4_RO', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_4_VER', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_5_AZ', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_5_RO', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_5_VER', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_1_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_2_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_4_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_3_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_tie_5_nergro', '1', '1');
        e := newLVLI(e, destFile, 'Shino ribbon', '0', '0', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_ribbon', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_ribbon_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_ribbon_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_ribbon_blanco', '1', '1');
        e := newLVLI(e, destFile, 'Shino panty', '0', '0', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_1', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_1_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_1_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_1_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_2_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_2_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_panty_2_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Short', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Short_sexy', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Short_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Short_sexy_rojo', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Short_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Short_sexy_nergro', '1', '1');
        e := newLVLI(e, destFile, 'Shino skirt', '0', '0', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_verde', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_ro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy_rosa', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_nergro', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_blanco', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy_blanco', '1', '1');
        e := newLVLI(e, destFile, 'Shino sock', '0', '0', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_pantyhose', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_stocking', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_stocking_Az', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_socks', '1', '1');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_socks_az', '1', '1');
        e := newLVLI(e, destFile, 'Shino set', '0', '1', '0', '0');
        addToLVLI(e, fileShinoSchool, 'ARMO', 'Shino_shoe', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'Shino sock', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'Shino skirt', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'Shino panty', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'Shino ribbon', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'Shino tie', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'Shino top', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'Shino sock', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'Shino skirt', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'Shino panty', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'Shino ribbon', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'Shino tie', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'Shino top', '1', '1');
    end;
    if Assigned(fileWizardHats) then begin
        if not Assigned(fileWitchyHats) then begin
            raise Exception.Create('You are using '+GetFileName(fileWizardHats)+' without '+GetFileName(fileWitchyHats)+'. Make sure to install both');
        end;
        fileWizardHats := CopyOverWholeESPOrAddAsDependency(fileWizardHats, destFile, makeSmash);
        fileWitchyHats := CopyOverWholeESPOrAddAsDependency(fileWitchyHats, destFile, makeSmash);
        e := newLVLI(e, destFile, 'MM_WizardHats', '0', '0', '0', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatRedCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatBeigeCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatBlackCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatBlueCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatBrownCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatGreenCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatGreyCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatLightBrownCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatPurpleCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatWhiteCirclet', '1', '1');
        addToLVLI(e, fileWizardHats, 'ARMO', 'sirwhoArmorWizardHatYellowCirclet', '1', '1');
    end;
    if Assigned(fileModularMage) then begin
        fileModularMage := CopyOverWholeESPOrAddAsDependency(fileModularMage, destFile, makeSmash);
        e := GenerateModularMage(destFile, e);
        AnyMagePrefix := AnyMagePrefix + '#MM_';
    end;
    if Assigned(fileKSOMage) then begin
        fileKSOMage := CopyOverWholeESPOrAddAsDependency(fileKSOMage, destFile, makeSmash);
        e := GenerateKSO(destFile, e);
        AnyMagePrefix := AnyMagePrefix + '#KSO_';
    end;
    if Assigned(fileCocoLingerie) then begin
        fileCocoLingerie := CopyOverWholeESPOrAddAsDependency(fileCocoLingerie, destFile, makeSmash);
        e := newLVLI(e, destFile, 'coco_lingerie1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie1', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes1', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stock1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie2', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes2', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stock2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie3', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie3', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes3', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stock3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie4', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie4', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes4', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stock4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerieb1', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stockb1', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerieb2', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stockb2', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb3', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerieb3', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stockb3', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb4', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerieb4', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stockb4', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb5', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stockb5', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerieb5', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb6', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerieb6', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_stockb6', '1', '1');
        addToLVLI(e, fileCocoLingerie, 'ARMO', 'lingerie_shoes2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerie1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerie2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerie3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerie4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerieb1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerieb2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerieb3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerieb4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerieb5', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lingerieb6', '1', '1');
        AnyLingerieId := AnyLingerieId + '#coco_lingerie';
        addToLVLI(wardrobeLvli, fileCocoLingerie, 'ARMO', 'lingerie_stockb3', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoLingerie, 'ARMO', 'lingerie_stockb4', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoLingerie, 'ARMO', 'lingerie_stockb5', '1', '1');
    end;
    if Assigned(fileCocoLace) then begin
        fileCocoLace := CopyOverWholeESPOrAddAsDependency(fileCocoLace, destFile, makeSmash);
        e := newLVLI(e, destFile, 'coco_lace_heel1', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel01_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel01_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace1_bikini_only', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini01_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini01_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini01_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini01_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini01_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini01_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace1', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace1_bikini_only', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_heel1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_heel2', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel02_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel02_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel02_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace2_bikini_only', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini02_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini02_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini02_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini02_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini02_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini02_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace2', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace2_bikini_only', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_heel2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace3_2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel03_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03handfur_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03head_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03tail_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03brafur_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03bellfur_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace3_1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel03_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03bellfur_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03handfur_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03head_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03tail_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03brafur_1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace3_3', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel03_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03bellfur_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03handfur_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03head_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini03tail_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'Bikini03brafur_1', '1', '1');   
        e := newLVLI(e, destFile, 'coco_lace3', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace3_1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace3_2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace3_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_heel4', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_7', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'heel04_8', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace4_bikini_only', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini04_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini04_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini04_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini04_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace4', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace4_bikini_only', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_heel4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace5_1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini05_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini05arm_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini05nip_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', '05stock_1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_heel4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace5_2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini05_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini05arm_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini05nip_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', '05stock_2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_heel4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace5', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace5_1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace5_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace6', '0', '0', '0', '0');
        e := newLVLI(e, destFile, 'coco_lace7_1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07low_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07top_1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07low_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07top_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_3', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07low_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07top_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_4', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07low_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07top_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_5', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07low_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini07top_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace7_1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace7_2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace7_3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace7_4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace7_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace8', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini08_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini08_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini08_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini08_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini08_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini08_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace9', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini09_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini09_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'bikini09_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace5', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace6', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace7', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace8', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace9', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body1', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace01_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace01_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace01_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace01_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace01_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace01_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body2', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace02_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace02_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace02_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace02_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body3', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace03_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace03_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace03_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body4', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace04_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace04_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace04_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace04_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace04_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body5', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace05_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace05_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace05_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace05_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace05_6', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace05_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body6', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace06_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace06_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace06_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace06_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace06_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body7', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace07_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace07_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace07_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lace07_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_1', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_2', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_3', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_4', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_5', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_6', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_6', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_7', '0', '1', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacelow08_7', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop08_7', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_5', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_6', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8_7', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body9', '0', '0', '0', '0');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_2', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_1', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_3', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_4', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_5', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_6', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_7', '1', '1');
        addToLVLI(e, fileCocoLace, 'ARMO', 'lacetop09smp_8', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body5', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body6', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body7', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body8', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_lace_body9', '1', '1');
        AnyLingerieId := AnyLingerieId + '#coco_lace_body#coco_lace';
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace1_bikini_only', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace2_bikini_only', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace4_bikini_only', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace7', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace8', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace9', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body1', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body2', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body3', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body4', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body5', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body6', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body7', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body8', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'coco_lace_body9', '1', '1');
    end;
    if Assigned(fileForgottenPrincess) then begin
        fileForgottenPrincess := CopyOverWholeESPOrAddAsDependency(fileForgottenPrincess, destFile, makeSmash);
        e := newLVLI(e, destFile, 'cocoForgPrinc', '0', '1', '0', '0');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Cuirass', '1', '1');
        //addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Cuirass2', '1', '1');
        //addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_PantiesFull', '1', '1');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Panties', '1', '1');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Boots', '1', '1');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Crown', '1', '1');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Gauntlets', '1', '1');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Sho', '1', '1');
        addToLVLI(e, fileForgottenPrincess, 'ARMO', '_dint_ForgottenPrincess_Cloak', '1', '1');
        AnyJarlId := AnyJarlId + '#cocoForgPrinc';
    end;
    if Assigned(fileFairyQueen) then begin
        fileFairyQueen := CopyOverWholeESPOrAddAsDependency(fileFairyQueen, destFile, makeSmash);
        for i:=1 to 4 do begin
            s := IntToStr(i);
            e := newLVLI(e, destFile, 'cocoFQ set'+s, '0', '1', '0', '0');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_ear'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothbelly'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothback'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothtop'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothlowSMP'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_neck'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_skirtSMP'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_armSMP'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_shoes'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_briefs'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_glove'+s, '1', '1');
            if not Assigned(addToLVLIMaybe(e, fileFairyQueen, 'ARMO', 'FQ_shomat'+s, '1', '1')) then begin 
                addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_shomat2', '1', '1')
            end;
            e := newLVLI(e, destFile, 'cocoFQ set skimpy'+s, '0', '1', '0', '0');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_ear'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothbelly'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothback'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_bramat'+s, '1', '1'); // instead of FQ_clothtop
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_clothlowSMP'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_neck'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_armmat'+s, '1', '1'); // instead of FQ_armSMP
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_shoes'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_briefs'+s, '1', '1');
            addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_glove'+s, '1', '1');
            if not Assigned(addToLVLIMaybe(e, fileFairyQueen, 'ARMO', 'FQ_lowmat'+s, '1', '1')) then begin // instead of FQ_skirtSMP
                addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_lowmat2', '1', '1')
            end;
            if not Assigned(addToLVLIMaybe(e, fileFairyQueen, 'ARMO', 'FQ_shomat'+s, '1', '1')) then begin 
                addToLVLI(e, fileFairyQueen, 'ARMO', 'FQ_shomat2', '1', '1')
            end;
        end;
        e := newLVLI(e, destFile, 'cocoFQ sets', '0', '0', '0', '0');
        for i:=1 to 4 do begin
            addToLVLI(e, destFile, 'LVLI', 'cocoFQ set'+IntToStr(i), '1', '1');
        end;
        e := newLVLI(e, destFile, 'cocoFQ sets skimpy', '0', '0', '0', '0');
        for i:=1 to 4 do begin
            addToLVLI(e, destFile, 'LVLI', 'cocoFQ set skimpy'+IntToStr(i), '1', '1');
        end;
        AnyJarlId := AnyJarlId + '#cocoFQ sets';
        //AnyLingerieId := AnyLingerieId + '#cocoFQ sets skimpy';
    end;
    if Assigned(fileCocoAhri) then begin
        fileCocoAhri := CopyOverWholeESPOrAddAsDependency(fileCocoAhri, destFile, makeSmash);
        e := newLVLI(e, destFile, 'Ahriv2 ear', '0', '0', '0', '0');
        addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_earB3', '1', '1');
        addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_earA1', '1', '1');
        addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_earB1', '1', '1');
        addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_earA3', '1', '1');
        addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_earA2', '1', '1');
        addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_earB2', '1', '1');
        for i:=1 to 5 do begin
            s := IntToStr(i);
            e := newLVLI(e, destFile, 'Ahriv2 neck'+s, '0', '0', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_neck'+s, '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_neckf'+s, '1', '1');
            addToLVLI(wardrobeLvli, fileCocoAhri, 'ARMO', 'Ahriv2_top'+s, '1', '1');
        end;
        for i:=1 to 4 do begin
            s := IntToStr(i);
            addToLVLI(wardrobeLvli, fileCocoAhri, 'ARMO', 'Ahriv2_briefs'+s, '1', '1');
        end;
        for i:=1 to 7 do begin
            s := IntToStr(i);
            addToLVLI(wardrobeLvli, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s, '1', '1');
            addToLVLI(wardrobeLvli, fileCocoAhri, 'ARMO', 'Ahriv2_stock'+s, '1', '1');
            addToLVLI(wardrobeLvli, fileCocoAhri, 'ARMO', 'Ahriv2_brasex'+s, '1', '1');
            addToLVLI(wardrobeLvli, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s, '1', '1');
        end;
        for i:=1 to 2 do begin
            if i=1 then begin
                s := '';
            end else begin
                s := 'sex';
            end;
            e := newLVLI(e, destFile, 'Ahriv2 set1'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_top1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes1', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'Ahriv2 neck1', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 set2'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'2', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'2', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock2', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_top2', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes2', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'Ahriv2 neck2', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 set3'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs4', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'3', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'3', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock4', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes5', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 set4'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'4', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs2', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'Ahriv2 neck3', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes3', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'4', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock4', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_top3', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 set5'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'5', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs2', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'Ahriv2 neck3', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes3', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'5', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock5', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_top3', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 set6'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'6', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs3', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'Ahriv2 neck4', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes1', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'6', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock6', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_top4', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 set7'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_bra'+s+'7', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_briefs4', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'Ahriv2 neck5', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_shoes5', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_skirt'+s+'7', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_stock7', '1', '1');
            addToLVLI(e, fileCocoAhri, 'ARMO', 'Ahriv2_top5', '1', '1');
            if s <> '' then addToLVLI(e, destFile, 'LVLI', 'Ahriv2 ear', '1', '1');
            e := newLVLI(e, destFile, 'Ahriv2 full sets '+s, '0', '0', '0', '0');
            for i:=1 to 7 do begin
                addToLVLI(e, destFile, 'LVLI', 'Ahriv2 set'+IntToStr(i)+s, '1', '1');
            end;
        end;
        AnyLingerieId := AnyLingerieId + '#Ahriv2 full sets sex';
        AnyFineClothesId := AnyFineClothesId + '#Ahriv2 full sets ';
    end;
    if Assigned(fileCocoBikini) then begin
        fileCocoBikini := CopyOverWholeESPOrAddAsDependency(fileCocoBikini, destFile, makeSmash);
        e := newLVLI(e, destFile, 'coco_bikini3a', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini03a_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini03a_bellfur', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini03a_handfur', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'bikini03a_head', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'bikini03a_tailsmp', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini3b', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini03b_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini03b_bellfur', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini03b_handfur', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'bikini03b_head', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'bikini03b_tailsmp', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini5a', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05a_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05a_stock', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05a_arm', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05a_bra', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini5b', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05b_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05b_stock', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05b_arm', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini05b_bra', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini6a', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini06a_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini06a_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini6b', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini06b_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'BIKINI06b_lowDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini6c', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini06c_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini06c_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini7a', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini07a_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini07a_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini7b', '0', '1', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini07b_body', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini07b_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini8', '0', '0', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini08a', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini08bDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini08cDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini08dDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini08eDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini08fDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini9', '0', '0', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini09a', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini09bDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini09cDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini1', '0', '0', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini01a', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'bikini01bDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'bikini01cDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini2', '0', '0', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini02a', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini02bDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini4', '0', '0', '0', '0');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini04a', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini04bDUPLICATE001', '1', '1');
        addToLVLI(e, fileCocoBikini, 'ARMO', 'Bikini04cDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini3a', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini3b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini5a', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini5b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini6a', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini6b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini6c', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini7a', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini7b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini8', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini9', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'coco_bikini4', '1', '1');
        AnyLingerieId := AnyLingerieId + '#coco_bikini';
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini01a', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini02a', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini03b_body', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini03a_body', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini04a', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05a_body', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05a_stock', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05a_arm', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05a_bra', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05b_body', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05b_stock', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05b_arm', '1', '1');
        addToLVLI(wardrobeLvli, fileCocoBikini, 'ARMO', 'Bikini05b_bra', '1', '1');
    end;
    if Assigned(fileHS2Bunny) then begin
        fileHS2Bunny := CopyOverWholeESPOrAddAsDependency(fileHS2Bunny, destFile, makeSmash);
        e := newLVLI(e, destFile, 'bunny_leggings', '0', '0', '0', '0');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_BunnyLeggings', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_BunnyLeggings_normal', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings00', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings01', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings02', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings04', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings05', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings06', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings07', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings08', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Leggings09', '1', '1');
        e := newLVLI(e, destFile, 'bunny_upper', '0', '0', '0', '0');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_BunnysuitUpperA', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_BunnysuitUpperB', '1', '1');
        e := newLVLI(e, destFile, 'bunny_frontline', '80', '0', '0', '0');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_FrontLineA', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_FrontLineB', '1', '1');
        e := newLVLI(e, destFile, 'bunny_full', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'bunny_leggings', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'bunny_upper', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'bunny_frontline', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Bunnytail', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_Bunnyribbon', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_bunnyhandcuff', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_bunnyshoes', '1', '1');
        e := newLVLI(e, destFile, 'bunny_reverse', '0', '1', '0', '0');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_ReverseBunnyUpper', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_ReverseBunnyLeggings', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_ReverseBunnyribbon', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_bunnyhandcuff', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_bunnyshoes', '1', '1');
        e := newLVLI(e, destFile, 'bunny_reverse_white', '0', '1', '0', '0');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_ReverseBunnyribbon', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_ReverseBunnyLeggingswhite', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_ReverseBunnyUpperwhie', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_bunnyhandcuff', '1', '1');
        addToLVLI(e, fileHS2Bunny, 'ARMO', 'HS2_bunnyshoes', '1', '1');
        e := newLVLI(e, destFile, 'bunny_reverse_any', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'bunny_reverse', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'bunny_reverse_white', '1', '1');
        e := newLVLI(e, destFile, 'bunny', '50', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'bunny_full', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'bunny_reverse_any', '1', '1');
        AnyLingerieId := AnyLingerieId + '#bunny';
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'bunny_leggings', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'bunny_upper', '1', '1');
        addToLVLI(wardrobeLvli, destFile, 'LVLI', 'bunny_frontline', '1', '1');
    end;
    

    if Assigned(fileTEWOBA) then begin
        fileTEWOBA := CopyOverWholeESPOrAddAsDependency(fileTEWOBA, destFile, makeSmash);
        e := newLVLI(e, destFile, 'TEW Ancient Nord Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord45', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord46', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord32-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord32-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord32-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord37-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord37-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord33-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord33-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord33-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord42-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord57-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord57-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord57-03', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord57-04', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord57-05R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord57-05L', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord56-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord53-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord49-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord49-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord53-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord56-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord49-03', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord49-04', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord49-05', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord52-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'AncientNord52-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Ancient Nord Accessories', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Ancient Nord Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Ancient Nord Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Ancient Nord Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Ancient Nord Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric45', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric46', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric47', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric33-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric33-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric31', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-01L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-01R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-02L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-02R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-03L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-03R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-04L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric57-04R', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric49-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric53-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric56-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric49-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric53-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric56-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Daedric52', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Daedric Accessories', '3', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Daedric Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Daedric Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Daedric Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Daedric Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale45-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale46-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale47-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale44-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale32-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale32-10', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale31-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale57-01L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale57-01R', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale49-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale53-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale56-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale49-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale53-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale56-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale49-03', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale53-03', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale56-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Dragonscale52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Dragonscale Accessories', '3', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Dragonscale Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Dragonscale Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Dragonscale Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Dragonscale Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass45', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass46', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass47', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass32-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass32-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass32-03', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass32-04', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass31', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass57-01R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass57-01L', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass49', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass53', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass56', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Glass52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Glass Accessories', '3', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Glass Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Glass Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Glass Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Glass Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy45-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy46-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy48-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy42-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy57-01R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy57-01L', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy49-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy53-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy56-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialHeavy52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Heavy Accessories', '3', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Heavy Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Heavy Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Heavy Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Heavy Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight45-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight46-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight49-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight42-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight57-01L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight57-01R', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight53-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight56-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'ImperialLight52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Light Accessories', '3', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Light Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Light Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Light Thigh Tasset and Abs', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Imperial Light Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Accessories', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled45-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled46-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled46-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled37-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled37-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled31-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled57-01L', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled57-01R', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled58-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled58-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled58-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Thigh Tasset and Abs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled49-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled53-01', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled53-02', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled53-03', '1', '1');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled56-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTEWOBA, 'ARMO', 'Scaled52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TEW Scaled Accessories', '3', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Scaled Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Scaled Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Scaled Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TEW Scaled Thongs', '1', '1');
    end;
    if Assigned(fileTAWOBA) then begin
        fileTAWOBA := CopyOverWholeESPOrAddAsDependency(fileTAWOBA, destFile, makeSmash);
        e := newLVLI(e, destFile, 'TWA Leather Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAbikini1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAbikini2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAbikini3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAcrown', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAthong1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAthong2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAthong3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAboot', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_boots', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAgaunt', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_gaunt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBApauld1L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBApauld2L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBApauld1R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBApauld2R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_pauldron1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_pauldron2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_pauldron2_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBApouch', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAthigh', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAabs1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAbelt1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_belt', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_Tasset', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_thigh1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_thigh2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_cooll', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAneckgorget', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00LBAneckcov', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Leather Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Leather Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Leather Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Leather Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Leather Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Hide Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_top', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_neckcover', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_hotpants1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_hotpants2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_boots', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_gaunt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_pauldron1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_pauldron2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_pauldron2_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_belt', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_Tasset', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_thigh1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_thigh2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00HBA_cooll', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Hide Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Hide Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Hide Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Hide Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Hide Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Bikini_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Headgear_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Headgear_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Headgear_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Facemask1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Facemask2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Thong_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_boots_1_long', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_boots_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_boots_2_long', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_boots_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_boots_3_long', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_gauntlets_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_gauntlets_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_1_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_2_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_3_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_3_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_4_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Shoulder_4_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Tasset_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Tasset_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_abs_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Gorget_Cape', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Gorget_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Harness', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Loincloth', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Pelt', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_B', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_Bk', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_G', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_V', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_W', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00WBA_Circlet_Y', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Wolf Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Wolf Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Wolf Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Wolf Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Wolf Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Bikini_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Bikini_sling', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Breastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Thong_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_boots_1_lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_boots_1_sh', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_boots_2_lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_boots_2_sh', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_gauntlets_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_gauntlets_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Mask_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Mask_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Mask_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Facemask', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Circlet_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Circlet_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_1_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_2_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_3_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_3_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_4_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Shoulder_4_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_thigh_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_tasset_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Gorget_1_A', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Gorget_1_B', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Gorget_1_C', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DBA_Chestguard_Bone', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dragon Bone Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dragon Bone Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dragon Bone Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dragon Bone Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dragon Bone Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Bireastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_thong_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_boots1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_gaunt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Mask', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Maskbl', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_Maskop', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_circlet', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_shoulder_1_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_shoulder_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_shoulder_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_shoulder_3_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_shoulder_3_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_shoulder_cape', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_abs_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_skirt_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_tasset_1b', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_tasset_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_gorg1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EBA_harness', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Ebony Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Ebony Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Ebony Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Ebony Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Ebony Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_bikini_7', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thong_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thong_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thong_7', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_boots_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_gaunt_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_gaunt_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_gaunt_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_gaunt_C', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_headgear_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_headgear_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_headgear_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_openhelm_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_headdress_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_closehelm_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_shoulder_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_shoulder_2_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_shoulder_2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_shoulder_3_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_shoulder_3_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_cape_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_abs_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Thigh_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Tasset_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Skirt_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Skirt_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Skirt_1_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_gorget', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_collar1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_collar2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_collar3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Harness1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00DWA_Harness2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dwarven Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dwarven Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dwarven Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dwarven Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Dwarven Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Iron Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Bikini_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Bikini_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Bikini_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_breastplate_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_7', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thong_8', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_boots_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_boots_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_boots_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_boots_5', '1', '1');
        if Assigned(fileTEWOBA) then addToLVLI(e, fileTEWOBA, 'ARMO', 'Iron37-06', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gauntlets_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gauntlets_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gauntlets_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gauntlets_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gauntlets_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gauntlets_6', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_mask_1_noHorn_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_mask_1_Horna_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_mask_1_Hornb_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_mask_1_noHorn_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_mask_1_Horna_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_mask_1_Hornb_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_circlet_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_circlet_nohorn', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_circlet_1_hornA', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_circlet_1_hornB', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_circlet_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_horn_A', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_horn_B', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_1_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_4_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_4_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_5_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_5_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_6_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_6_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_7_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_shoulder_7_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_abs_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_abs_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_abs_6', '1', '1');
        if Assigned(fileTEWOBA) then addToLVLI(e, fileTEWOBA, 'ARMO', 'Iron56-07', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thigh_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_thigh_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_tasset_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_tasset_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_tasset_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_tasset_6', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_1_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_1_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_3_a', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_3_b', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_chestguard_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_gorget_3_C', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_spine_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BIB_Faceguard', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Iron Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Iron Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Iron Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Iron Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Iron Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Steel Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_7', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_8', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_bikini_breastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_7', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thong_8', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_boots_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_boots_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_boots_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_boots_5', '1', '1');
        if Assigned(fileTEWOBA) then addToLVLI(e, fileTEWOBA, 'ARMO', 'Steel37-06', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gauntlets_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gauntlets_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gauntlets_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gauntlets_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gauntlets_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gauntlets_6', '1', '1');
        if Assigned(fileTEWOBA) then addToLVLI(e, fileTEWOBA, 'ARMO', 'Steel33-07', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_helm_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_helm_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_helm_4_s', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_helm_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_helm_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_1_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_2_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_5_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_5_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_6_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_shoulder_6_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_abs_7', '1', '1');
        if Assigned(fileTEWOBA) then addToLVLI(e, fileTEWOBA, 'ARMO', 'Steel56-08', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Tasset_1_A', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Tasset_1_B', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Tasset_1_C', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Tasset_2_a', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Tasset_2_b', '1', '1');
        if Assigned(fileTEWOBA) then addToLVLI(e, fileTEWOBA, 'ARMO', 'Steel49-03', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thigh_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_Thigh_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_ChestGuard_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gorget_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gorget_1_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gorget_1_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gorget_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gorget_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_gorget_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_targe_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SBA_targe_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Steel Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Steel Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Steel Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Steel Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Steel Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_7', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_8', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_9', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_10', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_11', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_breastplate', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_bikini_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_6', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thong_7', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_boot_1_heel_lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_boot_1_heel_sh', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_boot_2_sab_sh', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_boot_2_sab_lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_boot_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gaunts_1_lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gaunts_1_sh', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gaunts_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_circ_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_gear_1a', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_gear_1b', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_gear_1c', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_gear_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_mask_1cl', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_mask_1op', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_head_mask_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_helm_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_4_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_4_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_5_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_shoulder_5_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_abs_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_1lc', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_3_lc', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_5', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_tasset_5lc', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thigh_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_thigh_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gorget_avent', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gorget_1_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gorget_1_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gorget_2_close', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_gorget_2_open', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_chestguard_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00SPB_skirt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nord Plate Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nord Plate Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nord Plate Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nord Plate Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nord Plate Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedBikini1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedBikini2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedBikini3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedThong1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedThong2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedThong3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedBoots1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedBoots2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedGloves1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedGloves2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedCirclet1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedCirclet2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedPauldrons1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedPauldrons2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedPauldrons3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedAbs1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedAbs2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedAbs3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedTassets1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedTassets2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedTassets3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedThighs', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedBack', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedGorget1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedGorget2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedHarness', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedLeggings', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedNeck', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00NordicCarvedScarf', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nordic Carved Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nordic Carved Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nordic Carved Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nordic Carved Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Nordic Carved Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Elven Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_gorge_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_gorge_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_chest_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_chest_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_spine', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_facecl', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_faceop', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_breastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_boots_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00Evb_gaunt_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00Evb_gaunt_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_gearhvop', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_feather', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_mask', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_gearlg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_visor_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_visor_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_head_gearhvcl', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thong_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_3_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_4_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_5_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_6_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_7_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_3_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_4_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_5_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_6_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_should_7_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thigh_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_tasset_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_tasset_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_tasset_1l', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Elven Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Elven Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Elven Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Elven Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Elven Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Body', '0', '1', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_gorge_1tha', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_robe_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_thong_1tha', '1', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00Evb_gaunt_1tha', '1', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00EVB_boots_1tha', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Gorget_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Gorget_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Gorget_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Bikini_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Bikini_4', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Breastplate', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Kunoichi', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_boots_1s', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_boots_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_boots_2s', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_boots_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_gaunt_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_gaunt_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_helm', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_helmNH', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_circlet', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Thong_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Thong_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Thong_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Pauldron', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_1_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_2_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_3_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_4_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_5_R', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_1_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_2_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_3_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_4_L', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_shoulder_5_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_abs_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Tasset_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Tasset_1alt', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Tasset_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Tasset_2alt', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Tasset_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00BBA_Tasset_3alt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Blades Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Blades Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Blades Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Blades Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Blades Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Accessories', '70', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_gorget_1hv', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_gorget_1lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_gorget_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_Chestguard_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Armors', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_bikini_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_bikini_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_BP_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_BP_sp', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Boots', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_boots_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_boots_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Gauntlets', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_gauntlets_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Helmet', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_helm_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_helm_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_hear_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Thongs', '0', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_Thong_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_Thong_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Pauldron', '40', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_shoulder_R_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_shoulder_R_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_shoulder_R_3', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_shoulder_L_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_shoulder_L_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_shoulder_L_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Thigh Tasset and Abs', '35', '0', '0', '0');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_Thigh_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_Thigh_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_abs_1', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_abs_2', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_tasset_1_hv', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_tasset_1_lg', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_tasset_2_hv', '1', '1');
        addToLVLI(e, fileTAWOBA, 'ARMO', '00OCA_tasset_2_lg', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Body', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'TWA Orcish Armors', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Orcish Thongs', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Orcish Pauldron', '2', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Orcish Thigh Tasset and Abs', '4', '1');
        addToLVLI(e, destFile, 'LVLI', 'TWA Orcish Accessories', '3', '1');
    end;
    if Assigned(fileChildOfTalos) then begin
        fileChildOfTalos := CopyOverWholeESPOrAddAsDependency(fileChildOfTalos, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CoT Stormcloak Body', '0', '1', '0', '0');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_dress', '1', '1');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_belt', '1', '1');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_sho', '1', '1');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_neck', '1', '1');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_panties', '1', '1');
        e := newLVLI(e, destFile, 'CoT Stormcloak Helmet', '0', '1', '0', '0');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_circlet', '1', '1');
        e := newLVLI(e, destFile, 'CoT Stormcloak Gauntlets', '0', '1', '0', '0');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_gloves', '1', '1');
        e := newLVLI(e, destFile, 'CoT Stormcloak Boots', '0', '1', '0', '0');
        addToLVLI(e, fileChildOfTalos, 'ARMO', '_d_SCofT_boots', '1', '1');
    end;
    if Assigned(fileCocoDemon) then begin
        fileCocoDemon := CopyOverWholeESPOrAddAsDependency(fileCocoDemon, destFile, makeSmash); 
        e := GenerateCocoDemon(destFile, e);
        AnyNecromancerPrefix := AnyNecromancerPrefix + '#COCO demon';
    end;
    if Assigned(fileChristineExnem) then begin
        fileChristineExnem := CopyOverWholeESPOrAddAsDependency(fileChristineExnem, destFile, makeSmash); 
        e := GenerateExnemDemon(destFile, e);
        AnyNecromancerPrefix := AnyNecromancerPrefix + '#Exnem demon set ';
    end;
    if Assigned(fileCocoWitch) then begin
        fileCocoWitch := CopyOverWholeESPOrAddAsDependency(fileCocoWitch, destFile, makeSmash); 
        e := GenerateCocoWitch(destFile, e);
        AnyWarlockPrefix := AnyWarlockPrefix + '#COCO witch';
    end;
    if Assigned(fileCocoAssassin) then begin
        fileCocoAssassin := CopyOverWholeESPOrAddAsDependency(fileCocoAssassin, destFile, makeSmash);
        for i := 1 to 5 do begin
            s := IntToStr(i);
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_underwear'+s, 'EnchAssassin_underwear'+s, '', 'DBEnchantShrouded');
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_horn'+s, 'EnchAssassin_horn'+s, '', 'DBEnchantGloves');
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_heels'+s, 'EnchAssassin_heels'+s, '', 'EnchArmorFortifyMarksman02');
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_boots'+s, 'EnchAssassin_boots'+s, '', 'EnchArmorFortifyMarksman02');
            if (i < 3) or (i=4) then begin 
                GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_boots'+s+'b', 'EnchAssassin_boots'+s+'b', '', 'EnchArmorFortifyMarksman02');
            end;
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_legbelt'+s, 'EnchAssassin_legbelt'+s, '', 'EnchArmorMuffle');
            e := newLVLI(e, destFile, 'COCO assassin'+s+' corset', '0', '0', '0', '0');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsmp'+s, '1', '1');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsex'+s, '1', '1');
            if i < 3 then begin
                    e := newLVLI(e, destFile, 'COCO assassin'+s+' corsetb', '0', '0', '0', '0');
                    addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsmp'+s+'b', '1', '1');
                    addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsex'+s+'b', '1', '1');
            end;
            e := newLVLI(e, destFile, 'COCO assassin'+s+' mask', '0', '0', '0', '0');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_mask'+s, '1', '1');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_masksex'+s, '1', '1');
            if i < 3 then begin
                    e := newLVLI(e, destFile, 'COCO assassin'+s+' maskb', '0', '0', '0', '0');
                    addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_mask'+s+'b', '1', '1');
                    addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_masksex'+s+'b', '1', '1');
            end;
            e := newLVLI(e, destFile, 'COCO assassin'+s+' panti', '0', '0', '0', '0');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s, '1', '1');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_pantisex'+s, '1', '1');
            addToLVLIMaybe(e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s+'c', '1', '1');
            if i < 3 then begin
                e := newLVLI(e, destFile, 'COCO assassin'+s+' pantib', '0', '0', '0', '0');
                addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s+'b', '1', '1');
                addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_pantisex'+s+'b', '1', '1');
                addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s+'c', '1', '1');
            end;
            e := newLVLI(e, destFile, 'COCO assassin'+s+' boots', '0', '0', '0', '0');
            addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_boots'+s, '1', '1');
            addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_heels'+s, '1', '1');
            if (i < 3) or (i=4) then begin 
                e := newLVLI(e, destFile, 'COCO assassin'+s+' bootsb', '0', '0', '0', '0');
                addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_boots'+s+'b', '1', '1');
                addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_heels'+s, '1', '1');
            end;
            
            e := newLVLI(e, destFile, 'COCO assassin'+s, '0', '1', '0', '0');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_necklacesmp'+s, '1', '1');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_tailfullsmp'+s, '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' panti', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' mask', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' corset', '1', '1');
            addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' boots', '1', '1');
            addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_glove'+s, '1', '1');
            addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_legbelt'+s, '1', '1');
            addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_underwear'+s, '1', '1');
            addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_horn'+s, '1', '1');
            
            if i < 5 then begin
                e := newLVLI(e, destFile, 'COCO assassin'+s+'b', '0', '1', '0', '0');
                addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_necklacesmp'+s, '1', '1');
                addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_tailfullsmp1b', '1', '1');
                if not Assigned(addToLVLIMaybe(e, destFile, 'LVLI', 'COCO assassin'+s+' pantib', '1', '1')) then begin
                    addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' panti', '1', '1');
                end;
                if not Assigned(addToLVLIMaybe(e, destFile, 'LVLI', 'COCO assassin'+s+' maskb', '1', '1')) then begin
                    addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' mask', '1', '1');
                end;
                if not Assigned(addToLVLIMaybe(e, destFile, 'LVLI', 'COCO assassin'+s+' corsetb', '1', '1')) then begin
                    addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' corset', '1', '1')
                end;
                if not Assigned(addToLVLIMaybe(e, destFile, 'LVLI', 'COCO assassin'+s+' bootsb', '1', '1')) then begin
                    addToLVLI(e, destFile, 'LVLI', 'COCO assassin'+s+' boots', '1', '1')
                end;
                if not Assigned(addToLVLIMaybe(e, fileCocoAssassin, 'ARMO', 'Assassin_glove'+s+'b', '1', '1')) then begin
                    addToLVLI(e, fileCocoAssassin, 'ARMO', 'Assassin_glove'+s, '1', '1');
                end;
                addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_legbelt'+s, '1', '1');
                addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_underwear'+s, '1', '1');
                addToLVLI(e, destFile, 'ARMO', 'EnchAssassin_horn'+s, '1', '1');
            end;
        end;
        e := newLVLI(e, destFile, 'COCO assassin', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin1b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin2b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin3b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin4b', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'COCO assassin5', '1', '1');
        AnyAssassinId := AnyAssassinId + '#COCO assassin';
    end;
    if Assigned(fileChristineUndead) then begin
        fileChristineUndead := CopyOverWholeESPOrAddAsDependency(fileChristineUndead, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CHUD Upper', '10', '0', '0', '0');
        addToLVLI(e, fileChristineUndead, 'ARMO', '00DSChosenUndeadUpperDM', '1', '1');
        addToLVLI(e, fileChristineUndead, 'ARMO', '00DSChosenUndeadUpper', '1', '1');
        e := newLVLI(e, destFile, 'CHUD Beggar Set', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CHUD Upper', '1', '1');
        addToLVLI(e, fileChristineUndead, 'ARMO', '00DSChosenUndeadLower', '1', '1');
        addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesBeggarBoots', '1', '1');
        e := newLVLI(e, destFile, 'CHUD Prisoner Set', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CHUD Upper', '1', '1');
        addToLVLI(e, fileChristineUndead, 'ARMO', '00DSChosenUndeadLower', '1', '1');
        addToLVLI(e, fileSkyrim, 'ARMO', 'ClothesPrisonerShoes', '1', '1');
        AnyBeggarId := AnyBeggarId + '#CHUD Beggar Set';
        AnyPrisonerId := AnyPrisonerId + '#CHUD Prisoner Set';
    end;
    if Assigned(fileChristineNocturnal) then begin
        fileChristineNocturnal := CopyOverWholeESPOrAddAsDependency(fileChristineNocturnal, destFile, makeSmash);
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbraceBoots', 'Ench00NocturnalEmbraceBoots', '', 'TGArmorFortifyPickpocket');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbraceBelt', 'Ench00NocturnalEmbraceBelt', '', 'TGArmorFortifyCarry');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbracePanty1', 'Ench00NocturnalEmbracePanty1', '', 'TGArmorFortifySpeechcraft');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbracePanty2', 'Ench00NocturnalEmbracePanty2', '', 'TGArmorFortifySpeechcraft');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbracePanty1Damage', 'Ench00NocturnalEmbracePanty1Damage', '', 'TGArmorFortifySpeechcraft');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbracePanty2Damage', 'Ench00NocturnalEmbracePanty2Damage', '', 'TGArmorFortifySpeechcraft');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbraceLower1', 'Ench00NocturnalEmbraceLower1', '', 'TGArmorFortifyLockpicking');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbraceLower2', 'Ench00NocturnalEmbraceLower2', '', 'TGArmorFortifyLockpicking');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbraceLower1Damage', 'Ench00NocturnalEmbraceLower1Damage', '', 'TGArmorFortifyLockpicking');
        GenerateEnchantedItem_(destFile, fileChristineNocturnal, '00NocturnalEmbraceLower2Damage', 'Ench00NocturnalEmbraceLower2Damage', '', 'TGArmorFortifyLockpicking');
        e := newLVLI(e, destFile, 'CHNE Upper', '0', '0', '0', '0');
        addToLVLI(e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper2', '1', '1');
        addToLVLI(e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper1', '1', '1');
        addToLVLI(e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper1Damage', '1', '1');
        addToLVLI(e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper2Damage', '1', '1');
        e := newLVLI(e, destFile, 'CHNE Panty', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty1', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty2', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty1Damage', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty2Damage', '1', '1');
        e := newLVLI(e, destFile, 'CHNE Lower', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower1', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower2', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower1Damage', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower2Damage', '1', '1');
        e := newLVLI(e, destFile, 'CHNE Set', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CHNE Lower', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHNE Upper', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHNE Panty', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbraceBoots', '1', '1');
        addToLVLI(e, destFile, 'ARMO', 'Ench00NocturnalEmbraceBelt', '1', '1');
        AnyThievesGuildId := AnyThievesGuildId + '#CHNE Set';
    end;
    if Assigned(fileChristineBlackMagic) then begin
        fileChristineBlackMagic := CopyOverWholeESPOrAddAsDependency(fileChristineBlackMagic, destFile, makeSmash);
        e := newLVLI(e, destFile, 'BlackMagicGrove Upper', '0', '0', '0', '0');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveUpper', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveUpperSlutty', '1', '1');
        e := newLVLI(e, destFile, 'BlackMagicGrove', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'BlackMagicGrove Upper', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveBoots', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveGauntlets', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveCirclet', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveLower', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveArms', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveAmulet', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGroveThighs', '1', '1');
        addToLVLI(e, fileChristineBlackMagic, 'ARMO', '00BlackMagicGrovePanty', '1', '1');
        AnyForswornId := AnyForswornId + '#BlackMagicGrove';
    end;
    if Assigned(fileChristineDeadlyDesire) then begin
        fileChristineDeadlyDesire := CopyOverWholeESPOrAddAsDependency(fileChristineDeadlyDesire, destFile, makeSmash);
        e := newLVLI(e, destFile, 'CHDD Upper', '0', '0', '0', '0');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDUpper', '1', '1');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDUpperSlutty', '1', '1');
        e := newLVLI(e, destFile, 'CHDD Shoulder', '0', '0', '0', '0');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDShoulderA', '1', '1');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDShoulderB', '1', '1');
        e := newLVLI(e, destFile, 'CHDD Boots', '0', '0', '0', '0');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsA', '1', '1');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsSluttyA', '1', '1');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsB', '1', '1');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsSluttyB', '1', '1');
        GenerateEnchantedItem_(destFile, fileChristineDeadlyDesire, '00DDPanty', '00DDEnchPanty', '', 'EnchRobesCollegeMagickaRate04');
        e := newLVLI(e, destFile, 'CHDD Set', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CHDD Upper', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHDD Shoulder', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHDD Boots', '1', '1');
        addToLVLI(e, fileChristineDeadlyDesire, 'ARMO', '00DDPanty', '1', '1');
        e := newLVLI(e, destFile, 'CHDD Set Ench', '0', '1', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CHDD Upper', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHDD Shoulder', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHDD Boots', '1', '1');
        addToLVLI(e, destFile, 'ARMO', '00DDEnchPanty', '1', '1');
        e := GenerateDeadlyDesire(destFile, e);
        AnyVampirePrefix := AnyVampirePrefix + '#CHDD Set';
    end;
    if Assigned(fileChristinePriestess) then begin
        fileChristinePriestess := CopyOverWholeESPOrAddAsDependency(fileChristinePriestess, destFile, makeSmash);
        for i := 1 to 7 do begin
            s := IntToStr(i);
            e := newLVLI(e, destFile, 'CHHP priestess'+s, '0', '1', '0', '0');
            addToLVLI(e, fileChristinePriestess, 'ARMO', '00HPBBelly0'+s, '1', '1');
            addToLVLI(e, fileChristinePriestess, 'ARMO', '00HPBLower0'+s, '1', '1');
            addToLVLI(e, fileChristinePriestess, 'ARMO', '00HPBUpper0'+s, '1', '1');
        end;
        e := newLVLI(e, destFile, 'CHHP priestess', '0', '0', '0', '0');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess1', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess2', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess3', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess4', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess5', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess6', '1', '1');
        addToLVLI(e, destFile, 'LVLI', 'CHHP priestess7', '1', '1');
        AnyMonkId := AnyMonkId + '#CHHP priestess';
    end;
    if Assigned(e) then RemoveByIndex(e, 0, true);
    RemoveByIndex(wardrobeLvli, 0, true);
    wardrobeLvli := nil;
    e := nil;

    if Assigned(AnyLingerieId) then begin
        AnyLingerie := combineLVLI(destFile, 'any_lingerie', AnyLingerieId, '');
        AnyLingerieId := EditorID(AnyLingerie);
        AnyLingerieOutfit := makeSingletonOutfit(destFile, 'AnyLingerieOutfit', AnyLingerie);
        if Signature(AnyLingerie) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyLingerie)+' is invalid') end;
    end;
    if Assigned(AnyThievesGuildId) then begin
        AnyThievesGuild := combineLVLI(destFile, 'any_thieves_guild', AnyThievesGuildId, '');
        AnyThievesGuildId := EditorID(AnyThievesGuild);
        if Signature(AnyThievesGuild) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyThievesGuild)+' is invalid') end;
    end;
    if Assigned(AnyBeggarId) then begin
        AnyBeggar := combineLVLI(destFile, 'any_beggar', AnyBeggarId, '');
        AnyBeggarId := EditorID(AnyBeggar);
        if Signature(AnyBeggar) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyBeggar)+' is invalid') end;
    end;
    if Assigned(AnyPrisonerId) then begin
        AnyPrisoner := combineLVLI(destFile, 'any_prisoner', AnyPrisonerId, '');
        AnyPrisonerId := EditorID(AnyPrisoner);
        AnyPrisonerOutfit := makeSingletonOutfit(destFile, 'AnyPrisonerOutfit', AnyPrisoner);
        if Signature(AnyPrisoner) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyPrisoner)+' is invalid') end;
    end;
    if Assigned(AnyForswornId) then begin
        AnyForsworn := combineLVLI(destFile, 'any_forsworn', AnyForswornId, '');
        AnyForswornId := EditorID(AnyForsworn);
        if Signature(AnyForsworn) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyForsworn)+' is invalid') end;
    end;
    if Assigned(AnyBarkeeperId) then begin
        AnyBarkeeper := combineLVLI(destFile, 'any_barkeeper', AnyBarkeeperId, '');
        AnyBarkeeperId := EditorID(AnyBarkeeper);
        if Signature(AnyBarkeeper) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyBarkeeper)+' is invalid') end;
    end;
    if Assigned(AnyBlacksmithId) then begin
        AnyBlacksmith := combineLVLI(destFile, 'any_blacksmith', AnyBlacksmithId, '');
        AnyBlacksmithId := EditorID(AnyBlacksmith);
        if Signature(AnyBlacksmith) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyBlacksmith)+' is invalid') end;
    end;
    if Assigned(AnyAssassinId) then begin
        AnyAssassin := combineLVLI(destFile, 'any_assassin', AnyAssassinId, '');
        AnyAssassinId := EditorID(AnyAssassin);
        if Signature(AnyAssassin) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyAssassin)+' is invalid') end;
    end;
    if Assigned(AnyJarlId) then begin
        AnyJarl := combineLVLI(destFile, 'any_jarl', AnyJarlId, '');
        AnyJarlId := EditorID(AnyJarl);
        if Signature(AnyJarl) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyJarl)+' is invalid') end;
    end;
    if Assigned(AnyFineClothesId) then begin
        AnyFineClothes := combineLVLI(destFile, 'any_fine_clothes', AnyFineClothesId, '');
        AnyFineClothesId := EditorID(AnyFineClothes);
        if Signature(AnyFineClothes) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyFineClothes)+' is invalid') end;
    end;
    if Assigned(AnyDawnguardId) then begin
        AnyDawnguard := combineLVLI(destFile, 'any_dawnguard', AnyDawnguardId, '');
        AnyDawnguardId := EditorID(AnyDawnguard);
        if Signature(AnyDawnguard) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyDawnguard)+' is invalid') end;
    end;
    if Assigned(AnyFarmClothesId) then begin
        AnyFarmClothes := combineLVLI(destFile, 'any_farm_clothes', AnyFarmClothesId, '');
        AnyFarmClothesId := EditorID(AnyFarmClothes);
        if Signature(AnyFarmClothes) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyFarmClothes)+' is invalid') end;
    end;
    if Assigned(AnyMonkId) then begin
        AnyMonk := combineLVLI(destFile, 'any_monk', AnyMonkId, '');
        AnyMonkId := EditorID(AnyMonk);
        if Signature(AnyMonk) <> 'LVLI' then begin raise Exception.Create(FullPath(AnyMonk)+' is invalid') end;
    end;
    if Assigned(AnyMagePrefix) then begin
        AnyMagePrefix := GenerateAnyMage(destFile, 5, 'AnyMage_', AnyMagePrefix, 0, 6);
    end;
    if Assigned(AnyNecromancerPrefix) then begin
        AnyNecromancerPrefix := GenerateAnyMage(destFile, 6, 'AnyNecro_', AnyNecromancerPrefix, 1, 6);
    end;
    if Assigned(AnyWarlockPrefix) then begin
        AnyWarlockPrefix := GenerateAnyMage(destFile, 6, 'AnyWarlock_', AnyWarlockPrefix, 1, 6);
    end;
    if Assigned(AnyVampirePrefix) then begin
        combineLVLI(destFile, 'AnyVamp', AnyVampirePrefix, '');
        combineLVLI(destFile, 'AnyVamp Ench', AnyVampirePrefix, ' Ench');
        AnyVampirePrefix := GenerateAnyVampire(destFile, 6, 'AnyVamp', AnyVampirePrefix, 1, 6);
    end;
    if Assigned(KitchenLingerieId) then begin
        KitchenLingerie := combineLVLI(destFile, 'any_lingerie_kitchen', KitchenLingerieId, '');
        KitchenLingerieId := EditorID(KitchenLingerie);
        KitchenLingerieOutfit := makeSingletonOutfit(destFile, 'AnyLingerieKitchenOutfit', KitchenLingerie);
        if Signature(KitchenLingerie) <> 'LVLI' then begin raise Exception.Create(FullPath(KitchenLingerie)+' is invalid') end;
    // end else begin
    //     KitchenLingerie := AnyLingerie;
    //     KitchenLingerieId := AnyLingerieId;
    //     KitchenLingerieOutfit := AnyLingerieOutfit;
    end;
    if pos('#', AnyLingerieId) <> 0 then begin raise Exception.Create(AnyLingerie+' is invalid') end;
    if pos('#', AnyForswornId) <> 0 then begin raise Exception.Create(AnyLingerie+' is invalid') end;
    if pos('#', AnyBarkeeperId) <> 0 then begin raise Exception.Create(AnyBarkeeper+' is invalid') end;
    if pos('#', AnyMonkId) <> 0 then begin raise Exception.Create(AnyMonkId+' is invalid') end;
    if pos('#', AnyAssassinId) <> 0 then begin raise Exception.Create(AnyAssassinId+' is invalid') end;
    if pos('#', KitchenLingerieId) <> 0 then begin raise Exception.Create(KitchenLingerieId+' is invalid') end;
    if pos('#', AnyThievesGuildId) <> 0 then begin raise Exception.Create(AnyThievesGuildId+' is invalid') end;
    if pos('#', AnyPrisonerId) <> 0 then begin raise Exception.Create(AnyThievesGuildId+' is invalid') end;
    if pos('#', AnyMagePrefix) <> 0 then begin raise Exception.Create(AnyMagePrefix+' is invalid') end;
    if pos('#', AnyVampirePrefix) <> 0 then begin raise Exception.Create(AnyVampirePrefix+' is invalid') end;
    if EndsStr('Ench', AnyVampirePrefix) then begin raise Exception.Create(AnyVampirePrefix+' is invalid') end;
    if pos('#', AnyWarlockPrefix) <> 0 then begin raise Exception.Create(AnyWarlockPrefix+' is invalid') end;
    if pos('#', AnyNecromancerPrefix) <> 0 then begin raise Exception.Create(AnyNecromancerPrefix+' is invalid') end;
    if EditorID(AnyBeggar) <> AnyBeggarId then begin raise Exception.Create(AnyBeggarId+' <> '+EditorID(AnyBeggar)) end;
    if EditorID(AnyPrisoner) <> AnyPrisonerId then begin raise Exception.Create(AnyPrisonerId+' <> '+EditorID(AnyPrisoner)) end;
    if EditorID(AnyAssassin) <> AnyAssassinId then begin raise Exception.Create(AnyAssassinId+' <> '+EditorID(AnyAssassin)) end;
    if EditorID(AnyLingerie) <> AnyLingerieId then begin raise Exception.Create(AnyLingerieId+' <> '+EditorID(AnyLingerie)) end;
    if EditorID(AnyBarkeeper) <> AnyBarkeeperId then begin raise Exception.Create(AnyBarkeeperId+' <> '+EditorID(AnyBarkeeper)) end;
    if EditorID(AnyForsworn) <> AnyForswornId then begin raise Exception.Create(AnyForswornId+' <> '+EditorID(AnyForsworn)) end;
    if EditorID(AnyMonk) <> AnyMonkId then begin raise Exception.Create(AnyMonkId+' <> '+EditorID(AnyMonk)) end;
    if EditorID(KitchenLingerie) <> KitchenLingerieId then begin raise Exception.Create(KitchenLingerieId+' <> '+EditorID(KitchenLingerie)) end;
    if EditorID(AnyThievesGuild) <> AnyThievesGuildId then begin raise Exception.Create(AnyThievesGuildId+' <> '+EditorID(AnyThievesGuild)) end;
    
end;


function IsLvliJustGold(lvli: IwbMainRecord): Boolean; 
var
    item: IwbElement;
    i: integer;
begin
    if Signature(lvli)<>'LVLI' then begin raise Exception.Create('not LVLI: '+FullPath(lvli)) end;
    lvli := ElementByPath(lvli, 'Leveled List Entries');
    if not Assigned(lvli) then begin raise Exception.Create('LVLI is nil '+FullPath(lvli)) end;
    Result := true;
    for i :=  ElementCount(lvli)-1 downto 0 do begin
        item := ElementByIndex(lvli, i);
        item := ElementByPath(item, 'LVLO\Reference');
        item := LinksTo(item);
        if not Assigned(item) then begin raise Exception.Create('item is nil '+FullPath(lvli)+' '+IntToStr(i)) end;
        if EditorID(item) <> 'Gold001' then begin
            if Signature(item) = 'LVLI' then begin
                if not IsLvliJustGold(item) then begin
                    Result := false;
                    exit;
                end;
            end else begin
                Result := false;
                exit;
            end;
        end;
    end;
end;

function getOrCopyFromSkyrim(destFile: IwbFile; group, id: string): IwbMainRecord; 
begin
    Result := MainRecordByEditorID(GroupBySignature(fileUSSEP, group), id);
    if not Assigned(Result) then begin 
        Result := MainRecordByEditorID(GroupBySignature(npcFileDawnguard, group), id);
    end;
    if not Assigned(Result) then begin 
        Result := MainRecordByEditorID(GroupBySignature(fileUpdate, group), id);
    end;
    if not Assigned(Result) then begin 
        Result := MainRecordByEditorID(GroupBySignature(fileSkyrim, group), id);
    end;
    if not Assigned(Result) then begin raise Exception.Create(id+' not found') end;
    Result := getOrCopyByRef(Result, destFile, false);
    if not Assigned(Result) then begin raise Exception.Create(id+' copy failed') end;
end;
function getOrCopyLvliFromSkyrim(destFile:IwbFile; id: string): IwbElement; 
begin
    Result := getOrCopyFromSkyrim(destFile, 'LVLI', id);
    Result := ElementByPath(Result, 'Leveled List Entries');
    if not Assigned(Result) then begin
        raise Exception.Create(id+' has empty entry list') 
    end;
end;

function rebalanceLVLI(destFile: IwbFile; percentage: integer; lvliId: string): integer; 
var
    lvli: IwbMainRecord;
begin
    lvli := getOrCopyFromSkyrim(destFile, 'LVLI', lvliId);
    Result := rebalanceLVLIByRef(destFile, percentage, lvli);
end;

function rebalancePotionLVLI(destFile: IwbFile; percentage: integer; lvliId: string): integer; 
var
    e: IwbMainRecord;
    lvli: IwbElement;
    oldElemCount: integer;
    newElemCount: integer;
begin
    lvli := getOrCopyFromSkyrim(destFile, 'LVLI', lvliId);
    if not Assigned(lvli) then begin raise Exception.Create('unreachable '+lvliId) end;
    if Assigned(npcFileToH) then begin
        e := ElementByPath(lvli, 'Leveled List Entries');
        if not Assigned(e) then begin raise Exception.Create('unreachable '+lvliId) end;
        oldElemCount := ElementCount(e);
        if lvliId = 'LootVampireChestPotions15' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAASensationEnhancement', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAALiquidAgony', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAAncientWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAAncientWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAFoulWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAFoulWhoreCocktail', '1', '1');
        end else if lvliId = 'LootHagravenChestPotions25' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAStopRecoveryPoison', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADisgustingSoup', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAASoulshatter', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHorsesCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHorsesPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAASkeeversCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAASkeeversPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADogsCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADogsPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAASpriggansPleasureJuice', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPrecum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAWomanLubricant', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHorsesSweat', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAGoatsCum', '1', '1');
        end else if lvliId = 'LootForswornPotions10' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAATrollsCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHorsesCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHorsesPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAASkeeversCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADogsCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADogsPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPrecum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAGoatsCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAABretonCum', '1', '1');
        end else if lvliId = 'LootDraugrChestPotions05' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAFoulWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAFoulWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAFoulWhoreCocktail', '1', '1');
        end else if lvliId = 'LootCWSonsChestPotions25' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPrecum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAWomanLubricant', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAANordCum', '1', '1');
        end else if lvliId = 'LootCWImperialsChestPotions25' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPrecum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAWomanLubricant', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAImperialCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAAltmerCum', '1', '1');
        end else if lvliId = 'LootBanditChestPotions100' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPiss', '5', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '5', '1');
        end else if lvliId = 'LootBanditChestPotions15' then begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAABretonCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAImperialCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAANordCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAARedguardCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAAltmerCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAABosmerCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADunmerCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAOrcCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAArgonianCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAKhajiitCum', '1', '1');
        end else begin
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAFoulWhoreCocktail', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPrecum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAWomanLubricant', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanPiss', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAHumanCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAABretonCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAImperialCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAANordCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAARedguardCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAAltmerCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAABosmerCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAADunmerCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAOrcCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAArgonianCum', '1', '1');
            addToLVLI(e, npcFileToH, 'ALCH', 'AAAKhajiitCum', '1', '1');
        end;
        newElemCount := ElementCount(e);
        if newElemCount = oldElemCount then begin raise Exception.Create('unreachable '+lvliId) end;
        percentage := max(1, min(100, percentage * newElemCount / oldElemCount));
    end;
    Result := rebalanceLVLIByRef(destFile, percentage, lvli);
end;

function rebalanceLVLIByRef(destFile: IwbFile; percentage: integer; lvli: IwbMainRecord): integer; 
var
    newLvld: integer;
    oldLvld: integer;
    items: IwbElement;
    item: IwbElement;
    i: integer;
begin
    if not Assigned(percentage) then begin raise Exception.Create('unreachable') end;
    if not Assigned(lvli) then begin raise Exception.Create(lvliId+' is nil') end;
    if not IsLvliJustGold(lvli) then begin
        oldLvld := GetElementNativeValues(lvli, 'LVLD');
        if not Assigned(oldLvld) then begin oldLvld := 0; end;
        newLvld := round(100 - (100-oldLvld) * percentage / 100);
        if newLvld < 0 then begin raise Exception.Create(IntToStr(oldLvld)+' = newLvld < 0 / '+IntToStr(percentage)+' '+FullPath(lvli)) end;
        if newLvld > 100 then begin raise Exception.Create(IntToStr(oldLvld)+' = newLvld > 100 / '+IntToStr(percentage)+' '+FullPath(lvli)) end;
        if (newLvld = 100) and (oldLvld <> 100) then begin
            newLvld = 99;
        end;
        SetElementNativeValues(lvli, 'LVLD', newLvld);
        AddMessage('Rebalanced '+IntToStr(oldLvld)+' -> '+IntToStr(newLvld)+' : '+FullPath(lvli));
    end else begin
        AddMessage('Just gold : '+FullPath(lvli));
    end;
    items := ElementByPath(lvli, 'Leveled List Entries');
    if not Assigned(items) then begin raise Exception.Create(lvliId+' entries are nil') end;
    for i := 0 to ElementCount(items)-1 do begin
        item := ElementByIndex(items, i);
        if GetElementEditValues(item, 'LVLO\Reference') = 'Gold001 "Gold" [MISC:0000000F]' then begin
            oldLvld := GetElementNativeValues(item, 'LVLO\Count');
            newLvld := round(oldLvld * percentage / 100);
            if newLvld = 0 then begin
                newLvld := 1;
            end;
            AddMessage('Rebalanced gold Lv'+GetElementEditValues(item, 'LVLO\Level')+' '+IntToStr(oldLvld)+'x -> '+IntToStr(newLvld)+'x : '+FullPath(item));
            SetElementNativeValues(item, 'LVLO\Count', newLvld);
        end;
    end;
end;

function rebalanceContainers(destFile: IwbFile): integer; 
var
    cont: IwbMainRecord;
    tgFemArmLvli: IwbMainRecord;
    underwearLvli: IwbMainRecord;
begin
    underwearLvli := MainRecordByEditorID(GroupBySignature(destFile, 'LVLI'), 'UnderwearInWardrobe');
    if Assigned(underwearLvli) then begin
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'UpperWardrobe01');
        addToCont(cont, destFile, 'LVLI', 'UnderwearInWardrobe', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'UpperDresser01');
        addToCont(cont, destFile, 'LVLI', 'UnderwearInWardrobe', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'Dresser01');
        addToCont(cont, destFile, 'LVLI', 'UnderwearInWardrobe', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'CommonWardrobe01');
        addToCont(cont, destFile, 'LVLI', 'UnderwearInWardrobe', '1');
    end;
    if Assigned(filePantiesofskyrim) then begin
        AddMasterDependencies(filePantiesofskyrim, destFile);
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'OrcDresser01');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Orcish', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantMarkarthCastleBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantFalkreathBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantCaravanAChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-TheNine', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantCaravanBChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-TheNine', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantCaravanCChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-TheNine', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiverwoodTraderChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiverwoodAlvorBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantMarkarthWizardsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeDrevisChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeFaraldaChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegePhinisChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeColetteChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeTolfdirChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWhiterunBelethorsGoodsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWhiterunWarmaidensBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantDawnstarRustleifsBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantMorthalFalionsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWinterholdBirnaChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantMarkarthBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantMarkarthArnleifandSonsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantDushnikhYalBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantMorKhazgurBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantHeljarchenBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWhiterunDrunkenHuntsmanChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'DelphineSecretRoomChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Blades', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiftenWylandriahsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSolitudeSybilleStentorChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWhiterunFarengarsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiftenPawnedPrawnChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiftenScorchedHammerBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiftenGrandPlazaGrelkaChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantRiftenGrandPlazaBrandishChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWindhelmNiranyeChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWindhelmAvalAtheronChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWindhelmRevynSadriChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWindhelmBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWindhelmWuunferthsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantFalkreathGrayPineGoodsChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSolitudeRadiantRaiments');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Big Vendor', '3');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSolitudeBitsAndPieces');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSolitudeBlacksmith');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantFilnjarBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantTGSyndusChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantTGArnskarChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantTGVanrythChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantLargashburBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSolitudeFletcher');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantNarzulburBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSpouseBlacksmithChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Armor_Vendor-1', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSpouseMiscVendorChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestTonilia');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-TG Vendor', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantSolitudeEastEmpireCompany');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestGulumEi');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestNiranye');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestEndon');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestEnthir');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestMallus');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestCaravanAtahba');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestCaravanMajhad');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestCaravanZaynabi');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWinterholdNelacarChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-General-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeEnthirChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Magic-Vendor', '1');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Mages', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWhiterunEorlundChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Wolf-Draug-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'DLC1VendorChestGunmar');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-Dawnguard-Vendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'DLC1VendorChestHestla');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-VampireVendor', '1');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'DLC2RRGloverVendorChest');
        addToCont(cont, filePantiesofskyrim, 'LVLI', 'Panties-DB-Vendor', '1');
    end;
    if Assigned(fileMegacore) then begin
        AddMasterDependencies(fileMegacore, destFile);
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeDrevisChest');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCIllusion', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnench', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnleveled', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeFaraldaChest');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCDestruction', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnench', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnleveled', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegePhinisChest');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCConjuration', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnench', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnleveled', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeColetteChest');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCRestoration', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnench', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnleveled', '2');
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'MerchantWCollegeTolfdirChest');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCAlteration', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnench', '2');
        addToCont(cont, fileMegacore, 'LVLI', 'aaLMCUnleveled', '2');
    end;
    if Assigned(fileDXFII) then begin
        AddMasterDependencies(fileDXFII, destFile);
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TreasWarlockChestBoss');
    end;
    // if Assigned(npcFileToH) then begin
    //     cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TreasWarlockChestBoss');
    //     cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TreasWarlockChest');
    //     cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TreasVampireChest');
    //     cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TreasVampireChestBoss');
    // end;
    if Assigned(fileChristineNocturnal) then begin
        AddMasterDependencies(fileChristineNocturnal, destFile);
        if not Assigned(tgFemArmLvli) then begin
            tgFemArmLvli := newLVLI(nil, destFile, 'TGFemaleArmor', '0', '0', '1', '0');
        end;
        addToLVLI(tgFemArmLvli, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper2', '1', '1');
        addToLVLI(tgFemArmLvli, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper1', '1', '1');
        addToLVLI(tgFemArmLvli, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper1Damage', '1', '1');
        addToLVLI(tgFemArmLvli, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper2Damage', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty1', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty2', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty1Damage', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbracePanty2Damage', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower1', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower2', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower1Damage', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbraceLower2Damage', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbraceBoots', '1', '1');
        addToLVLI(tgFemArmLvli, destFile, 'ARMO', 'Ench00NocturnalEmbraceBelt', '1', '1');
    end;
    if Assigned(tgFemArmLvli) then begin
        cont := getOrCopyFromSkyrim(destFile, 'CONT', 'TGFenceMerchantChestTonilia');
        assignToCont(cont, ContainingMainRecord(tgFemArmLvli), '3');
        RemoveByIndex(tgFemArmLvli, 0, true);
    end;
    
    
end;
function rebalanceLoot(destFile: IwbFile; percentage: integer): integer; 
var
    e: IwbMainRecord;
begin
    AddMasterDependencies(fileUSSEP, destFile);

    rebalanceContainers(destFile);
    if Assigned(fileDeviousLore) then begin
        AddMasterDependencies(fileDeviousLore, destFile);
        e := getOrCopyLvliFromSkyrim(destFile, 'LootWarlockArmor15');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverWarlock', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootVampireArmor10');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverVampire', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootGiantArmor50');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverGiant', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootForswornArmor15');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverForsworn', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootFalmerArmor15');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverFalmer', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootDwarvenArmor25');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverDwarven', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootDraugrArmor25');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverDraugr', '1', '1');
        e := getOrCopyLvliFromSkyrim(destFile, 'LootBanditArmor25');
        addToLVLI(e, fileDeviousLore, 'LVLI', '_DL_LVLIDiscoverBandit', '1', '1');
    end;
    rebalanceLVLI(destFile, percentage, 'LvlQuestReward01Small');
    rebalanceLVLI(destFile, percentage, 'LvlQuestReward02Medium');
    rebalanceLVLI(destFile, percentage, 'LvlQuestReward03Large');
    rebalanceLVLI(destFile, percentage, 'LvlQuestReward04Wow');
    rebalanceLVLI(destFile, percentage, 'TGRewardGold');
    rebalanceLVLI(destFile, percentage, 'TGRewardGoldRadiant');
    rebalanceLVLI(destFile, percentage, 'LootBanditGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootForswornGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootBanditGold');
    rebalanceLVLI(destFile, percentage, 'LootGoldChange');
    rebalanceLVLI(destFile, percentage, 'LootGoldChange25');
    rebalanceLVLI(destFile, percentage, 'LootGoldChange50');
    rebalanceLVLI(destFile, percentage, 'FavorRewardGoldSmall');
    rebalanceLVLI(destFile, percentage, 'FavorRewardGoldLarge');
    rebalanceLVLI(destFile, percentage, 'LootBanditEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootBanditEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootBanditChestBossMagicItem100');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchWeapons75');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchArmor75');
    rebalanceLVLI(destFile, percentage, 'LootSilverHandPotions');
    rebalanceLVLI(destFile, percentage, 'LootSilverHandIngredients');
    rebalanceLVLI(destFile, percentage, 'LootSilverHandBooks10');
    rebalanceLVLI(destFile, percentage, 'LootDrinkList25');
    rebalanceLVLI(destFile, percentage, 'LootBanditJewelry05');
    rebalanceLVLI(destFile, percentage, 'LootSilverHandRandom');
    rebalanceLVLI(destFile, percentage, 'LootSilverHandGold');
    rebalanceLVLI(destFile, percentage, 'LootPoisonFalmer10');
    rebalanceLVLI(destFile, percentage, 'LootFalmerIngredients25');
    rebalanceLVLI(destFile, percentage, 'LootFalmerOre10');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenScrap10');
    rebalanceLVLI(destFile, percentage, 'LItemGemsSmall');
    rebalanceLVLI(destFile, percentage, 'LootFalmerGems10');
    rebalanceLVLI(destFile, percentage, 'LootFalmerRandomSublist');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithArmor100');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithWeapon100');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithSpecialLoot100');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithSpecialLoot10');
    rebalanceLVLI(destFile, percentage, 'LootFalmerArmor15');
    rebalanceLVLI(destFile, percentage, 'LootFalmerArrows15');
    rebalanceLVLI(destFile, percentage, 'LItemGems');
    rebalanceLVLI(destFile, percentage, 'LootFalmerGems25');
    rebalanceLVLI(destFile, percentage, 'LootFalmerSoulGems25');
    rebalanceLVLI(destFile, percentage, 'LootFalmerWeapon25');
    rebalanceLVLI(destFile, percentage, 'LootFalmerOre25');
    rebalanceLVLI(destFile, percentage, 'LootFalmerGems100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerEnchWeapons25');
    rebalanceLVLI(destFile, percentage, 'LootDraugrEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerOre100');
    rebalanceLVLI(destFile, percentage, 'LootFalmerChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootFalmerGoldBoss');
    rebalanceLVLI(destFile, percentage, 'WIThiefLootSublist');
    rebalanceLVLI(destFile, percentage, 'WIThiefLoot');
    rebalanceLVLI(destFile, percentage, 'LootVampireGold50');
    rebalanceLVLI(destFile, percentage, 'LootBanditChestBossMagicItem25');
    rebalanceLVLI(destFile, percentage, 'LootDraugrEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrChestBossMagicItem25');
    rebalanceLVLI(destFile, percentage, 'LootWarlockArmor15');
    rebalanceLVLI(destFile, percentage, 'LootWarlockEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootWarlockEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootWarlockGems15');
    rebalanceLVLI(destFile, percentage, 'LootWarlockGold');
    rebalanceLVLI(destFile, percentage, 'LootWarlockJewelry15');
    rebalanceLVLI(destFile, percentage, 'LootWarlockSoulGems25');
    rebalanceLVLI(destFile, percentage, 'LootWarlockChestBossMagicItem25');
    rebalanceLVLI(destFile, percentage, 'LootWarlockWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootWarlockSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootWarlockScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootWarlockJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootWarlockGems100');
    rebalanceLVLI(destFile, percentage, 'LootWarlockChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootWarlockSpellTomes00All15');
    rebalanceLVLI(destFile, percentage, 'TG02AringothSafeGoldLoot');
    rebalanceLVLI(destFile, percentage, 'DeathItemDraugrGold');
    rebalanceLVLI(destFile, percentage, 'LootForswornArmor15');
    rebalanceLVLI(destFile, percentage, 'LootForswornGems10');
    rebalanceLVLI(destFile, percentage, 'LItemLootIMineralsProcessed');
    rebalanceLVLI(destFile, percentage, 'LootForswornIngots25');
    rebalanceLVLI(destFile, percentage, 'LootForswornJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootForswornSoulGems20');
    rebalanceLVLI(destFile, percentage, 'LootForswornWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootForswornScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootBanditSoulGems10');
    rebalanceLVLI(destFile, percentage, 'LootDraugrSoulGems20');
    rebalanceLVLI(destFile, percentage, 'LootDraugrWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootBanditWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootBanditArmor25');
    rebalanceLVLI(destFile, percentage, 'LootDraugrArmor25');
    rebalanceLVLI(destFile, percentage, 'LootForswornArmor100');
    rebalanceLVLI(destFile, percentage, 'LootForswornGems100');
    rebalanceLVLI(destFile, percentage, 'LootForswornGold');
    rebalanceLVLI(destFile, percentage, 'LootForswornIngots100');
    rebalanceLVLI(destFile, percentage, 'LootForswornJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootForswornScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootForswornSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootForswornWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootForswornChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootForswornArrows15');
    rebalanceLVLI(destFile, percentage, 'LootForswornEnchArmor25');
    rebalanceLVLI(destFile, percentage, 'LootForswornEnchWeapons25');
    rebalanceLVLI(destFile, percentage, 'LootForswornEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootForswornEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootForswornEnchItem25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenArmor100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenArmor15');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenArrows100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenEnchArmor20');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenEnchWeapons20');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenGems100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenGems25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenIngots100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenIngots10');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenSoulGems15');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenScrap25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenJewelryBoxBase');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfGems100');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfGems10');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfJewelry15');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfSoulGems15');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfWeapon25');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfGold');
    rebalanceLVLI(destFile, percentage, 'LootWerewolfGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootVampireArmor100');
    rebalanceLVLI(destFile, percentage, 'LootVampireArmor10');
    rebalanceLVLI(destFile, percentage, 'LootVampireArrows25');
    rebalanceLVLI(destFile, percentage, 'LootVampireEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootVampireEnchArmor15');
    rebalanceLVLI(destFile, percentage, 'LootVampireEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootVampireEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootVampireGems15');
    rebalanceLVLI(destFile, percentage, 'LootVampireGems100');
    rebalanceLVLI(destFile, percentage, 'LootVampireGold');
    rebalanceLVLI(destFile, percentage, 'LootVampireGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootVampireIngots10');
    rebalanceLVLI(destFile, percentage, 'LootVampireJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootVampireJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootVampireScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootVampireSoulGems25');
    rebalanceLVLI(destFile, percentage, 'LootVampireScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootVampireWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootVampireWeapon10');
    rebalanceLVLI(destFile, percentage, 'LootVampireSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LItemEnchJewelryAll15');
    rebalanceLVLI(destFile, percentage, 'LootVampireChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootHagravenArrows100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenArrows25');
    rebalanceLVLI(destFile, percentage, 'LootHagravenEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenEnchArmor15');
    rebalanceLVLI(destFile, percentage, 'LootHagravenEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootHagravenGems100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenGems15');
    rebalanceLVLI(destFile, percentage, 'LootHagravenJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootHagravenScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootHagravenSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootHagravenSoulGems15');
    rebalanceLVLI(destFile, percentage, 'LootHagravenChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootHagravenGold');
    rebalanceLVLI(destFile, percentage, 'LootHagravenGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsArrows25');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsEnchArmor15');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsGold');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsSoulGems25');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsArmor25');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsArmor25');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsArrows25');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsEnchArmor15');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsGold');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsWeapon15');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsIngots10');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsIngots10');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsEnchWeapons100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsIngots100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsIngots100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsArmor100');
    rebalanceLVLI(destFile, percentage, 'LootCWImperialsChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsEnchArmor100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsArmor100');
    rebalanceLVLI(destFile, percentage, 'LootCWSonsChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootStaffsNecromancy100');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchWeaponsLevel10');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchWeaponsLevel20');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchArmorLevel10');
    rebalanceLVLI(destFile, percentage, 'VendorBlacksmithEnchArmorLevel20');
    rebalanceLVLI(destFile, percentage, 'LootWarlockPotions25');
    rebalanceLVLI(destFile, percentage, 'LootBanditIngots10');
    rebalanceLVLI(destFile, percentage, 'LootBanditJewelry10');
    rebalanceLVLI(destFile, percentage, 'LItemArrowsAllRandomLoot');
    rebalanceLVLI(destFile, percentage, 'LootBanditArrows15');
    rebalanceLVLI(destFile, percentage, 'LootBanditGems10');
    rebalanceLVLI(destFile, percentage, 'LootBanditArmor50');
    rebalanceLVLI(destFile, percentage, 'LootBanditWeapon50');
    rebalanceLVLI(destFile, percentage, 'LootBanditGems25');
    rebalanceLVLI(destFile, percentage, 'LootBanditJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootDraugrArrows15');
    rebalanceLVLI(destFile, percentage, 'LootDraugrGems15');
    rebalanceLVLI(destFile, percentage, 'LootDraugrJewelry15');
    rebalanceLVLI(destFile, percentage, 'LootBanditSoulGems20');
    rebalanceLVLI(destFile, percentage, 'LootDraugrGold');
    rebalanceLVLI(destFile, percentage, 'LootDraugrGoldBoss01');
    rebalanceLVLI(destFile, percentage, 'LootDraugrArmor50');
    rebalanceLVLI(destFile, percentage, 'LootDraugrWeapon25');
    rebalanceLVLI(destFile, percentage, 'LootBanditLockpick25');
    rebalanceLVLI(destFile, percentage, 'LootDraugrLockpick10');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenLockpick15');
    rebalanceLVLI(destFile, percentage, 'LootFalmerLockpick15');
    rebalanceLVLI(destFile, percentage, 'LootForswornLockpick25');
    rebalanceLVLI(destFile, percentage, 'LootHagravenLockpick15');
    rebalanceLVLI(destFile, percentage, 'LootVampireLockpick15');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorArmor75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorWeapon75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorArrows75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorMiscItems75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorAnimalPart75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorGems25');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorMineralsProcessed25');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorMineralsRaw50');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorLockpicks75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorSoulGemFull');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorSoulGemEmpty');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorSoulGem75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorPotion50');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorClothing75');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithArmor75');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithArrows75');
    rebalanceLVLI(destFile, percentage, 'LItemBlacksmithMinimum');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryPotionAllSkills75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryPotionMagicEffects75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryPotionResistances75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryPotionCureHMS75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryPoisonAll75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryIngredientsCommon75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryIngredienstUncommon75');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryIngredienstRare75');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorJewelry25');
    rebalanceLVLI(destFile, percentage, 'LootBanditScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootDraugrScrolls10');
    rebalanceLVLI(destFile, percentage, 'LootDraugrArmor100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrArrows100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrGems100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrScrolls100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootDraugrChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootBanditArmor100');
    rebalanceLVLI(destFile, percentage, 'LootBanditArrows100');
    rebalanceLVLI(destFile, percentage, 'LootBanditGems100');
    rebalanceLVLI(destFile, percentage, 'LootBanditIngots100');
    rebalanceLVLI(destFile, percentage, 'LootBanditJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootBanditSoulGems100');
    rebalanceLVLI(destFile, percentage, 'LootBanditWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootBanditChestBossBase');
    rebalanceLVLI(destFile, percentage, 'LootFalmerCorpseGoldSublist');
    rebalanceLVLI(destFile, percentage, 'LootFalmerCorpseGold');
    rebalanceLVLI(destFile, percentage, 'LootDraugrEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootDraugrEnchArmor15');
    rebalanceLVLI(destFile, percentage, 'LootDraugrEnchArmor25');
    rebalanceLVLI(destFile, percentage, 'LootDraugrEnchWeapons25');
    rebalanceLVLI(destFile, percentage, 'LootBanditEnchArmor15');
    rebalanceLVLI(destFile, percentage, 'LootBanditEnchArmor25');
    rebalanceLVLI(destFile, percentage, 'LootBanditEnchWeapons15');
    rebalanceLVLI(destFile, percentage, 'LootBanditEnchWeapons25');
    rebalanceLVLI(destFile, percentage, 'LootRiftenGold');
    rebalanceLVLI(destFile, percentage, 'LootDraugrArmor10');
    rebalanceLVLI(destFile, percentage, 'LootDraugrSoulGems10');
    rebalanceLVLI(destFile, percentage, 'LootPotionRestoreHMS25');
    rebalanceLVLI(destFile, percentage, 'LootPotionRestoreHS25');
    rebalanceLVLI(destFile, percentage, 'LootPotionRestoreHM25');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorGems100');
    rebalanceLVLI(destFile, percentage, 'LItemMiscVendorJewelry100');
    rebalanceLVLI(destFile, percentage, 'LootGiantAnimalPart75');
    rebalanceLVLI(destFile, percentage, 'LootGiantWeapon50');
    rebalanceLVLI(destFile, percentage, 'LootGiantArmor50');
    rebalanceLVLI(destFile, percentage, 'LootGiantEnchWeapons25');
    rebalanceLVLI(destFile, percentage, 'LootGiantEnchArmor25');
    rebalanceLVLI(destFile, percentage, 'LootGiantGold');
    rebalanceLVLI(destFile, percentage, 'LootGiantSoulGems15');
    rebalanceLVLI(destFile, percentage, 'LootGiantGems25');
    rebalanceLVLI(destFile, percentage, 'CoinPurseGoldSmall');
    rebalanceLVLI(destFile, percentage, 'TGSpellTomes');
    rebalanceLVLI(destFile, percentage, 'CoinPurseGoldMedium');
    rebalanceLVLI(destFile, percentage, 'CoinPurseGoldLarge');
    rebalanceLVLI(destFile, percentage, 'TGCoinPurseGoldLarge');
    rebalanceLVLI(destFile, percentage, 'TGCoinPurseGoldMedium');
    rebalanceLVLI(destFile, percentage, 'TGCoinPurseGoldSmall');
    rebalanceLVLI(destFile, percentage, 'DA07GoldReward01Single');
    rebalanceLVLI(destFile, percentage, 'DA07GoldReward02Triple');
    rebalanceLVLI(destFile, percentage, 'TGLootIngots50');
    rebalanceLVLI(destFile, percentage, 'TGStrongboxLoot');
    rebalanceLVLI(destFile, percentage, 'LootWarlockScrolls05');
    rebalanceLVLI(destFile, percentage, 'LootWarlockSoulGems10');
    rebalanceLVLI(destFile, percentage, 'LootDragonGold');
    rebalanceLVLI(destFile, percentage, 'LootDragonArmor25');
    rebalanceLVLI(destFile, percentage, 'LootDragonWeapon25');
    rebalanceLVLI(destFile, percentage, 'LootDragonGems25');
    rebalanceLVLI(destFile, percentage, 'LItemJewelryRingSmall');
    rebalanceLVLI(destFile, percentage, 'LootSmallTreasure10');
    rebalanceLVLI(destFile, percentage, 'LItemVendorSpellTomes00All50');
    rebalanceLVLI(destFile, percentage, 'LItemLeatherAndStrips75');
    rebalanceLVLI(destFile, percentage, 'LItemEnchJewelryAll75');
    rebalanceLVLI(destFile, percentage, 'LootDraugr1HWeapon100');
    rebalanceLVLI(destFile, percentage, 'LootGoldChangeUrns');
    rebalanceLVLI(destFile, percentage, 'LootPotionRestoreHMSUrns');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenClutter75');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenClutter25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenGoldBoss');
    rebalanceLVLI(destFile, percentage, 'LItemSpecialLoot100');
    rebalanceLVLI(destFile, percentage, 'LootSabrecatBodyParts');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenSpiderSoulGem50');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenSphereSoulGem50');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenCenturionSoulGem');
    rebalanceLVLI(destFile, percentage, 'LootCitizenDrinkList75');
    rebalanceLVLI(destFile, percentage, 'LootCitizenNecklaceList');
    rebalanceLVLI(destFile, percentage, 'LootCitizenNecklaceList25');
    rebalanceLVLI(destFile, percentage, 'LootCitizenRingList');
    rebalanceLVLI(destFile, percentage, 'LootCitizenRingList25');
    rebalanceLVLI(destFile, percentage, 'LootCitizenRingList75');
    rebalanceLVLI(destFile, percentage, 'LootCitizenPocketsCommon');
    rebalanceLVLI(destFile, percentage, 'LootCitizenPocketsPoor');
    rebalanceLVLI(destFile, percentage, 'LootCitizenNecklaceList75');
    rebalanceLVLI(destFile, percentage, 'LootCitizenPocketsRich');
    rebalanceLVLI(destFile, percentage, 'LootCitizenChildToysList');
    rebalanceLVLI(destFile, percentage, 'LootCitizenChildToysList25');
    rebalanceLVLI(destFile, percentage, 'LootCitizenChildToysList75');
    rebalanceLVLI(destFile, percentage, 'LootCitizenPocketsChild');
    rebalanceLVLI(destFile, percentage, 'LootStaffsAll15');
    rebalanceLVLI(destFile, percentage, 'LootStaffsAll25');
    rebalanceLVLI(destFile, percentage, 'LItemSpellVendorScrolls75');
    rebalanceLVLI(destFile, percentage, 'LItemSpellVendorSoulGem75');
    rebalanceLVLI(destFile, percentage, 'LItemSpellVendorStaffsAll75');
    rebalanceLVLI(destFile, percentage, 'LootEnchNecromancerRobes25');
    rebalanceLVLI(destFile, percentage, 'LootEnchWarlockRobes25');
    rebalanceLVLI(destFile, percentage, 'LootStaffsAll');
    rebalanceLVLI(destFile, percentage, 'LItemSkooma75');
    rebalanceLVLI(destFile, percentage, 'LItemMoonsugar75');
    rebalanceLVLI(destFile, percentage, 'LootPoisonFalmer25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenArmor25');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenOre10');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenScrapSpider');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenScrapSphere');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenGems10');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenArrows10');
    rebalanceLVLI(destFile, percentage, 'LootToolRandom05');
    rebalanceLVLI(destFile, percentage, 'LootBanditIngots05');
    rebalanceLVLI(destFile, percentage, 'LootBanditRandom');
    rebalanceLVLI(destFile, percentage, 'LootRingList10');
    rebalanceLVLI(destFile, percentage, 'LootBookRandom05');
    rebalanceLVLI(destFile, percentage, 'LootBanditIngredients10');
    rebalanceLVLI(destFile, percentage, 'LootBanditSpellTomes10');
    rebalanceLVLI(destFile, percentage, 'LootStaffsWeaponBandit');
    rebalanceLVLI(destFile, percentage, 'LootBanditRandomWizard');
    rebalanceLVLI(destFile, percentage, 'LootFurnitureGemsJewelry50');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryRecipesCommon100');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryRecipesPoisons50');
    rebalanceLVLI(destFile, percentage, 'LItemApothecaryRecipesRare50');
    rebalanceLVLI(destFile, percentage, 'LootEnchRobes15');
    rebalanceLVLI(destFile, percentage, 'LootEnchRobes10');
    rebalanceLVLI(destFile, percentage, 'LItemEnchRobes75');
    rebalanceLVLI(destFile, percentage, 'LootMiningToolRandom05');
    rebalanceLVLI(destFile, percentage, 'LootFalmerRandom');
    rebalanceLVLI(destFile, percentage, 'LootFalmerSpecialArrows10');
    rebalanceLVLI(destFile, percentage, 'LootFalmerRandomShaman');
    rebalanceLVLI(destFile, percentage, 'LootFalmerRestoreHealth50');
    rebalanceLVLI(destFile, percentage, 'LootForswornFood10');
    rebalanceLVLI(destFile, percentage, 'LootForswornRawMeat25');
    rebalanceLVLI(destFile, percentage, 'LootForswornRecipes05');
    rebalanceLVLI(destFile, percentage, 'LootForswornCorpseGold');
    rebalanceLVLI(destFile, percentage, 'LootForswornSoulGems10');
    rebalanceLVLI(destFile, percentage, 'LootForswornPotions10');
    rebalanceLVLI(destFile, percentage, 'LootForswornRandom');
    rebalanceLVLI(destFile, percentage, 'LootForswornIngredients10');
    rebalanceLVLI(destFile, percentage, 'LootStaffsWeaponForsworn');
    rebalanceLVLI(destFile, percentage, 'LootForswornIngredients25');
    rebalanceLVLI(destFile, percentage, 'LootForswornRandomWizard');
    rebalanceLVLI(destFile, percentage, 'LootDraugrIngots05');
    rebalanceLVLI(destFile, percentage, 'LootDraugrJewelry05');
    rebalanceLVLI(destFile, percentage, 'LootDraugrSoulGems05');
    rebalanceLVLI(destFile, percentage, 'LootDraugrRandom');
    rebalanceLVLI(destFile, percentage, 'LootDraugrSpellTomes05');
    rebalanceLVLI(destFile, percentage, 'LootDraugrRandomMageBonus');
    rebalanceLVLI(destFile, percentage, 'LootWarlockPotions10');
    rebalanceLVLI(destFile, percentage, 'LootWarlockIngredients10');
    rebalanceLVLI(destFile, percentage, 'LootWarlockIngredients25');
    rebalanceLVLI(destFile, percentage, 'LootWarlockRecipes05');
    rebalanceLVLI(destFile, percentage, 'LootWarlockCorpseGoldSublist');
    rebalanceLVLI(destFile, percentage, 'LootWarlockCorpseGold');
    rebalanceLVLI(destFile, percentage, 'LootWarlockRandom');
    rebalanceLVLI(destFile, percentage, 'LootStaffsWeaponWarlock');
    rebalanceLVLI(destFile, percentage, 'LootWarlockSoulGemsNecroBonus');
    rebalanceLVLI(destFile, percentage, 'DeathItemVampireGold');
    rebalanceLVLI(destFile, percentage, 'LootVampireJewelry15');
    rebalanceLVLI(destFile, percentage, 'LootVampireRandom');
    rebalanceLVLI(destFile, percentage, 'LootStaffsWeaponVampire');
    rebalanceLVLI(destFile, percentage, 'DeathItemThalmorGold');
    rebalanceLVLI(destFile, percentage, 'LootThalmorDrinkList25');
    rebalanceLVLI(destFile, percentage, 'LootThalmorRandom');
    rebalanceLVLI(destFile, percentage, 'LootThalmorRandomWizard');
    rebalanceLVLI(destFile, percentage, 'LootDwarvenArrowsBest');
    rebalanceLVLI(destFile, percentage, 'LootUrnGoldChange');
    rebalanceLVLI(destFile, percentage, 'LootUrnSmallTreasure30');
    rebalanceLVLI(destFile, percentage, 'LootBurntCorpse');
    rebalanceLVLI(destFile, percentage, 'LootSpiderCorpseHuman');
    if Assigned(npcFileToH) then begin
        AddMasterDependencies(npcFileToH, destFile);
    end;
    rebalancePotionLVLI(destFile, percentage, 'LootFalmerChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootFalmerChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootWarlockChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootWarlockChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootBanditChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootDraugrChestPotions25');
    rebalancePotionLVLI(destFile, percentage, 'LootDraugrChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootForswornChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootForswornChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootDwavenChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootDwarvenChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootWerewolfChestPotions25');
    rebalancePotionLVLI(destFile, percentage, 'LootWerewolfChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootVampireChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootVampireChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootHagravenChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootHagravenChestPotions25');
    rebalancePotionLVLI(destFile, percentage, 'LootCWImperialsChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootCWSonsChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootCWImperialsChestPotions25');
    rebalancePotionLVLI(destFile, percentage, 'LootCWSonsChestPotions25');
    rebalancePotionLVLI(destFile, percentage, 'LootBanditChestPotions100');
    rebalancePotionLVLI(destFile, percentage, 'LootDraugrChestPotions15');
    rebalancePotionLVLI(destFile, percentage, 'LootDraugrChestPotions05');
end;
function makeSingletonOutfit(destFile: IwbFile; otftId: string; lvli: IwbMainRecord): IwbMainRecord;
var
    o: IwbElement;
begin
    Result := MainRecordByEditorID(outfitRecordGroup, otftId);
    if not Assigned(Result) then begin
        Result := Add(outfitRecordGroup, 'OTFT', true);
        SetEditorID(Result, otftId);
        o := Add(Result, 'INAM', true);
        o := Add(o, 'Item', true);
        ElementAssign(o, LowInteger, lvli, false);
    end;
    if not Assigned(Result) then begin raise Exception.Create('Failed creating singleton outfit: '+otftId) end;
end;
function combineLVLI(destFile: IwbFile; combinedLvliId, lvliIdsToCombine, suffix: string): IwbMainRecord;
var
    lvliId:string;
    stop : integer;
    i : integer;
    j : integer;
    atPos: integer;
    repeats: integer;
    hashTagCount : integer;
    e : IwbMainRecord;
begin
    if lvliIdsToCombine[1] <> '#' then begin raise Exception.Create('No hashtag at the begining in:'+lvliIdsToCombine) end;
    lvliIdsToCombine := copy(lvliIdsToCombine, 2, length(lvliIdsToCombine)-1);
    if lvliIdsToCombine[1] = '#' then begin raise Exception.Create('Hashtag at the begining in:'+lvliIdsToCombine) end;

    for i := 1 to length(lvliIdsToCombine) do begin
      if lvliIdsToCombine[i] = '#' then begin
        e := newLVLI(nil, destFile, combinedLvliId, '0', '0', '1', '0');
        Result := MainRecordByEditorID(GroupBySignature(destFile, 'LVLI'), combinedLvliId);
        if not Assigned(e) then begin // record already exists
            exit;
        end;
        AddMessage('Combining '+lvliIdsToCombine+' (with suffix='+suffix+') into '+combinedLvliId);
        while length(lvliIdsToCombine) > 0 do begin
          stop := pos('#', lvliIdsToCombine);
          if stop = 0 then begin stop := length(lvliIdsToCombine)+1; end;
          lvliId := copy(lvliIdsToCombine, 1, stop-1);
          lvliIdsToCombine := copy(lvliIdsToCombine, stop+1, length(lvliIdsToCombine)-stop);
          atPos := pos('@', lvliId);
          repeats := 1;
          if atPos <> 0 then begin
            repeats := StrToInt(copy(lvliId, 1, atPos-1));
            lvliId := copy(lvliId, atPos+1, length(lvliId)-atPos);
          end;
          for j:=1 to repeats do begin
            addToLVLI(e, destFile, 'LVLI', lvliId+suffix, '1', '1');
          end;
        end;
        RemoveByIndex(e, 0, true);
        exit;
      end;
    end;
    AddMessage('One element to combine '+lvliIdsToCombine+suffix+'. Skipping '+combinedLvliId);
    Result := MainRecordByEditorID(lvliRecordGroup, lvliIdsToCombine+suffix);
    if not Assigned(Result) then begin raise Exception.Create('LVLI Not found: '+lvliIdsToCombine+suffix) end;
end;


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/// END OF THE AUTO-GENERATED PART
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

function Initialize : integer;
var
    f: IwbFile;
    fname: string;
    i: integer;
    frm: TForm;
    frmNPC: TForm;
    frmBook: TForm;
    clb: TCheckListBox;
    clbNPC: TCheckListBox;
    clbBook: TCheckListBox;
    newFileName: string;
    numSpecialItems: integer;
    
    scarcityRate: integer;
begin
    hasPantiesofskyrim := false;
    hasTAWOBA := false;
    hasTEWOBA := false;
    hasCoT := false;
    hasModularMage := false;
    frm := frmFileSelect;
    frmNPC := frmFileSelect;
    frmBook := frmFileSelect;
    try
        // Initialize dialog
        frm.Caption := 'Select destination for the patch';
        clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
        clb.Items.Add('<new file (patch)>');
        //TODO: clb.Items.Add('<new file (smash)>');
        clb.Items.Add('<new file (patch) - ESL flagged>');
        //TODO: clb.Items.Add('<new file (smash) - ESL flagged>');
        numSpecialItems := 2;

        frmNPC.Caption := 'Select mods to copy female NPCs from';
        clbNPC := TCheckListBox(frmNPC.FindComponent('CheckListBox1'));
        clbNPC.Items.Add('<only copy npcs, don''t create female armor patches>');
        clbNPC.Items.Add('<make player start naked (compatible with alternate start)>');
        clbNPC.Checked[1] := true;
        clbNPC.Items.Add('<rebalance loot (like in Scarcity mod)>');
        clbNPC.Checked[2] := true;
        clbNPC.Items.Add('<rebalance item worth (eg. lingerie is too expensive)>');
        clbNPC.Checked[3] := true;
        clbNPC.Items.Add('<add books to leveled lists (eg. TAWOBA crafting books will appear anywhere)>');
        clbNPC.Checked[4] := true;
        numSpecialNpcItems := 5;

        frmBook.Caption := 'Books to add to lvli (close to skip)';
        clbBook := TCheckListBox(frmBook.FindComponent('CheckListBox1'));

        for i := 0 to Pred(FileCount) do begin
            f := FileByIndex(i);
            fname := GetFileName(f);
            clb.Items.InsertObject(numSpecialItems, fname, f);
            clbNPC.Items.InsertObject(numSpecialNpcItems, fname, f);
            clbBook.Items.InsertObject(0, fname, f);
            if fname = 'The Amazing World of Bikini Armors REMASTERED.esp' then begin
                hasTAWOBA := true;
                fileTAWOBA := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'TAWOBA Remastered Leveled List.esp' then begin
                fileTAWOBALeveledList := f;
            end else if fname = 'pantiesofskyrim.esp' then begin
                hasPantiesofskyrim := true;
                filePantiesofskyrim := f;
            end else if fname = '[Imp] Modular Mage.esp' then begin
                hasModularMage := true;
                fileModularMage := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '(Pumpkin)-TEWOBA-TheExpandedWorldofBikiniArmor.esp' then begin
                hasTEWOBA := true;
                fileTEWOBA := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            // end else if fname = 'alagris_smash.esp' then begin
            //     destinationFile := f;
            end else if fname = 'Skyrim.esm' then begin
                fileSkyrim := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'unofficial skyrim special edition patch.esp' then begin
                fileUSSEP := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'Update.esm' then begin
                fileUpdate := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'Devious Lore.esp' then begin
                fileDeviousLore := f;
            end else if fname = '[COCO]Bikini Collection.esp' then begin
                fileCocoBikini := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'sirwho_Wizard_Hats-Full.esp' then begin 
                fileWizardHats := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'sirwho_Witchy_Wizard_Hats-Full.esp' then begin 
                fileWitchyHats := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO]Lingerie.esp' then begin 
                fileCocoLingerie := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Lace Lingerie Pack.esp' then begin 
                fileCocoLace := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Witchiness.esp' then begin 
                fileCocoWitch := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Demon Shade.esp' then begin   
                fileCocoDemon := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Shadow Assassin.esp' then begin   
                fileCocoAssassin := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] DS Chosen Undead.esp' then begin   
                fileChristineUndead := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] Nocturnal''s Embrace.esp' then begin   
                fileChristineNocturnal := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] Black Magic Grove.esp' then begin   
                fileChristineBlackMagic := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] Deadly Desire.esp' then begin   
                fileChristineDeadlyDesire := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] High Priestess Bikini.esp' then begin   
                fileChristinePriestess := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] Exnem Demonic.esp' then begin   
                fileChristineExnem := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'HS2_bunyCostume.esp' then begin 
                fileHS2Bunny := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'KSO Mage Robes.esp' then begin 
                fileKSOMage := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Caenarvon] Magecore.esp' then begin 
                fileMegacore := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'ID_Skimpy Maid Outfits.esp' then begin 
                fileSkimpyMaid := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'DX Fetish Fashion Volume 1 SE.esp' then begin 
                fileDXFI := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'DX FetishFashion II.esp' then begin 
                fileDXFII := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'DX StLouis SE.esp' then begin 
                fileDXsT := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] Kitchen Lingerie.esp' then begin 
                fileChristineKitchen := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[NINI] Blacksmith.esp' then begin 
                fileNiniBlacksmith := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Dint999] Fogotten Princess Set.esp' then begin 
                fileForgottenPrincess := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Fairy Queen.esp' then begin 
                fileFairyQueen := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Ahri Uniforms.esp' then begin 
                fileCocoAhri := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[NINI] Cat Maid.esp' then begin 
                fileNiniCatMaid := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[NINI] Chat Noir.esp' then begin 
                fileNiniChatNoir := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'alternate start - live another life.esp' then begin 
                fileAlternateStart := f;
            end else if fname = 'Shino_School_Uniform.esp' then begin 
                fileShinoSchool := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Christine] GoW3 - Aphrodite Dress.esl' then begin
                fileChristineAphrodite := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Dint999] SecretChildOfTalos.esp' then begin
                fileChildOfTalos := f;
                hasCoT := true;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'Slave Outfit.esp' then begin
                fileCocoSlave := f; 
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[COCO] Lolita.esp' then begin
                fileCocoLolita := f; 
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[Melodic] Reverse Bunnysuit.esp' then begin
                fileMelodicBunny := f; 
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'Haru Bondage.esp' then begin
                fileHaruBondage := f; 
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = '[dint999] MysteriousKnightSet.esp' then begin
                fileMystKnight := f;
                clbBook.Checked[0] := Assigned(GroupBySignature(f, 'BOOK'));
            end else if fname = 'hydra_slavegirls.esp' then begin
                npcFileHydSlavegirls := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'Dawnguard.esm' then begin
                npcFileDawnguard := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'The Ancient Profession.esp' then begin
                npcFileAnciProf := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'Dragonborn.esm' then begin
                npcFileDragonborn := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'HearthFires.esm' then begin
                npcFileHearthfires := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'ccbgssse069-contest.esl' then begin
                npcFileCCContest := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'ccbgssse068-bloodfall.esl' then begin
                npcFileCCBloodfall := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'ccBGSSSE025-AdvDSGS.esm' then begin
                npcFileCCAdv := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'MoreBanditCamps.esp' then begin
                npcFileMoreBCamp := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'MiasLair.esp' then begin
                npcFileMiasL := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'SexLab-AmorousAdventures.esp' then begin
                npcFileAAvd := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'JKs Skyrim.esp' then begin
                npcFileJKsS := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'SexLab_DibellaCult.esp' then begin
                npcFileSoD := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'SexLab_DibellaCult_Sisters.esp' then begin
                npcFileSoDs := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'troublesofheroine.esp' then begin
                npcFileToH := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'SimpleSlavery.esp' then begin
                npcFileSimSlav := f;
                clbNPC.Checked[numSpecialNpcItems] := true;
            end else if fname = 'SKYGIRL BOOK Playboy M1.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK Playboy 90s.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK Playboy 80s.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK Playboy 70s.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK Playboy 60s.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK Playboy 50s.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK 3.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK 2.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK 1.esp' then begin
                clbBook.Checked[0] := true;
            end else if fname = 'SKYGIRL BOOK.esp' then begin
                clbBook.Checked[0] := true;
            end;
        end;
        if not Assigned(destinationFile) then begin
            // Check if OK was pressed
            if frm.ShowModal <> mrOk then begin
                Result := 676;
                Exit;
            end;
            AddMessage('Script starting');
            // Check which item was selected
            for i := 0 to Pred(clb.Items.Count) do begin
                if clb.Checked[i] then begin
                    if Assigned(GroupBySignature(ObjectToElement(clb.Items.Objects[i]), 'BOOK')) then begin
                        clbBook.Checked[i] := true;
                    end;
                    if i >= numSpecialItems then begin
                        destinationFile := ObjectToElement(clb.Items.Objects[i]);
                        AddMessage('Destination file= '+GetFileName(destinationFile));
                        Break;
                    end else begin
                        if frmNPC.ShowModal <> mrOk then begin
                            Result := 1;
                            Exit;
                        end;
                        if not InputQuery('Create new mod', 'Name (default=alagris_smash)', newFileName) then begin
                            Result := 45;
                            Exit;
                        end else if not Assigned(newFileName) or (newFileName='') then begin
                            newFileName := 'alagris_smash.esp';
                        end;
                        if not EndsStr('.esp', newFileName) then begin
                            newFileName := newFileName + '.esp';
                        end;
                        if Assigned(FileByName(newFileName)) then begin
                            AddMessage('Mod '+newFileName+' already exists');
                            Result := 43346;
                            exit;
                        end;
                        AddMessage('Generating smash');
                        destinationFile := GenerateSmash(newFileName, clbNPC, false);
                        if i = 1 then begin
                            SetElementNativeValues(ElementByIndex(destinationFile, 0), 'Record Header\Record Flags\ESL', 1);
                        end;
                        if clbNPC.Checked[2] then begin
                            if InputQuery('How much to rebalance the loot?', 'Percentage (default=15, set 100 to skip)', scarcityRate) then begin
                                AddMessage('Rebalance rate='+IntToStr(scarcityRate));
                                if not Assigned(scarcityRate) then begin
                                    scarcityRate := 15;
                                end else begin
                                    scarcityRate := StrToInt(scarcityRate);
                                end;
                                scarcityRate := max(scarcityRate, 1);
                                AddMessage('Rebalance rate (int)='+IntToStr(scarcityRate));
                                if scarcityRate < 100 then begin
                                    rebalanceLoot(destinationFile, scarcityRate);
                                end;
                            end;
                        end;
                        if clbNPC.Checked[4] and IsAnyChecked(clbBook) then begin
                            if frmBook.ShowModal = mrOk then begin
                                AddAllBooksToLVLI(destinationFile, clbBook);
                            end;
                        end;
                        AddMessage('New patch '+GetFileName(destinationFile)+' created successfully! Script will now terminate.');
                        Result := 489;
                        exit;
                    end;
                end;
            end;
        end;
        if not Assigned(destinationFile) then begin
            Result := 1;
            AddMessage('No destination selected. Aborting');
        end else begin
            SetupRecordGroups(destinationFile);
            Result := generateLvlListsAndEnchArmorForClothingMods(destinationFile, false);
        end;
    finally
        frm.Free;
    end;
    
end;    

function SetupRecordGroups(destFile: IwbFile): integer;
begin 
    destinationFile := destFile;
    outfitRecordGroup := GroupBySignature(destFile, 'OTFT');
    if not Assigned(outfitRecordGroup) then begin
        outfitRecordGroup := Add(destFile, 'OTFT', true);
    end;
    lvlnRecordGroup := GroupBySignature(destFile, 'LVLN');
    if not Assigned(lvlnRecordGroup) then begin
        lvlnRecordGroup := Add(destFile, 'LVLN', true);
    end;
    npcRecordGroup := GroupBySignature(destFile, 'NPC_');
    if not Assigned(npcRecordGroup) then begin
        npcRecordGroup := Add(destFile, 'NPC_', true);
    end;
    lvliRecordGroup := GroupBySignature(destFile, 'LVLI');
    if not Assigned(lvliRecordGroup) then begin
        lvliRecordGroup := Add(destFile, 'LVLI', true);
    end;
    AddMessage('outfitRecordGroup='+FullPath(outfitRecordGroup));
    AddMessage('lvlnRecordGroup='+FullPath(lvlnRecordGroup));
    AddMessage('npcRecordGroup='+FullPath(npcRecordGroup));
    AddMessage('lvliRecordGroup='+FullPath(lvliRecordGroup));
    if not Assigned(fileUSSEP) then begin
        fileUSSEP := fileSkyrim;
    end;
    if not Assigned(fileAlternateStart) then begin
        fileAlternateStart := fileUSSEP;
    end;
end;
function BoolToStr(B: Boolean): string;
begin 
  if B then begin Result := '1' end else begin Result := '0'; end;
end;
function CheckIfEmptyLVLN(leveled_npc: IwbElement): IwbElement;
var
    items: IwbElement;
begin
    Result := nil;
    items := ElementByPath(leveled_npc, 'Leveled List Entries');
    if ElementCount(items) = 0 then exit;
    items := ElementByIndex(items, 0);
    items := ElementByPath(items, 'LVLO\Reference');
    if not Assigned(items) then exit;
    Result := leveled_npc;
end;

function RecursiveCopyLVLN(leveled_npc: IInterface): IwbElement;
var
    recordSignature: string;
    recordGroup: IInterface;
    newItems: IwbElement;
    oldItems: IwbElement;
    oldItem: IwbElement;
    newItem: IwbElement;
    converted_npc: IwbElement;
    i: integer;
begin
    recordSignature := Signature(leveled_npc);
    if recordSignature = 'NPC_' then begin
        AddMessage('RecursiveCopyLVLN calls RecursiveCopyNPC('+Name(leveled_npc)+')');
        Result := RecursiveCopyNPC(leveled_npc, true);
        exit;
    end;
    
    if recordSignature <> 'LVLN' then exit;
    
    recordSignature := EditorID(leveled_npc);
    if Assigned(MainRecordByEditorID(lvlnRecordGroup, recordSignature)) then begin
        leveled_npc := MainRecordByEditorID(lvlnRecordGroup, recordSignature);
    end;
    if EndsStr('F', recordSignature) then begin 
        Result := CheckIfEmptyLVLN(leveled_npc);
        AddMessage('LVLN '+EditorID(leveled_npc)+' already female '+EditorID(Result));
        exit;
    end; 
    recordGroup := GroupBySignature(GetFile(leveled_npc), 'LVLN');
    if EndsStr('M', recordSignature) then begin 
        recordSignature := copy(recordSignature, 1, length(recordSignature)-1);
    end;
    recordSignature := recordSignature+'F';

    Result := CheckIfEmptyLVLN(MainRecordByEditorID(recordGroup, recordSignature));
    if Assigned(Result) then begin
        AddMessage('LVLN (original) '+EditorID(leveled_npc)+' -> '+EditorID(Result));
        exit;
    end;

    Result := CheckIfEmptyLVLN(MainRecordByEditorID(lvlnRecordGroup, recordSignature));
    if Assigned(Result) then begin 
        AddMessage('LVLN (already converted) '+EditorID(leveled_npc)+' -> '+EditorID(Result));
        exit;
    end;

    Result := wbCopyElementToFileWithPrefix(leveled_npc, destinationFile, true, true, '', '', '');
    SetEditorID(Result, recordSignature);   
      
    oldItems := ElementByPath(leveled_npc, 'Leveled List Entries');
    newItems := ElementByPath(Result, 'Leveled List Entries');
    AddMessage('Count: '+IntToStr(ElementCount(oldItems))+' of '+FullPath(oldItems));
    for i := 0 to ElementCount(oldItems)-1 do begin
        oldItem := ElementByIndex(oldItems, i);
        newItem := ElementByIndex(newItems, i);             
        oldItem := ElementByPath(oldItem, 'LVLO\Reference'); 
        oldItem := LinksTo(oldItem);
        AddMessage(EditorID(Result)+' calls RecursiveCopyLVLN('+Name(oldItem)+')');
        converted_npc := RecursiveCopyLVLN(oldItem);
        AddMessage('LVLN (item '+IntToStr(i)+')'+EditorID(Result)+':'+EditorID(oldItem)+'->'+EditorID(converted_npc));
        SetElementEditValues(newItem, 'LVLO\Reference', Name(converted_npc));
    end;
end;


function CopyOutfit(oldOutfitRecord: IwbElement): IwbElement;
var
    newOutfitRecordId: string;
begin
    newOutfitRecordId := EditorID(oldOutfitRecord);
    if EndsStr('M', newOutfitRecordId) then begin
        newOutfitRecordId := copy(newOutfitRecordId, 1, length(newOutfitRecordId)-1);
    end;
    if not EndsStr('F', newOutfitRecordId) then begin
        newOutfitRecordId := newOutfitRecordId + 'F';
    end;
    Result := MainRecordByEditorID(outfitRecordGroup, newOutfitRecordId);
      
    if not Assigned(Result) then begin
        Result := wbCopyElementToFileWithPrefix(oldOutfitRecord, destinationFile, true, true, '', '', '');
        SetEditorID(Result, newOutfitRecordId);
        ModifyFemaleOutfit(oldOutfitRecord, Result);
    end;
end;

function RecursiveCopyLVLI(oldRecord: IwbElement): IwbElement;
var
    newOutfitRecordId: string;
begin
    newOutfitRecordId := EditorID(oldRecord);
    if EndsStr('M', newOutfitRecordId) then begin
        newOutfitRecordId := copy(newOutfitRecordId, 1, length(newOutfitRecordId)-1);
    end;
    if not EndsStr('F', newOutfitRecordId) then begin
        newOutfitRecordId := newOutfitRecordId + 'F';
    end;

    Result := MainRecordByEditorID(lvliRecordGroup, newOutfitRecordId);
    AddMessage('LVLI (record) ' + FullPath(outfitRecordGroup) +' -> '+newOutfitRecordId+' = '+FullPath(Result));  
    if not Assigned(Result) then begin
        Result := wbCopyElementToFileWithPrefix(oldRecord, destinationFile, true, true, '', '', '');
        SetEditorID(Result, newOutfitRecordId);
        ModifyFemaleOutfit(oldRecord, Result);
    end;
end;

function AddListElement(newItems: IwbElement; newItemReference:IwbMainRecord; isLVLI: Boolean): IwbElement;
var
    newItem: IwbElement;
begin
    Result := newItemReference;
    if isLVLI then begin 
        newItem := Add(newItems, 'Leveled List Entry', true);
        AddMessage('LVLI (add) '+FullPath(newItem)+'='+GetElementEditValues(newItem, 'LVLO\Reference')+' -> '+EditorID(newItemReference)+' ['+FullPath(oldItem)+']');
        SetElementNativeValues(newItem, 'LVLO\Count', 1);
        SetElementNativeValues(newItem, 'LVLO\Level', 1);
        ElementAssign(ElementByPath(newItem, 'LVLO\Reference'), LowInteger, newItemReference, false);
    end else begin
        AddMessage('OTFT (add) '+GetEditValue(newItem)+' -> '+EditorID(newItemReference));
        ElementAssign(newItems, HighInteger, newItemReference, false);    
    end;
end;


function TransferListElement(oldItem, newItems: IwbElement; newItemReference:IwbMainRecord; isLVLI: Boolean): IwbElement;
var
    newItem: IwbElement;
begin
    Result := newItemReference;
    if isLVLI then begin 
        newItem := Add(newItems, 'Leveled List Entry', true);
        AddMessage('LVLI (transfer) '+FullPath(newItem)+'='+GetElementEditValues(newItem, 'LVLO\Reference')+' -> '+EditorID(newItemReference)+' ['+FullPath(oldItem)+']');
        SetElementNativeValues(newItem, 'LVLO\Count', GetElementNativeValues(oldItem, 'LVLO\Count'));
        SetElementNativeValues(newItem, 'LVLO\Level', GetElementNativeValues(oldItem, 'LVLO\Level'));
        ElementAssign(ElementByPath(newItem, 'LVLO\Reference'), LowInteger, newItemReference, false);
    end else begin
        AddMessage('OTFT (transfer) '+GetEditValue(newItem)+' -> '+EditorID(newItemReference));
        ElementAssign(newItems, HighInteger, newItemReference, false);    
    end;
end;


function ModifyFemaleOutfit(oldOutfitRecord, newOutfitRecord: IwbElement): IwbElement;
var
    isLVLI: Boolean;
    oldItemId: string;
    oldItemPrefix: string;
    tawobaItemId: string;
    pantiesItemId: string;
    i: integer;
    oldOutfitRef: IwbElement;
    oldOutfitItems: IwbElement;
    oldOutfitItem: IwbElement;
    oldOutfitId: string;
    newOutfitItems: IwbElement;
    newOutfitItem: IwbElement;
    newOutfitRef: IwbElement;
    femaleLVLI: IwbElement;
    recordSignature: string;
    recGrp: IwbGroupRecord;
    removeOldItem: Boolean;
    isBandit: Boolean;
    isBanditBoss: Boolean;
    magicType: string;
    magicLevel: string;
    pantiesFinal: string;
    usedTAWOBABody: string;
    usesMage: Boolean;
begin      
    if not Assigned(oldOutfitRecord) then begin raise Exception.Create('old outfit is nil') end;
    if not Assigned(newOutfitRecord) then begin raise Exception.Create('new outfit is nil') end;
    (* CREATING NEW FEMALE-ONLY ARMOR BASED ON SOME RULES *)
    (* IT CHECKS WHAT ARMOR MODS ARE INSTALLED AND AUTOMATICALLY USES THEM *)
    recordSignature := Signature(oldOutfitRecord);
    isLVLI := recordSignature = 'LVLI';
    oldOutfitId := EditorID(oldOutfitRecord);
    isBandit := pos('Bandit', oldOutfitId) > 0;
    isBanditBoss := pos('Boss', oldOutfitId) > 0;
    pantiesFinal := nil;
    usedTAWOBABody := nil;
    usesMage := false;
    if isLVLI then begin
        oldOutfitItems := ElementByPath(oldOutfitRecord, 'Leveled List Entries');
        newOutfitItems := ElementByPath(newOutfitRecord, 'Leveled List Entries');
    end else begin
        oldOutfitItems := ElementByPath(oldOutfitRecord, 'INAM');
        newOutfitItems := ElementByPath(newOutfitRecord, 'INAM');
        if StartsStr('Armor', oldOutfitId) then begin
            if StartsStr('ArmorStormcloak', oldOutfitId) then begin
                if StartsStr('ArmorStormcloakMarkarth', oldOutfitId) then begin
                    pantiesItemId := 'Panties-TheReach';    
                end else if StartsStr('ArmorStormcloakRiften', oldOutfitId) then begin
                    pantiesItemId := 'Panties-TheRift';    
                end else begin
                    pantiesItemId := 'Panties-Stormcloak';    
                end;
            end else if StartsStr('ArmorHaafingar', oldOutfitId) then begin
                pantiesItemId := 'Panties-Haafingar';    
            end else if StartsStr('ArmorSummerset', oldOutfitId) then begin
                pantiesItemId := 'Panties-Summerset';    
            end;
        end else if StartsStr('hyd_', oldOutfitId) or StartsStr('SSLV_', oldOutfitId) then begin
            if (oldOutfitId = 'hyd_cell_zyx_basegd') and Assigned(fileShinoSchool) then begin
                newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'Shino set');
                if not Assigned(newOutfitRef) then begin raise Exception.Create('unreachable'); end;
            end else if (oldOutfitId = 'hyd_out_cleaningslave') and Assigned(AnyBarkeeper) then begin
                newOutfitRef := AnyBarkeeper;
                if not Assigned(newOutfitRef) then begin raise Exception.Create('unreachable'); end;
            end else if (oldOutfitId = 'hyd_out_slavegirl1_sg20') and Assigned(fileNiniChatNoir) then begin
                newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'NINI ChatNoir');
                if not Assigned(newOutfitRef) then begin raise Exception.Create('unreachable'); end;
            end else begin
                if StartsStr('SSLV_', oldOutfitId) then begin
                    newOutfitRef := AnyPrisoner;
                end else begin
                    newOutfitRef := AnyLingerie;
                end;
                if Assigned(newOutfitRef) then begin
                    if ElementCount(oldOutfitItems) > 0 then begin
                        removeOldItem := false; // checking if this is a slave 
                        for i := ElementCount(oldOutfitItems)-1 downto 0 do begin
                            oldOutfitItem := ElementByIndex(oldOutfitItems, i);
                            oldItemId := GetEditValue(oldOutfitItem);
                            if StartsStr('zbf', oldItemId)  then begin
                                removeOldItem := true;
                            end;
                            if Assigned(KitchenLingerie) and StartsStr('ClothesChef', oldItemId)  then begin
                                newOutfitRef := KitchenLingerie;
                            end;
                        end;
                        if not removeOldItem then begin
                            newOutfitRef := nil; // it's actually not a slave
                        end;
                        removeOldItem := nil;
                    end;
                    
                end;
            end;
            if Assigned(newOutfitRef) then begin
                for i := ElementCount(newOutfitItems)-1 downto 0 do begin
                    newOutfitItem := ElementByIndex(newOutfitItems, i);
                    oldItemId := GetEditValue(newOutfitItem);
                    if StartsStr('Clothes', oldItemId)  then begin
                        RemoveElement(newOutfitItems, newOutfitItem);
                    end;
                end;
            end;
        end else if StartsStr('College', oldOutfitId) then begin
        end else if StartsStr('Guard', oldOutfitId) then begin
            if StartsStr('GuardFalkreath', oldOutfitId) then begin
                pantiesItemId := 'Panties-Falkreath';
            end else if StartsStr('GuardPale', oldOutfitId) then begin
                pantiesItemId := 'Panties-ThePale';
            end else if StartsStr('Whiterun', oldOutfitId) then begin
                pantiesItemId := 'Panties-Whiterun';
            end else if StartsStr('Winterhold', oldOutfitId) then begin
                pantiesItemId := 'Panties-Winterhold';
            end else if StartsStr('GuardSons', oldOutfitId) then begin
                pantiesItemId := 'Panties-Stormcloak';
            end else if StartsStr('GuardOutfit', oldOutfitId) then begin
                if StartsStr('GuardOutfitHjaalmarch', oldOutfitId) then begin
                    pantiesItemId := 'Panties-Hjaalmarch';
                end else if StartsStr('GuardOutfitRift', oldOutfitId) then begin
                    pantiesItemId := 'Panties-TheRift';
                end;
            end;
        end else if StartsStr('DLC1', oldOutfitId) then begin
            if oldOutfitId = 'DLC1LD_KatriaOutfit' then begin
                pantiesItemId := 'Panties-Steel';    
            end else if oldOutfitId = 'DLC1OutfitSorine' then begin
                pantiesItemId := 'Panties-Dawnguard-Light';
            end else if StartsStr('DLC1OutfitDawnguard', oldOutfitId) then begin
                if EndsStr('Heavy', oldOutfitId) then begin
                    pantiesItemId := 'Panties-Dawnguard-Heavy';
                end else begin
                    pantiesItemId := 'Panties-Dawnguard-Light';
                end;
            end;
        end else if StartsStr('CidhnaMineGuardOutfit', oldOutfitId) then begin
            pantiesItemId := 'Panties-TheReach';    
        end else if StartsStr('ReachHoldGuardOutfit', oldOutfitId) then begin
            pantiesItemId := 'Panties-TheReach';    
        end else if StartsStr('Clothes', oldOutfitId) then begin
        end else if StartsStr('CW', oldOutfitId) then begin
            if pos('Sons', oldOutfitId) > 0 then begin
                pantiesItemId := 'Panties-Stormcloak';    
            end else if oldOutfitId = 'CWSiegeArmorImperialWhiterunOutfit' then begin
                pantiesItemId := 'Panties-Whiterun';    
            end;
        end else if oldOutfitId = 'MavenBlackBriarOutfit' then begin
            pantiesItemId := 'Panty-Tangang-Maven-1';    
        end else if StartsStr('Jarl', oldOutfitId) then begin
            if StartsStr('JarlClothesElisif', oldOutfitId) then begin
                pantiesItemId := 'Panty-Control-Elisif-1';    
            end else if StartsStr('JarlClothesLaila', oldOutfitId) then begin
                pantiesItemId := 'Panty-Tangang-Laila-1';    
            end;
        end else if StartsStr('PlayerHousecarlOutfit', oldOutfitId) then begin
            pantiesItemId := 'Panties-Housecarl';    
        end else if StartsStr('Hunter', oldOutfitId) then begin
            pantiesItemId := 'Panties-Hunter';    
        end else if StartsStr('ThievesGuild', oldOutfitId) then begin
            if oldOutfitId='ThievesGuildKarliahOutfit' then begin
                pantiesItemId := 'Panties-TG-Karliah';    
            end else if oldOutfitId='ThievesGuildSapphireOutfit' then begin
                pantiesItemId := 'Panties-TG-Sapphire';    
            end else if oldOutfitId='ThievesGuildToniliaOutfit' then begin
                pantiesItemId := 'Panties-TG-Tonilia';    
            end else if oldOutfitId='ThievesGuildVexOutfit' then begin  
                pantiesItemId := 'Panties-TG-Vex';   
            end;
        end else if StartsStr('MonkOutfit', oldOutfitId) then begin
            pantiesItemId := 'Panties-Monk-1-Basic';    
        end else if StartsStr('DA05Hunter', oldOutfitId) then begin
            pantiesItemId := 'Panties-Hunter';    
        end else if StartsStr('Dawnguard', oldOutfitId) then begin
            pantiesItemId := 'Panties-Dawnguard-Light';    
        end else if StartsStr('DB', oldOutfitId) then begin
            if oldOutfitId = 'DBWeddingOutfit' then begin
                pantiesItemId := 'Panty-Thongsimple-Bride-1';    
            end else begin
                pantiesItemId := 'Panties-DB';    
            end;
        end else if StartsStr('DA13', oldOutfitId) then begin
            if (oldOutfitId = 'DA13HeavyOutfit') or (oldOutfitId = 'DA13LightOutfit') then begin
                pantiesItemId := 'Panties-Bandits';    
            end else if (oldOutfitId = 'DA13MissileOutfit') or (oldOutfitId = 'DA13RobeOutfit') then begin
                pantiesItemId := 'Panties-Afflicted';    
            end;
        end else if StartsStr('DLC2', oldOutfitId) then begin    
            if StartsStr('DLC2SV02Thalmor', oldOutfitId) then begin    
                pantiesItemId := 'Panties-ThalmorArmor';    
            end else if ('DLC2dunFrostmoonOutfitHjordis' = oldOutfitId) or ('DLC2dunFrostmoonOutfitRakel' = oldOutfitId) then begin    
                pantiesItemId := 'Panties-Forsworn';
            end else if 'DLC2MoragTongOutfit' = oldOutfitId then begin    
                pantiesItemId := 'Panties-MoragTong';
            end;
        end;
    end;
    if Assigned(newOutfitRef) then begin 
        AddListElement(newOutfitItems, newOutfitRef, isLVLI);
        exit;
    end;
    if Assigned(pantiesItemId) then begin
        pantiesFinal := pantiesItemId;
    end;
    for i := ElementCount(oldOutfitItems)-1 downto 0 do begin
        oldOutfitItem := ElementByIndex(oldOutfitItems, i);
        if not Assigned(oldOutfitItem) then begin raise Exception.Create('No item in '+FullPath(oldOutfitItems)+' at '+IntToStr(i)) end;
        if isLVLI then begin
            oldOutfitRef := ElementByPath(oldOutfitItem, 'LVLO\Reference');
        end else begin
            oldOutfitRef := oldOutfitItem;
        end;
        oldOutfitRef := LinksTo(oldOutfitRef);
        newOutfitRef := nil;
        removeOldItem := false;
        if Signature(oldOutfitRef) = 'LVLI' then begin
            newOutfitRef := RecursiveCopyLVLI(oldOutfitRef);
            removeOldItem := true;
        end else begin
            oldItemId := EditorID(oldOutfitRef);
            pantiesItemId := nil;
            tawobaItemId := nil;
            if StartsStr('Dremora', oldItemId) then begin
                if StartsStr('DremoraDaedric', oldItemId) then begin    
                    oldItemPrefix := 'DremoraDaedric';
                end else begin    
                    oldItemPrefix := 'Dremora';
                end;
                pantiesItemId := 'Panties-Daedric';
                tawobaItemId := 'TEW Daedric ';
            end else if StartsStr('DA16VaerminaRobes', oldItemId) then begin
                pantiesItemId := 'Panties-Monk-Vaermina';
            end else if StartsStr('DLC2', oldItemId) then begin
                if StartsStr('DLC2ArmorNordicHeavy', oldItemId) then begin
                    tawobaItemId := 'TWA Nordic Carved ';
                    oldItemPrefix := 'DLC2ArmorNordicHeavy';
                    pantiesItemId := 'Panties-Bandit-Boss';
                end else if StartsStr('DLC2EnchArmorChitin', oldItemId) then begin    
                    oldItemPrefix := 'DLC2EnchArmorChitin';
                    pantiesItemId := 'Panties-Chitin';
                    if StartsStr('DLC2EnchArmorChitinLight', oldItemId) then begin    
                        oldItemPrefix := 'DLC2EnchArmorChitinLight';
                    end else if StartsStr('DLC2EnchArmorChitinHeavy', oldItemId) then begin    
                        oldItemPrefix := 'DLC2EnchArmorChitinHeavy';
                    end;
                end else if StartsStr('DLC2ArmorChitin', oldItemId) then begin    
                    oldItemPrefix := 'DLC2ArmorChitin';
                    pantiesItemId := 'Panties-Chitin';
                    if StartsStr('DLC2ArmorChitinLight', oldItemId) then begin    
                        oldItemPrefix := 'DLC2ArmorChitinLight';
                    end else if StartsStr('DLC2ArmorChitinHeavy', oldItemId) then begin    
                        oldItemPrefix := 'DLC2ArmorChitinHeavy';
                    end;
                end else if StartsStr('DLC2ArmorBonemold', oldItemId) then begin    
                    oldItemPrefix := 'DLC2ArmorBonemold';
                    pantiesItemId := 'Panties-Bonemold';
                end;
            end else if StartsStr('Draugr', oldItemId) then begin
                tawobaItemId := 'TEW Ancient Nord ';
                oldItemPrefix := 'Draugr';
                pantiesItemId := 'Panties-Draugr';
            end else if StartsStr('EnchClothes', oldItemId) then begin
                magicType := nil;
                if StartsStr('EnchClothesRobesMage', oldItemId) then begin
                    oldItemPrefix := 'EnchClothesRobesMage';
                    magicType := AnyMagePrefix;
                end else if StartsStr('EnchClothesMageRobes', oldItemId) then begin    
                    oldItemPrefix := 'EnchClothesMageRobes';
                    if StartsStr('EnchClothesMageRobesApp', oldItemId) then begin 
                        oldItemPrefix := 'EnchClothesMageRobesApp';
                    end;
                    magicType := AnyMagePrefix;
                end else if StartsStr('EnchClothesNecroRobes', oldItemId) then begin    
                    oldItemPrefix := 'EnchClothesNecroRobes';
                    if StartsStr('EnchClothesNecroRobesHooded', oldItemId) then begin 
                        oldItemPrefix := 'EnchClothesNecroRobesHooded';
                    end;
                    magicType := AnyNecromancerPrefix;
                end else if StartsStr('EnchClothesWarlockRobes', oldItemId) then begin    
                    oldItemPrefix := 'EnchClothesWarlockRobes';
                    if StartsStr('EnchClothesWarlockRobesHooded', oldItemId) then begin 
                        oldItemPrefix := 'EnchClothesWarlockRobesHooded';
                    end;
                    magicType := AnyWarlockPrefix;
                end;
                
                if Assigned(magicType) then begin
                    if StartsStr(oldItemPrefix+'Illusion', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'Illusion';
                        magicType := magicType+'Illusion';
                    end else if StartsStr(oldItemPrefix+'Destruction', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'Destruction';
                        magicType := magicType+'Destruction';
                    end else if StartsStr(oldItemPrefix+'MagickaRate', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'MagickaRate';
                        magicType := magicType+'MagickaRate';
                    end else if StartsStr(oldItemPrefix+'Regen', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'Regen';
                        magicType := magicType+'MagickaRate';
                    end else if StartsStr(oldItemPrefix+'Conjuration', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'Conjuration';
                        magicType := magicType+'Conjuration';
                    end else if StartsStr(oldItemPrefix+'Restoration', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'Restoration';
                        magicType := magicType+'Restoration';
                    end else if StartsStr(oldItemPrefix+'Alteration', oldItemId) then begin    
                        oldItemPrefix:=oldItemPrefix+'Alteration';
                        magicType := magicType+'Alteration';
                    end else if StartsStr(oldItemPrefix+'Hood', oldItemId) then begin    
                        removeOldItem := true;
                        magicType := nil;
                    end else begin
                        magicType := nil;
                    end;
                end;
                if Assigned(magicType) then begin
                    magicLevel := nil;
                    if StartsStr(oldItemPrefix+'01', oldItemId) then begin    
                        magicLevel := '1';
                    end else if StartsStr(oldItemPrefix+'02', oldItemId) then begin    
                        magicLevel := '2';
                    end else if StartsStr(oldItemPrefix+'03', oldItemId) then begin    
                        magicLevel := '3';
                    end else if StartsStr(oldItemPrefix+'04', oldItemId) then begin    
                        magicLevel := '4';
                    end else if StartsStr(oldItemPrefix+'05', oldItemId) then begin    
                        magicLevel := '5';
                    end else if StartsStr(oldItemPrefix+'06', oldItemId) then begin    
                        magicLevel := '6'; 
                    end;
                    if Assigned(magicLevel) then begin
                        removeOldItem := true;
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, magicType+magicLevel);
                        if not Assigned(newOutfitRef) then begin raise Exception.Create(magicType+magicLevel+' not found'); end;
                        pantiesFinal := 'skip';
                        usesMage := true;
                    end;
                end;
            end else if StartsStr('cc', oldItemId) then begin
                if StartsStr('ccBGSSSE025_ClothesBlackSmith', oldItemId) then begin
                    oldItemPrefix := 'ClothesBlackSmith';  
                    pantiesItemId := 'Panties-TheNine';
                    newOutfitRef := AnyBlacksmith;
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    removeOldItem := Assigned(newOutfitRef);
                end;
            end else if StartsStr('Clothes', oldItemId) then begin
                if StartsStr('ClothesThalmor', oldItemId) then begin
                    oldItemPrefix := 'ClothesThalmor';
                    tawobaItemId := 'TWA Thalmor ';
                    pantiesItemId := 'Panties-ThalmorArmor';
                end else if StartsStr('ClothesRobes', oldItemId) then begin    
                end else if StartsStr('ClothesMonkRobes', oldItemId) then begin 
                    newOutfitRef := AnyMonk;
                    removeOldItem := Assigned(newOutfitRef);
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end; 
                    if not Assigned(newOutfitRef) then begin
                        if StartsStr('ClothesMonkRobesColorRed', oldItemId) then begin
                            pantiesItemId := 'Panties-Monk-1-Basic';
                        end else if StartsStr('ClothesMonkRobesColorBrown', oldItemId) then begin
                            pantiesItemId := 'Panties-Monk-2-Brown';
                        end else if StartsStr('ClothesMonkRobesColorGrey', oldItemId) then begin
                            pantiesItemId := 'Panties-Monk-3-Grey';
                        end else begin
                            pantiesItemId := 'Panties-Monk-4-White';
                        end;
                    end;
                    //panties := 'Panties-Monk-5-Green';
                end else if StartsStr('ClothesNecromancer', oldItemId) then begin    
                    if StartsStr('ClothesNecromancerRobes', oldItemId) then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyNecromancerPrefix+'MagickaRate2');
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(AnyNecromancerPrefix) <> Assigned(newOutfitRef) then begin raise Exception.Create(AnyNecromancerPrefix+'MagickaRate2 not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                        usesMage := usesMage or Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesNecromancerBoots' then begin
                        removeOldItem := Assigned(AnyNecromancerPrefix);
                    end;
                end else if StartsStr('ClothesCollege', oldItemId) then begin    
                end else if StartsStr('ClothesFarm', oldItemId) then begin    
                    oldItemPrefix := 'ClothesFarm';  
                    pantiesItemId := 'Panties-TheNine';
                    if isBodyPart32(oldOutfitRef) then begin
                        newOutfitRef := AnyFarmClothes;
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    end;
                    removeOldItem := Assigned(AnyFarmClothes);
                end else if StartsStr('ClothesChef', oldItemId) then begin    
                    oldItemPrefix := 'ClothesChef';  
                    pantiesItemId := 'Panties-TheNine';
                    if oldItemId = 'ClothesChef' then begin
                        newOutfitRef := KitchenLingerie;
                    end;
                    removeOldItem := Assigned(KitchenLingerie);
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end; 
                end else if StartsStr('ClothesFine', oldItemId) then begin    
                    oldItemPrefix := 'ClothesFine';  
                    pantiesItemId := 'Panties-TheNine';
                    if isBodyPart32(oldOutfitRef) then begin
                        newOutfitRef := AnyFineClothes;
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    end;
                    removeOldItem := Assigned(AnyFineClothes);
                end else if StartsStr('ClothesWench', oldItemId) then begin  
                    oldItemPrefix := 'ClothesWench';  
                    pantiesItemId := 'Panties-TheNine';
                    if StartsStr('_SLSD', oldOutfitId) then begin
                        newOutfitRef := AnyMonk; // for sisterhood of dibella
                    end else begin
                        newOutfitRef := AnyBarkeeper;
                    end;
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    removeOldItem := Assigned(newOutfitRef);
                end else if StartsStr('ClothesMiner', oldItemId) then begin    
                    oldItemPrefix := 'ClothesMiner';  
                    pantiesItemId := 'Panties-TheNine';
                end else if StartsStr('ClothesJarl', oldItemId) then begin    
                    oldItemPrefix := 'ClothesJarl';  
                    pantiesItemId := 'Panties-Ebony';
                    if isBodyPart32(oldOutfitRef) then begin
                        newOutfitRef := AnyJarl;
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    end;
                    removeOldItem := Assigned(AnyJarl);
                end else if StartsStr('ClothesBlackSmith', oldItemId) then begin    
                    oldItemPrefix := 'ClothesBlackSmith';  
                    pantiesItemId := 'Panties-TheNine';
                    newOutfitRef := AnyBlacksmith;
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    removeOldItem := Assigned(newOutfitRef);
                end else if StartsStr('ClothesBarKeeper', oldItemId) then begin    
                    if oldItemId = 'ClothesBarKeeper' then begin
                        oldItemPrefix := 'ClothesBarKeeper';  
                        pantiesItemId := 'Panties-General-Vendor';
                        newOutfitRef := AnyBarkeeper;
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    end;
                    removeOldItem := Assigned(AnyBarkeeper);
                end else if StartsStr('ClothesMerchant', oldItemId) then begin    
                    oldItemPrefix := 'ClothesMerchant';  
                    pantiesItemId := 'Panties-Big Vendor';
                end else if StartsStr('ClothesBeggar', oldItemId) then begin
                    if (oldItemId = 'ClothesBeggarRags') or (oldItemId = 'ClothesBeggarRobes') then begin
                        newOutfitRef := AnyBeggar;
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        removeOldItem := Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesBeggarHat' then begin
                        removeOldItem := Assigned(AnyBeggar);
                    end else if oldItemId = 'ClothesBeggarBoots' then begin   
                        removeOldItem := Assigned(AnyBeggar);
                    end;
                end else if StartsStr('ClothesPrisoner', oldItemId) then begin
                    if (oldItemId = 'ClothesPrisonerRags') or (oldItemId = 'ClothesPrisonerRagsBloody') or (oldItemId = 'ClothesPrisonerTunic') then begin
                        newOutfitRef := AnyPrisoner;
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        removeOldItem := Assigned(newOutfitRef);
                    end else if (oldItemId = 'ClothesPrisonerShoes') or (oldItemId = 'ClothesPrisonerBloodyShoes') then begin   
                        removeOldItem := Assigned(AnyPrisoner);
                    end;
                end else if StartsStr('ClothesWarlock', oldItemId) then begin    
                    if StartsStr('ClothesWarlockRobes', oldItemId) then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyWarlockPrefix+'MagickaRate3');
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(AnyWarlockPrefix) <> Assigned(newOutfitRef) then begin raise Exception.Create(AnyWarlockPrefix+'MagickaRate3 not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                        usesMage := usesMage or Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesWarlockBoots' then begin
                        removeOldItem := Assigned(AnyWarlockPrefix);
                    end;
                end else if StartsStr('ClothesMG', oldItemId) then begin    
                    if 'ClothesMGBoots' = oldItemId then begin    
                        removeOldItem := Assigned(AnyMagePrefix);
                    end;    
                end;
                if Assigned(oldItemPrefix) and Assigned(pantiesItemId) then begin
                    if StartsStr(oldItemPrefix+'Boots', oldItemId) or StartsStr(oldItemPrefix+'Hat', oldItemId) or StartsStr(oldItemPrefix+'Gloves', oldItemId) then begin
                        pantiesItemId := nil;
                    end;
                end;
            end else if StartsStr('dun', oldItemId) then begin
            end else if StartsStr('DB', oldItemId) then begin
                if StartsStr('DBArmor', oldItemId) then begin
                    if (oldItemId = 'DBArmor') or StartsStr('DBArmorWorn', oldItemId) or (oldItemId = 'DBArmorShortSleeve') then begin
                        newOutfitRef := AnyAssassin;
                        removeOldItem := Assigned(newOutfitRef);
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end; 
                    end else begin
                        removeOldItem := Assigned(AnyAssassin);
                    end;
                end else if StartsStr('DBClothes', oldItemId) then begin
                    if (oldItemId = 'DBClothesRobes') or (oldItemId = 'DBClothesJester') or (oldItemId = 'DBClothesRedguardClothes') then begin
                        newOutfitRef := AnyAssassin;
                        removeOldItem := Assigned(newOutfitRef);
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end; 
                    end else begin
                        removeOldItem := Assigned(AnyAssassin);
                    end;
                end;
            end else if StartsStr('Forsworn', oldItemId) then begin
                oldItemPrefix := 'Forsworn';
                pantiesItemId := 'Panties-Forsworn';
                if oldItemId = 'ForswornCuirass' then begin
                    newOutfitRef := AnyForsworn;
                end;
                removeOldItem := Assigned(AnyForsworn);
            end else if StartsStr('DLC1', oldItemId) then begin
                if StartsStr('DLC1Armor', oldItemId) then begin
                    if StartsStr('DLC1ArmorVampire', oldItemId) then begin
                        oldItemPrefix := 'DLC1ArmorVampire';
                        if Assigned(AnyVampirePrefix) then begin
                            pantiesItemId := 'skip';
                        end else begin
                            pantiesItemId := 'Panties-VampireBasicBlack';
                        end;
                        if StartsStr('DLC1ArmorVampireArmor', oldItemId) then begin
                            oldItemPrefix := 'DLC1ArmorVampireArmor';
                            if (oldItemId = 'DLC1ArmorVampireArmorValerica') or (oldItemId = 'DLC1ArmorVampireArmorRoyalRed') then begin
                                newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyVampirePrefix+' Ench');
                            end else begin
                                newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyVampirePrefix);
                            end;
                            if Assigned(AnyVampirePrefix) <> Assigned(newOutfitRef) then begin raise Exception.Create(AnyVampirePrefix+' not found'); end;
                            removeOldItem := Assigned(newOutfitRef);
                            if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                            usesMage := usesMage or Assigned(newOutfitRef);
                        end else begin
                            removeOldItem := Assigned(fileChristineDeadlyDesire);
                        end; 
                    end;
                end else if StartsStr('DLC1ClothesVampireLord', oldItemId) then begin
                    oldItemPrefix := 'DLC1ClothesVampireLord';
                    if StartsStr('DLC1ClothesVampireLordRoyal', oldItemId) then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyVampirePrefix+' Ench');
                    end else begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyVampirePrefix);
                    end;
                    if Assigned(fileChristineDeadlyDesire) <> Assigned(newOutfitRef) then begin raise Exception.Create(AnyVampirePrefix+' not found'); end;
                    removeOldItem := Assigned(newOutfitRef);
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    usesMage := usesMage or Assigned(newOutfitRef);
                end else if StartsStr('DLC1EnchClothesVampireRobes', oldItemId) then begin
                    if Assigned(fileChristineDeadlyDesire) then begin
                        oldItemPrefix := 'DLC1EnchClothesVampireRobes';
                        if StartsStr(oldItemPrefix+'Destruction', oldItemId) then begin    
                            magicType := 'Destruction';
                        end else if StartsStr(oldItemPrefix+'MagickaRate', oldItemId) then begin    
                            magicType := 'MagickaRate';
                        end else if StartsStr(oldItemPrefix+'Conjuration', oldItemId) then begin    
                            magicType := 'Conjuration';
                        end else begin
                            magicType := nil;
                        end;
                        if not Assigned(magicType) then begin
                            raise Exception.Create('Couldn''t parse magic type: '+oldItemId+' (prefix='+oldItemPrefix+')');
                        end;
                        oldItemPrefix:=oldItemPrefix+magicType;
                        magicLevel := nil;
                        if StartsStr(oldItemPrefix+'01', oldItemId) then begin    
                            magicLevel := '1';
                        end else if StartsStr(oldItemPrefix+'02', oldItemId) then begin    
                            magicLevel := '2';
                        end else if StartsStr(oldItemPrefix+'03', oldItemId) then begin    
                            magicLevel := '3';
                        end else if StartsStr(oldItemPrefix+'04', oldItemId) then begin    
                            magicLevel := '4';
                        end else if StartsStr(oldItemPrefix+'05', oldItemId) then begin    
                            magicLevel := '5';
                        end else if StartsStr(oldItemPrefix+'06', oldItemId) then begin    
                            magicLevel := '6'; 
                        end;
                        if not Assigned(magicLevel) then begin
                            raise Exception.Create('Couldn''t parse magic level: '+oldItemId);
                        end;
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyVampirePrefix+' Ench'+magicType+magicLevel);
                        removeOldItem := true;
                        if not Assigned(newOutfitRef) then begin raise Exception.Create(AnyVampirePrefix+' Ench'+magicType+magicLevel+' not found'); end;
                        pantiesFinal := 'skip';
                        usesMage := usesMage or Assigned(newOutfitRef);
                    end;
                end else if StartsStr('DLC1ArmorDawnguard', oldItemId) then begin
                    if StartsStr('DLC1ArmorDawnguardCuirass', oldItemId) then begin
                        newOutfitRef := AnyDawnguard;
                    end;
                    removeOldItem := true;
                end;
            end else if StartsStr('DLC01ClothesVampire', oldItemId) or StartsStr('DlC01ClothesVampire', oldItemId) then begin 
                if oldItemId = 'DLC01ClothesVampire' then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyVampirePrefix);
                    if Assigned(AnyVampirePrefix) <> Assigned(newOutfitRef) then begin raise Exception.Create(AnyVampirePrefix+' not found'); end;
                    usesMage := usesMage or Assigned(newOutfitRef);
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                end else begin
                    removeOldItem := Assigned(fileChristineDeadlyDesire);
                end;
            end else if StartsStr('Armor', oldItemId) then begin
                if StartsStr('ArmorIron', oldItemId) then begin
                    tawobaItemId := 'TWA Iron ';
                    pantiesItemId := 'Panties-Iron';
                    if StartsStr('ArmorIronBanded', oldItemId) then begin
                        oldItemPrefix := 'ArmorIronBanded';
                    end else begin
                        oldItemPrefix := 'ArmorIron';
                    end;
                end else if StartsStr('ArmorThievesGuild', oldItemId) then begin
                    oldItemPrefix := 'ArmorThievesGuild';
                    pantiesItemId := 'Panties-TG-Basic';
                    // we don't want to replace the armor that is given to player, because we can't assume the player's gender
                    if (pos('Player', oldItemId) = 0) and (pos('Leader', oldItemId) = 0) then begin 
                        if pos('Cuirass', oldItemId) = 0 then begin
                            removeOldItem := Assigned(fileChristineNocturnal);
                        end else begin
                            newOutfitRef := AnyThievesGuild;
                            removeOldItem := Assigned(newOutfitRef);
                            if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        end;
                        
                    end;
                end else if StartsStr('ArmorLeather', oldItemId) then begin    
                    tawobaItemId := 'TWA Leather ';
                    pantiesItemId := 'Panties-LeatherArmor';
                    oldItemPrefix := 'ArmorLeather';
                end else if StartsStr('ArmorCompanions', oldItemId) then begin    
                    oldItemPrefix := 'ArmorCompanions';
                    tawobaItemId := 'TWA Wolf ';
                    pantiesItemId := 'Panties-Wolf';
                end else if StartsStr('ArmorBandit', oldItemId) then begin    
                    tawobaItemId := 'TWA Leather ';
                    pantiesItemId := 'Panties-Bandit-Boss';
                    oldItemPrefix := 'ArmorBandit';
                end else if StartsStr('ArmorBlades', oldItemId) then begin    
                    tawobaItemId := 'TWA Blades ';
                    oldItemPrefix := 'ArmorBlades';
                    pantiesItemId := 'Panties-Blades';
                end else if StartsStr('ArmorStormcloak', oldItemId) then begin    
                    if StartsStr('ArmorStormcloakBear', oldItemId) then begin    
                        oldItemPrefix := 'ArmorStormcloakBear';
                    end else begin
                        oldItemPrefix := 'ArmorStormcloak';
                    end;
                    tawobaItemId := 'CoT Stormcloak ';
                    pantiesItemId := 'Panties-Stormcloak';
                end else if StartsStr('ArmorSteel', oldItemId) then begin    
                    if StartsStr('ArmorSteelPlate', oldItemId) then begin    
                        oldItemPrefix := 'ArmorSteelPlate';
                    end else begin
                        oldItemPrefix := 'ArmorSteel';
                    end;
                    tawobaItemId := 'TWA Steel ';
                    pantiesItemId := 'Panties-Steel';
                end else if StartsStr('ArmorElven', oldItemId) then begin    
                    tawobaItemId := 'TWA Elven ';
                    pantiesItemId := 'Panties-Elven';
                    if StartsStr('ArmorElvenLight', oldItemId) then begin    
                        oldItemPrefix := 'ArmorElvenLight';
                    end else begin
                        oldItemPrefix := 'ArmorElven';
                    end;
                end else if StartsStr('ArmorNightingale', oldItemId) then begin    
                    oldItemPrefix := 'ArmorNightingale';
                    pantiesItemId := 'Panties-Nightingale';
                end else if StartsStr('ArmorPenitus', oldItemId) then begin    
                    oldItemPrefix := 'ArmorPenitus';
                    pantiesItemId := 'Panties-Penitus';
                end else if StartsStr('ArmorDaedric', oldItemId) then begin    
                    tawobaItemId := 'TEW Daedric ';
                    oldItemPrefix := 'ArmorDaedric';
                    pantiesItemId := 'Panties-Daedric';
                end else if StartsStr('ArmorDragonscale', oldItemId) then begin    
                    tawobaItemId := 'TEW Dragonscale ';
                    oldItemPrefix := 'ArmorDragonscale';
                    pantiesItemId := 'Panties-Dragonscale';
                end else if StartsStr('ArmorDragonplate', oldItemId) then begin    
                    tawobaItemId := 'TWA Dragon Bone ';
                    oldItemPrefix := 'ArmorDragonplate';
                    pantiesItemId := 'Panties-DragonBone';
                end else if StartsStr('ArmorDwarven', oldItemId) then begin    
                    tawobaItemId := 'TWA Dwarven ';
                    oldItemPrefix := 'ArmorDwarven';
                    pantiesItemId := 'Panties-Dwarven';
                end else if StartsStr('ArmorEbony', oldItemId) then begin    
                    tawobaItemId := 'TWA Ebony ';
                    oldItemPrefix := 'ArmorEbony';
                    pantiesItemId := 'Panties-Ebony';
                end else if StartsStr('ArmorHide', oldItemId) then begin    
                    tawobaItemId := 'TWA Hide ';
                    oldItemPrefix := 'ArmorHide';
                    pantiesItemId := 'Panties-Hide';
                end else if StartsStr('ArmorStudded', oldItemId) then begin    
                    tawobaItemId := 'TWA Hide ';
                    oldItemPrefix := 'ArmorStudded';
                    pantiesItemId := 'Panties-Hide';
                end else if StartsStr('ArmorScaled', oldItemId) then begin    
                    tawobaItemId := 'TEW Scaled ';
                    oldItemPrefix := 'ArmorScaled';
                    pantiesItemId := 'Panties-Scaled';
                end else if StartsStr('ArmorDraugr', oldItemId) then begin    
                    tawobaItemId := 'TEW Ancient Nord ';
                    oldItemPrefix := 'ArmorDraugr';
                    pantiesItemId := 'Panties-Draugr';
                end else if StartsStr('ArmorOrcish', oldItemId) then begin    
                    tawobaItemId := 'TWA Orcish ';
                    oldItemPrefix := 'ArmorOrcish';
                    pantiesItemId := 'Panties-Orcish';
                end else if StartsStr('ArmorImperial', oldItemId) then begin    
                    tawobaItemId := 'TEW Imperial Heavy ';
                    pantiesItemId := 'Panties-Imperial';
                    if StartsStr('ArmorImperialLight', oldItemId) then begin    
                        oldItemPrefix := 'ArmorImperialLight';
                    end else begin
                        oldItemPrefix := 'ArmorImperial';
                    end;
                end;
            end;
            if (StartsStr('TWA ', tawobaItemId) and hasTAWOBA) or (StartsStr('TEW ', tawobaItemId) and hasTEWOBA) or (StartsStr('CoT ', tawobaItemId) and hasCoT) then begin
                removeOldItem := true;
                if StartsStr(oldItemPrefix+'Cuirass', oldItemId) or StartsStr(oldItemPrefix+'robes', oldItemId) or StartsStr(oldItemPrefix+'Robes', oldItemId)  then begin
                    // if (pos('Hooded', oldItemId) <> 0) or (pos('hooded', oldItemId) <> 0) then begin
                    //     newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Helmet');
                    //     AddListElement(newOutfitItems, newOutfitRef, isLVLI);
                    // end;
                    usedTAWOBABody := tawobaItemId;
                    tawobaItemId := tawobaItemId+'Body';
                    pantiesFinal := 'skip';
                end else if StartsStr(oldItemPrefix+'Gauntlets', oldItemId) or StartsStr(oldItemPrefix+'Gloves', oldItemId) then begin    
                    tawobaItemId := tawobaItemId+'Gauntlets';
                end else if StartsStr(oldItemPrefix+'Boots', oldItemId) then begin    
                    tawobaItemId := tawobaItemId+'Boots';
                end else if StartsStr(oldItemPrefix+'Helmet', oldItemId) then begin    
                    tawobaItemId := tawobaItemId+'Helmet';
                end else begin
                    removeOldItem := false;
                    tawobaItemId := nil;
                end;
                if Assigned(tawobaItemId) then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId);
                    if not Assigned(newOutfitRef) then begin
                        raise Exception.Create('unreachable: '+oldItemPrefix+'/'+oldItemId+' -> '+tawobaItemId);    
                    end;
                end;
            end;
            if Assigned(pantiesItemId) and not Assigned(pantiesFinal) then begin
                pantiesFinal := pantiesItemId;
            end;
        end;
        if removeOldItem then begin
            newOutfitItem := ElementByIndex(newOutfitItems, i);
            if not Assigned(newOutfitItem) then begin raise Exception.Create('No item in '+FullPath(newOutfitItems)+' at '+IntToStr(i)) end;
            if Assigned(newOutfitRef) then begin
                if isLVLI then begin
                    newOutfitItem := ElementByPath(newOutfitItem, 'LVLO\Reference');
                end;
                AddMessage('LVLI '+FullPath(newOutfitRecord)+': '+GetEditValue(newOutfitItem)+' -> '+EditorID(newOutfitRef));
                ElementAssign(newOutfitItem, LowInteger, newOutfitRef, false);
            end else begin
                if isLVLI then begin
                    AddMessage('LVLI '+FullPath(newOutfitItem)+' -= '+GetElementEditValues(newOutfitItem, 'LVLO\Reference'));
                end else begin
                    AddMessage('LVLI '+FullPath(newOutfitItem)+' -= '+GetEditValue(newOutfitItem));
                end;
                RemoveElement(newOutfitItems, newOutfitItem);
            end;
        end else begin
            if Assigned(newOutfitRef) then begin
                AddMessage('LVLI '+FullPath(newOutfitRecord)+' += '+EditorID(newOutfitRef)+' (like '+FullPath(oldOutfitItem)+')');
                TransferListElement(oldOutfitItem, newOutfitItems, newOutfitRef, isLVLI);
            end else begin
                AddMessage('LVLI '+FullPath(newOutfitRecord)+' == '+EditorID(oldOutfitRef));
            end;
        end;
    end;

    if isLVLI then begin
        if GetElementEditValues(newOutfitRecord, 'LVLF\Use All') <> '1' then begin
            pantiesFinal := nil;
        end;
    end;
    if not isLVLI or GetElementEditValues(newOutfitRecord, 'LVLF\Use All') = '1' then begin
        if Assigned(usedTAWOBABody) then begin
            for i := ElementCount(newOutfitItems)-1 downto 0 do begin
                newOutfitItem := ElementByIndex(newOutfitItems, i);
                if isLVLI then begin
                    newOutfitItem := ElementByPath(newOutfitItem, 'LVLO\Reference');
                end;
                oldItemId := GetEditValue(newOutfitItem);
                if not Assigned(oldItemId) then begin raise Exception.Create('unreachable: '+FullPath(newOutfitItem)); end;
                newOutfitRef := nil;
                if (pos('Hood', oldItemId) <> 0) or (pos('hood', oldItemId) <> 0)  then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, usedTAWOBABody+'Helmet');
                end else if (pos('boots', oldItemId) <> 0) or (pos('Boots', oldItemId) <> 0)  then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, usedTAWOBABody+'Boots');
                end;
                if Assigned(newOutfitRef) then begin
                    ElementAssign(newOutfitItem, LowInteger, newOutfitRef, false);
                end;
            end;
        end else if usesMage then begin
            for i := ElementCount(newOutfitItems)-1 downto 0 do begin
                newOutfitItem := ElementByIndex(newOutfitItems, i);
                if isLVLI then begin
                    oldItemId := GetElementEditValues(newOutfitItem, 'LVLO\Reference');
                end else begin
                    oldItemId := GetEditValue(newOutfitItem);
                end;
                if not Assigned(oldItemId) then begin raise Exception.Create('unreachable: '+FullPath(newOutfitItem)); end;
                if (pos('Hood', oldItemId) <> 0) or (pos('hood', oldItemId) <> 0) or (pos('boots', oldItemId) <> 0) or (pos('Boots', oldItemId) <> 0) then begin
                    RemoveElement(newOutfitItems, newOutfitItem);
                end;
            end;
        end;
    end;
    if Assigned(pantiesFinal) and Assigned(filePantiesofskyrim) and (pantiesFinal <> 'skip') then begin
        if StartsStr('Panties-', pantiesFinal) then begin
            newOutfitRef := MainRecordByEditorID(GroupBySignature(filePantiesofskyrim, 'LVLI'), pantiesFinal);
        end else begin
            newOutfitRef := MainRecordByEditorID(GroupBySignature(filePantiesofskyrim, 'ARMO'), pantiesFinal);
        end;
        if not Assigned(newOutfitRef) then begin raise Exception.Create('Panties not found: '+pantiesFinal);end;
        if not Assigned(newOutfitItems) then begin raise Exception.Create('reached unreachable code. Items: '+FullPath(newOutfitItems));end;
        newOutfitItem := ElementAssign(newOutfitItems, HighInteger, nil, false); 
        if not Assigned(newOutfitItem) then begin raise Exception.Create('reached unreachable code3. Items: '+FullPath(newOutfitRecord));end;
        if isLVLI then begin
            AddMessage('LVLI (panties) '+FullPath(newOutfitRecord)+' += '+EditorID(newOutfitRef));
            SetElementNativeValues(newOutfitItem, 'LVLO\Count', '1');
            SetElementNativeValues(newOutfitItem, 'LVLO\Level', '1');
            newOutfitItem := ElementByPath(newOutfitItem, 'LVLO\Reference');
            if not Assigned(newOutfitItem) then begin
                raise Exception.Create('reached unreachable code2. Items: '+FullPath(newOutfitItems));
            end;
        end else begin
            AddMessage('OTFT (panties) '+FullPath(newOutfitRecord)+' += '+EditorID(newOutfitRef));
        end;
        ElementAssign(newOutfitItem, LowInteger, newOutfitRef, false);
    end;
end;
function MoveToTop(e: IwbElement):integer;
begin
    while CanMoveUp(e) do begin
        MoveUp(e);
    end;
end;
function MoveToBottom(e: IwbElement):integer;
begin
    while CanMoveDown(e) do begin
        MoveDown(e);
    end;
end;
function isBodyPart32(armor: IwbElement): Boolean;
begin
    Result := GetElementEditValues(armor, 'BOD2\First Person Flags\32 - Body') = '1'; 
end;

function isFemale(lvln: IwbElement): Boolean;
var
    i: integer;
begin
    if EndsStr('F', EditorID(lvln)) then begin
        Result := true;
        exit;
    end;
    if Signature(lvln) = 'NPC_' then begin
        if GetElementEditValues(lvln, 'ACBS\Template Flags\Use Traits') = '1' then begin
            Result := isFemale(LinksTo(ElementByPath(lvln, 'TPLT')));
        end else begin
            Result := GetElementEditValues(lvln, 'ACBS - Configuration\Flags\Female') = '1';
        end;
    end else if Signature(lvln) = 'LVLN' then begin
        lvln := ElementByPath(lvln, 'Leveled List Entries');
        for i := 0 to ElementCount(lvln)-1 do begin
            if not isFemale(LinksTo(ElementByPath(ElementByIndex(lvln, i), 'LVLO\Reference'))) then begin
                Result := false;
                exit;
            end;
        end;
        Result := true;
    end;
end;

function isInFaction(npc: IwbMainRecord; faction:string): Boolean;
var
    i:integer;
    f: string;
    r: IInterface;
begin
    Result := false;
    npc := ElementByPath(npc, 'Factions');
    for i:= 0 to ElementCount(npc)-1 do begin
        r := ElementByIndex(npc, i);
        r := ElementByPath(r, 'Faction');
        r := LinksTo(r);
        f := EditorID(r);
        if not Assigned(f) then begin
            raise Exception.Create('D Error in isInFaction for '+FullPath(npc)+' at '+IntToStr(i));
        end;
        if f = faction then begin
            Result := true;
            exit;
        end;
    end;
end;

function FindFemaleVersionOfNPC(selectedElement: IInterface; createIfNotExists:Boolean): IwbElement;
var
    signat: string;
    selectedElementId: string;
begin
    signat := Signature(selectedElement);
    if (signat <> 'NPC_') and (signat <> 'LVLN') then raise Exception.Create('Not an NPC '+FullPath(selectedElement));
    if isFemale(selectedElement) then begin
        if GetFileName(GetFile(selectedElement)) = GetFileName(destinationFile) then begin
            Result := selectedElement;
            AddMessage('NPC M2F (already female) '+FullPath(Result));
        end else begin
            Result := MainRecordByEditorID(npcRecordGroup, EditorID(selectedElement));
            if not Assigned(Result) then begin
                Result := wbCopyElementToFileWithPrefix(selectedElement, destinationFile, false, true, '', '', '');
                AddMessage('NPC M2F (overwrite) from '+GetFileName(GetFile(selectedElement))+' to '+GetFileName(destinationFile));
            end;
        end;
        exit;
    end;
    selectedElementId := EditorID(selectedElement);
    if EndsStr('M', selectedElementId) then begin
        selectedElementId := copy(selectedElementId, 1, length(selectedElementId)-1);
    end;
    if not EndsStr('F', selectedElementId) then begin
        selectedElementId := selectedElementId+'F';
    end;
    Result := MainRecordByEditorID(npcRecordGroup, selectedElementId);
    if Assigned(Result) then begin    
        AddMessage('NPC M2F (exists) '+EditorID(selectedElement)+' -> '+EditorID(Result));
        exit;
    end;        
    if createIfNotExists then begin
        Result := wbCopyElementToFileWithPrefix(selectedElement, destinationFile, true, true, '', '', '');
        AddMessage('NPC M2F (copied) '+EditorID(selectedElement)+' -> '+EditorID(Result));
        SetEditorID(Result, selectedElementId);
    end;
    
end;

function FindSourceOfNPCsOutfit(selectedElement: IInterface): IwbMainRecord;
var
    signat: string;
    selectedElementId: string;
    otft: IwbElement;
    templateLoopsBackToMale: Boolean;
begin
    signat := Signature(selectedElement);
    selectedElementId := EditorID(selectedElement);
    if signat <> 'NPC_' then raise Exception.Create('Not an NPC '+FullPath(selectedElement));
    if GetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory') = '1' then begin
        otft := LinksTo(ElementByPath(selectedElement, 'TPLT'));
        if not Assigned(otft) then begin // just an assertion
            raise Exception.Create('Inventory = 1 despite having no template '+FullPath(selectedElement));
        end;
        templateLoopsBackToMale := EndsStr('M', EditorID(otft)) and (EditorID(otft) = copy(selectedElementId, 1, length(selectedElementId)-1)+'M');
        if templateLoopsBackToMale then begin 
            if GetElementEditValues(otft, 'ACBS\Template Flags\Use Inventory') = '1' then begin
                Result := LinksTo(ElementByPath(otft, 'TPLT'));
                if not Assigned(Result) then begin // just an assertion
                    raise Exception.Create('Inventory = 1 despite having no template '+FullPath(otft));
                end;
            end else begin
                Result := LinksTo(ElementByPath(otft, 'DOFT'));
            end;
            exit;
        end;
        Result := otft;
    end else begin
        Result := LinksTo(ElementByPath(selectedElement, 'DOFT'));
    end;
end;
function SetSourceOfNPCsOutfit(selectedElement: IInterface; otft: IwbMainRecord): Boolean;
var
    signat: string;
    e : IwbElement;
begin
    signat := Signature(selectedElement);
    if signat <> 'NPC_' then raise Exception.Create('Not an NPC '+FullPath(selectedElement));
    if GetFile(selectedElement) <> destinationFile then begin raise Exception.Create('Shouldn''t edit record '+FullPath(selectedElement)+' as it is outside '+GetFileName(destinationFile)); end;
    signat := Signature(otft);
    if (signat = 'NPC_') or (signat = 'LVLN') then begin
        SetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory', '1');
        AddMessage(Name(selectedElement)+': TPLT '+GetElementEditValues(selectedElement,'TPLT')+'->'+Name(otft)); 
        e := ElementByPath(selectedElement, 'TPLT');
        if not Assigned(e) then begin
            e := Add(selectedElement, 'TPLT', true);
        end;
        ElementAssign(e, LowInteger, otft, false);
        if GetElementEditValues(selectedElement,'TPLT') <> Name(otft) then begin // just an assertion
            raise Exception.Create('"'+GetElementEditValues(selectedElement,'TPLT') + '" <> "' + Name(otft)+'" failed to set for '+FullPath(selectedElement));
        end;
        Result := true;
    end else begin
        if signat <> 'OTFT' then begin // just an assertion
            raise Exception.Create(Name(otft)+' can''t be an outfit for '+FullPath(selectedElement));
        end;
        SetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory', '0');
        AddMessage(Name(selectedElement)+': DOFT '+GetElementEditValues(selectedElement,'DOFT')+'->'+Name(otft)); 
        e := ElementByPath(selectedElement, 'DOFT');
        if not Assigned(e) then begin
            e := Add(selectedElement, 'DOFT', true);
        end;
        ElementAssign(e, LowInteger, otft, false);
        if GetElementEditValues(selectedElement,'DOFT') <> Name(otft) then begin // just an assertion
            raise Exception.Create('"'+GetElementEditValues(selectedElement,'DOFT') + '" <> "' + Name(otft)+'" failed to set for '+FullPath(selectedElement));
        end;
        Result := false;
    end;
end;
procedure ClearNpcItems(npc: IwbMainRecord);
var
    i:integer;
    e: IwbElement;
begin
    if Signature(npc) <> 'NPC_' then begin raise Exception.Create('NPC expected but got '+FullPath(npc)) end;
    e := ElementByPath(npc, 'Items');
    for i:=ElementCount(e)-1 downto 0 do begin
        RemoveByIndex(e, i, true);
    end;
end;
function RecursiveCopyNPC(selectedElement: IInterface; createIfNotExists:Boolean): IwbElement;
var
    selectedElementId: string;
    fileId: string;
    newOutfitRecord: IwbElement;
    defaultOutfitElement: IwbElement;
    oldOutfitRecord: IwbElement;
    newOutfitRecordId: string;
    femaleFlag: string;
    templateLoopsBackToMale: Boolean;
    i: integer;
begin
    selectedElementId := EditorID(selectedElement);
    fileId := GetFileName(GetFile(selectedElement));
    selectedElement := FindFemaleVersionOfNPC(selectedElement, createIfNotExists);
    if not Assigned(selectedElement) then begin exit; end;
    if GetFile(selectedElement) <> destinationFile then begin raise Exception.Create('assertion failed: '+FullPath(selectedElement)); end;
    if isInFaction(selectedElement, 'TAPWhoreFaction') then begin
        newOutfitRecord := AnyLingerieOutfit;
    end else begin
        oldOutfitRecord := FindSourceOfNPCsOutfit(selectedElement);
    end;
    if not Assigned(oldOutfitRecord) then begin
        if StartsStr('TAP', selectedElementId) then begin
            if StartsStr('TAPVampireCattle', selectedElementId) or StartsStr('TAPVampireVictim', selectedElementId) or StartsStr('TAPVaniksethLabRat', selectedElementId) then begin
                newOutfitRecord := AnyPrisonerOutfit;
            end else begin    
                newOutfitRecord := AnyLingerieOutfit;
            end;
        end else if (fileId='troublesofheroine.esp') or isInFaction(selectedElement, 'zbfFactionSlave') then begin
            newOutfitRecord := AnyLingerieOutfit;
        end else if (fileId='SimpleSlavery.esp') then begin
            newOutfitRecord := AnyPrisonerOutfit;
        end;
    end else if Signature(oldOutfitRecord) = 'OTFT' then begin
        newOutfitRecord := CopyOutfit(oldOutfitRecord);
        if not Assigned(newOutfitRecord) then begin raise Exception.Create('unreachable '+ FullPath(selectedElement)+' otft= '+FullPath(oldOutfitRecord)) end;
    end else begin
        AddMessage(EditorID(selectedElement)+' calls RecursiveCopyLVLN('+Name(oldOutfitRecord)+')');
        newOutfitRecord := RecursiveCopyLVLN(oldOutfitRecord);
        if not Assigned(newOutfitRecord) then begin raise Exception.Create('unreachable '+ FullPath(selectedElement)+' otft= '+FullPath(oldOutfitRecord)) end;
    end;
    if Assigned(newOutfitRecord) then begin SetSourceOfNPCsOutfit(selectedElement, newOutfitRecord); end;
    Result := selectedElement;
end;

function ProcessAllNPCs(): integer;
var
    i: integer;
begin
   for i:=0 to ElementCount(npcRecordGroup) do begin
     RecursiveCopyNPC(ElementByIndex(npcRecordGroup, i), false);
   end;
end;


function Process(selectedElement: IInterface): integer;
var
    recordSignature: string;
begin
   
    recordSignature := Signature(selectedElement);
    if recordSignature = 'NPC_' then RecursiveCopyNPC(selectedElement, false)
    else if recordSignature = 'LVLN' then begin
        if StartsStr('Loot', EditorID(selectedElement)) then begin
            RecursiveCopyLVLN(selectedElement);
        end else begin
            rebalanceLVLIByRef(destinationFile, 15, selectedElement);
        end 
    end else if recordSignature = 'OTFT' then CopyOutfit(selectedElement)
    else if recordSignature = 'LVLI' then RecursiveCopyLVLI(selectedElement);
end;


// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
var
    i : integer;
begin
    
    if Assigned(smashedFiles) and smashedFiles <> '' then begin
        AddMessage('Smashed patch created. You should now disable the following esp plugins from load order.'+StringReplace(smashedFiles, '#', #13#10, [rfReplaceAll]));

        AddMessage('If you use ModOrganizer2 then just copy the following contents to C:\Users\<YOUR USER>\AppData\Local\ModOrganizer\Skyrim Special Edition\profiles\Default\plugins.txt');
        for i := 0 to Pred(FileCount) do begin
            f := FileByIndex(i);
            fname := GetFileName(f);
            if pos(fname, smashedFiles) = 0 then begin
                AddMessage('*'+fname);
            end else begin
                AddMessage(fname);
            end;
        end;
    end; 
    Result := 0;
end;

end.


    
