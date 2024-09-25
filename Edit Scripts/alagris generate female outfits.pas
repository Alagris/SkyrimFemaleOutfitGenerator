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
    fileCocoBikini: IwbFile;
    fileWizardHats: IwbFile;
    fileWitchyHats: IwbFile;
    hasTAWOBA: Boolean;
    fileTAWOBA: IwbFile;
    fileTAWOBALeveledList: IwbFile;
    hasTEWOBA: Boolean;
    fileTEWOBA: IwbFile;
    hasModularMage: Boolean;
    fileModularMage: IwbFile;
    fileSkyrim: IwbFile;
    fileCocoWitch: IwbFile;
    fileCocoDemon: IwbFile;
    fileCocoLingerie: IwbFile;
    fileCocoLace: IwbFile;
    fileHS2Bunny: IwbFile;
    fileKSOMage: IwbFile;
    fileCocoAssassin: IwbFile;
    fileChristineUndead: IwbFile;
    fileChristineNocturnal: IwbFile;
    fileChristineBlackMagic: IwbFile;
    fileChristineDeadlyDesire: IwbFile;
    fileChristinePriestess: IwbFile;
    fileSkimpyMaid: IwbFile;
    fileShinoSchool: IwbFile;
    fileDXFI: IwbFile;
    fileDXFII: IwbFile;
    fileDXsT: IwbFile;
    AnyMagePrefix: string;
    AnyNecromancerPrefix: string;
    AnyWarlockPrefix: string;

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
function newLVLI(e:IwbElement; destFile: IwbFile; eID, lvld, useAll, calcEach, calcLvl:string): IwbElement;
begin
    if Assigned(e) then RemoveByIndex(e, 0, true);
    if Assigned(MainRecordByEditorID(GroupBySignature(destFile,'LVLI'), eID)) then begin
        exit;
    end;
    Result := Add(GroupBySignature(destFile, 'LVLI'), 'LVLI', true);
    SetEditorID(Result, eID);
    SetElementEditValues(Result, 'LVLD', lvld);
    SetElementEditValues(Result, 'LVLF\Calculate from all levels <= player''s level', calcLvl);
    SetElementEditValues(Result, 'LVLF\Calculate for each item in count', calcEach);
    SetElementEditValues(Result, 'LVLF\Use All', useAll);
    Result := Add(Result, 'Leveled List Entries', true);
end;
function assignToLVLI(e: IwbElement; ref: IwbMainRecord; count, level:string): IwbElement;
begin
    if not Assigned(ref) then begin
        raise Exception.Create('Tried to assign nil to '+FullPath(e));
    end;
    Result := Add(e, 'Leveled List Entry', true);
    //AddMessage(Name(ref)+' -> '+FullPath(Result));
    SetElementEditValues(Result, 'LVLO\Reference', Name(ref));
    SetElementEditValues(Result, 'LVLO\Count', count);
    SetElementEditValues(Result, 'LVLO\Level', level);
end;
function addToLVLI(destFile: IwbFile; e: IwbElement; filename: IwbFile; signat, ref, count, level:string): IwbMainRecord;
var
    r: IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(filename, signat), ref);
    if not Assigned(Result) then begin
        raise Exception.Create('Element not found: '+GetFileName(filename)+' '+signat+' '+ref);
    end;
    assignToLVLI(e, Result, count, level);
end;
function addToLVLIMaybe(destFile: IwbFile; e: IwbElement; filename: IwbFile; signat, ref, count, level:string): IwbMainRecord;
var
    r: IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(filename, signat), ref);
    if Assigned(Result) then begin
        assignToLVLI(e, Result, count, level);
    end;
end;
function addToLVLI_(destFile: IwbFile; e: IwbElement; signat, ref, count, level:string): IwbElement;
var
    r: IwbMainRecord;
begin
    Result := addToLVLI(destFile, e, destFile, signat, ref, count, level);
end;
function addToLVLIMaybe_(destFile: IwbFile; e: IwbElement; signat, ref, count, level:string): IwbElement;
var
    r: IwbMainRecord;
begin
    Result := addToLVLIMaybe(destFile, e, destFile, signat, ref, count, level);
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
    addToLVLI_(destFile, e, 'ARMO', EditorID(enchItem), '1', '1');
    enchItem := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'UltraSkimpy2', magic_type, 'EnchRobesCollege'+magic_type+'0'+IntToStr(levelNum));
    addToLVLI_(destFile, e, 'ARMO', EditorID(enchItem), '1', '1');

    e := newLVLI(e, destFile, 'KSO_'+magic_type+IntToStr(levelNum), '0', '1', '0', '0');
    addToLVLIMaybe_(destFile, e, 'LVLI', 'KSO_'+level+'Hood', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'KSO_'+level+'Robes'+magic_type, '1', '1');
    if Assigned(fileModularMage) then begin
        addToLVLI_(destFile, e, 'LVLI', 'MM_JourneymanHH', '1', '1');
    end else begin
        addToLVLI_(destFile, e, 'LVLI', 'ClothesMGBoots', '1', '1');
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
end;
function GenerateKSOHood(destFile: IwbFile; e:IwbElement; level, levelNum:string): IwbElement;
var
    newEnch: IwbMainRecord;
    s: string;
begin
    
    
    e := newLVLI(e, destFile, 'KSO_'+level+'Hood', '50', '0', '1', '1');
    newEnch := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'Hood', 'MagickaRate', 'EnchArmorFortifyMagicka'+levelNum);
    addToLVLI_(destFile, e, 'ARMO', EditorID(newEnch), '1', '1');
    if level = 'Adept' then begin s := '' end else begin s := 'e' end; // typo in original mod
    newEnch := GenerateKSOEnchantedItem(destFile, '_TemplateClothesRobesMage'+level+'HoodLower'+s+'d', 'MagickaRate', 'EnchArmorFortifyMagicka'+levelNum);
    addToLVLI_(destFile, e, 'ARMO', EditorID(newEnch), '1', '1');
    Result := e;
end;
function GenerateKSO(destFile: IwbFile; e:IwbElement): IwbElement;
begin
    e:=GenerateKSOHood(destFile, e, 'Adept', '04');
    e:=GenerateKSOHood(destFile, e, 'Apprentice', '03');
    e:=GenerateKSOHood(destFile, e, 'Novice', '02');
    GenerateKSOEnchantedItem(destFile, '_ClothesMGRobesArchmage', 'MagickaRate', 'MGArchMageRobeEnchant');
    GenerateKSOEnchantedItem(destFile, '_ClothesMGRobesArchmage1Hooded', 'MagickaRate', 'MGArchMageRobeHoodedEnchant');
    e := newLVLI(e, destFile, 'KSO_Archmage', '0', '0', '1', '1');
    addToLVLI(destFile, e, fileKSOMage, 'ARMO', '_ClothesMGRobesArchmage', '1', '1');
    addToLVLI(destFile, e, fileKSOMage, 'ARMO', '_ClothesMGRobesArchmage1Hooded', '1', '1');
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
    e := newLVLI(e, destFile, 'MM_JourneymanHH', '0', '0', '1', '1');
    addToLVLI(destFile, e, fileModularMage, 'ARMO', '_ModularMageJourneymanHighHeelShoes', '1', '1');
    addToLVLI(destFile, e, fileModularMage, 'ARMO', '_ModularMageJourneymanHighHeelShoes2', '1', '1');
    addToLVLI(destFile, e, fileModularMage, 'ARMO', '_ModularMageJourneymanHighHeelBoots2', '1', '1');
    e := GenerateModularMageForLevel(destFile, e, 'Novice', 1);
    e := GenerateModularMageForLevel(destFile, e, 'Apprentice', 2);
    e := GenerateModularMageForLevel(destFile, e, 'Adept', 3);
    e := GenerateModularMageForLevel(destFile, e, 'Expert', 4);
    e := GenerateModularMageForLevel(destFile, e, 'Master', 5);
    Result := e;
end;

function GenerateModularMageForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
var
    modular_mage : IwbFile;
begin
    modular_mage:=fileModularMage;
    e := newLVLI(e, destFile, 'MM_'+level+'MageStockings', '0', '0', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Stockings1', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Stockings2', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Stockings3', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Stockings4', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Stockings5', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'JourneyBoots', '0', '1', '0', '0');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageStockings', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_JourneymanHH', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageFootwear', '0', '0', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Variant1ThighHighBoots', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'ThighHighBoots', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'StirrupSocks', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageBootsStockings', '0', '1', '0', '0');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageStockings', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageFootwear', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageBootsNoStockings', '0', '0', '1', '1');
    addToLVLI(destFile, e, fileUSSEP, 'ARMO', 'ClothesMGBoots', '1', '1');
    addToLVLI(destFile, e, fileUSSEP, 'ARMO', 'ClothesWarlockBoots', '1', '1');
    addToLVLI(destFile, e, fileUSSEP, 'ARMO', 'ClothesCollegeBootsCommonVariant1', '1', '1');
    addToLVLI(destFile, e, fileUSSEP, 'ARMO', 'ClothesCollegeBootsApprenticeVariant1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'HighHeels', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'HighHeelBoots', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageBoots', '0', '0', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBootsStockings', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'JourneyBoots', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBootsNoStockings', '1', '1');
    if levelNum > 3 then begin // things that only expert and master have
        e := newLVLI(e, destFile, 'MM_'+level+'MageCoat', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Coat', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatCollar', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatOpen', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatOpenCollar', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageCoatOpen', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatOpen', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatOpenCollar', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageCoatClosed', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Coat', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatCollar', '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSkirt', '0', '0', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Skirt1', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Skirt2', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Skirt3', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Skirt4', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'MiniSkirt', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'TightSkirt', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageSkirtShorts', '0', '1', '0', '0');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'MiniSkirt', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Shorts', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageArms', '0', '0', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Sleeves1', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Sleeves2', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Sleeves3', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Armwraps', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'ArmCuffs', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Sleeves4', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Sleeves5', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageTopNormal', '0', '0', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Corset1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Corset2', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Corset3', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Harness1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Harness2', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Harness3', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Top1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Top2', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Top3', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Top4', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'BeltTop1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'BeltTop2', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Bikini1', '1', '1');
    addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Bikini2', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'WrapTopShirt', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'WrapTop', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Dress2', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'StringBra', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Dress1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Dress', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'NipCurtains', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Bra1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Bra2', '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageJacket', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Jacket', '1', '1');
        addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'JacketCollar', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageMantle', '0', '0', '1', '1');
        addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle1', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle3', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle2', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageMantleShash', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle1Sash', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle3Sash', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageTopless', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Pasties', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Sash', '1', '1');
    end else begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageJacket', '0', '0', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Jacket', '1', '1');
        addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'JacketCollar', '1', '1');
        addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle1', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle3', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Mantle2', '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageCorset', '0', '0', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Corset1Topless', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Corset2Topless', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Corset3Topless', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CorsetTopless1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CorsetTopless2', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageScarf', '0', '0', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Scarf', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Scarf1', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Scarf2', '1', '1');
    addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Scarf3', '1', '1');
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
    modular_mage : IwbFile;
    ench: string;
begin
    modular_mage:=fileModularMage;
    ench := 'EnchRobesCollege'+magic_type+'0'+IntToStr(levelNum);
    e := GenerateModularMagePantiesForMagicTypeAndLevel(destFile, e, level, magic_type, ench);
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottomCurtain'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Garterbelt', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'PelvisCurtains', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottomPanty'+magic_type, '0', '1', '0', '0');
    end else begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottom'+magic_type, '0', '1', '0', '0');
    end;    
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MagePanties'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirt', '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottomShorts', '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtShorts', '1', '1');
        addToLVLIMaybe(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Shorts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottom'+magic_type, '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottomPanty'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottomShorts', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottomCurtain'+magic_type, '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Jacket'+magic_type, '0', '1', '0', '0');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
    if levelNum > 3 then addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Mantle'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageMantle', '1', '1');
    end;
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Arms'+magic_type, '0', '1', '0', '0');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
    if levelNum>3 then begin
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
    end else begin
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
    end;
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1ArmsMantle'+magic_type, '0', '1', '0', '0');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
    if levelNum>3 then begin addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageJacket', '1', '1'); 
    end else begin addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageMantle', '1', '1'); end;
    if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
    if levelNum>3 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet1Coat'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCoatOpen', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopNormal', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        if Assigned(fileWizardHats) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSet1'+magic_type, '0', '0', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1Arms'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1Jacket'+magic_type, '1', '1');
    addToLVLIMaybe_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1Coat'+magic_type, '1', '1');
    addToLVLIMaybe_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1Mantle'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1ArmsMantle'+magic_type, '1', '1');
    if levelNum < 4 then begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageBottom2'+magic_type, '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottomCurtain'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2ArmsMantle'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageMantleShash', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Jacket'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Mantle'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBottom2'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageMantleShash', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'SlingBikini', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2'+magic_type, '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2Arms'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2ArmsMantle'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2Jacket'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2Mantle'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Jacket'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3ArmsScarf'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCorset', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageScarf', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3JacketScarf'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirtCurtain'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageJacket', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageTopless', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageScarf', '1', '1');
        if Assigned(fileWizardHats) and (levelNum>2) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '_ModularMage'+level+'StringThong'+magic_type, '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Belts', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3'+magic_type, '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3Arms'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3Jacket'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3ArmsScarf'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3JacketScarf'+magic_type, '1', '1');
    end else begin
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        if Assigned(fileWizardHats) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageScarf', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Onepiece', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Garterbelt', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '_ModularMage'+level+'Skirt2'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2Coat'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCoat', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Onepiece', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Garterbelt', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '_ModularMage'+level+'Skirt2'+magic_type, '1', '1');
        if Assigned(fileWizardHats) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet2'+magic_type, '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2Arms'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2Coat'+magic_type, '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Arms'+magic_type, '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirt', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageArms', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MagePanties'+magic_type, '1', '1');
        if Assigned(fileWizardHats) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'CoatCollar', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Harness3', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3Coat'+magic_type, '0', '1', '0', '0');
        if Assigned(fileWizardHats) then addToLVLI_(destFile, e, 'LVLI', 'MM_WizardHats', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageBoots', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSkirt', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MagePanties'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageCoatClosed', '1', '1');
        addToLVLI(destFile, e, modular_mage, 'ARMO', '_ModularMage'+level+'Harness3', '1', '1');
        e := newLVLI(e, destFile, 'MM_'+level+'MageSet3'+magic_type, '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3Arms'+magic_type, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3Coat'+magic_type, '1', '1');
    end;
    e := newLVLI(e, destFile, 'MM_'+magic_type+IntToStr(levelNum), '0', '0', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3'+magic_type, '1', '1');
    Result := e;
end;


function GenerateAnyMage(destFile: IwbFile; e:IwbElement): IwbElement;
begin
    e := GenerateAnyMageForLevel(destFile, e, 'Novice', 1);
    e := GenerateAnyMageForLevel(destFile, e, 'Apprentice', 2);
    e := GenerateAnyMageForLevel(destFile, e, 'Adept', 3);
    e := GenerateAnyMageForLevel(destFile, e, 'Expert', 4);
    e := GenerateAnyMageForLevel(destFile, e, 'Master', 5);
    Result := e;
end;
function GenerateAnyMageForLevel(destFile: IwbFile; e:IwbElement; level: string; levelNum:integer): IwbElement;
begin
    e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Conjuration', levelNum);
    e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Restoration', levelNum);
    e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Destruction', levelNum);
    e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Illusion', levelNum);
    e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'Alteration', levelNum);
    e := GenerateAnyMageForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    Result := e;
end;
function GenerateAnyMageForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
begin
    e := newLVLI(e, destFile, 'AnyMage'+magic_type+IntToStr(levelNum), '0', '0', '1', '0');
    if Assigned(fileKSOMage) then begin
        addToLVLI_(destFile, e, 'LVLI', 'KSO_'+magic_type+IntToStr(levelNum), '1', '1');
    end;
    if Assigned(modular_mage) then begin
        addToLVLI_(destFile, e, 'LVLI', 'MM_'+magic_type+IntToStr(levelNum), '1', '1');
    end;
    Result := e;
end;
function GenerateCocoDemon(destFile: IwbFile; e:IwbElement): IwbElement;
var
    s:string;
begin
    for i := 1 to 6 do begin 
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO demon'+s+' hair80', '80', '0', '1', '0');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_hairsmp'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+' mask60', '70', '0', '1', '0');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_mask'+s, '1', '1');
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
    e := GenerateCocoDemonForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    Result := e;
end;
function GenerateCocoDemonForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    s:string;
    lvl:string;
    ei: IwbMainRecord;
    ench:string;
begin
    lvl := IntToStr(levelNum);
    ench :='EnchRobesFortify'+magic_type+'0'+lvl;
    for i := 1 to 5 do begin 
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO demon'+s+' modular '+magic_type+lvl, '0', '1', '0', '0');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_bra'+s, '1', '1');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_glove'+s, '1', '1');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_panties'+s, 'Demon_panties'+s+magic_type+lvl, magic_type, ench);
        addToLVLI_(destFile, e, 'ARMO', EditorID(ei), '1', '1');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_heels'+s, '1', '1');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_stock'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+' two parts '+magic_type+lvl, '0', '1', '0', '0');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_bodybra'+s, 'Demon_bodybra'+s+magic_type+lvl, magic_type, ench);
        addToLVLI_(destFile, e, 'ARMO', EditorID(ei), '1', '1');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_bodystock'+s, '1', '1');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_heels'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+' full body'+magic_type+lvl, '0', '0', '1', '0');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_bodyfucool'+s, 'Demon_bodyfucool'+s+magic_type+lvl, magic_type, ench);
        addToLVLI_(destFile, e, 'ARMO', EditorID(ei), '1', '1');
        ei := GenerateEnchantedItem(destFile, fileCocoDemon, 'Demon_bodyfu'+s, 'Demon_bodyfu'+s+magic_type+lvl, magic_type, ench);
        addToLVLI_(destFile, e, 'ARMO', EditorID(ei), '1', '1');
        e := newLVLI(e, destFile, 'COCO demon body'+s+magic_type+lvl, '0', '0', '1', '0');
        addToLVLI_(destFile, e, 'LVLI', 'COCO demon'+s+' full body'+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO demon'+s+' two parts'+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO demon'+s+' modular'+magic_type+lvl, '1', '1');
        e := newLVLI(e, destFile, 'COCO demon'+s+magic_type+lvl, '0', '1', '0', '0');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_horn'+s, '1', '1');
        //addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_hair'+s, '1', '1');
        addToLVLI(destFile, e,fileCocoDemon, 'ARMO', 'Demon_tail'+s, '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO demon'+s+' mask60', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO demon'+s+' hair80', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO demon body'+s+magic_type+lvl, '1', '1');
    end;
    e := newLVLI(e, destFile, 'COCO demon'+magic_type+lvl, '0', '0', '1', '0');
    addToLVLI_(destFile, e, 'LVLI', 'COCO demon1'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO demon2'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO demon3'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO demon4'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO demon5'+magic_type+lvl, '1', '1');
end;

function GenerateCocoWitch(destFile: IwbFile; e:IwbElement): IwbElement;
var
    s:string;
begin
    for i := 1 to 4 do begin
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO witch'+s+' neck', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_neckA'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_neckB'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+' stock', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_stockB'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_stockA'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_stockB'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_stockA'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_stockA5', '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_stockA6', '1', '1'); 
        e := newLVLI(e, destFile, 'COCO witch'+s+' skirt', '0', '0', '1', '0');
        addToLVLIMaybe(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s+'tou', '1', '1');
        addToLVLIMaybe(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s+'po', '1', '1');
        addToLVLIMaybe(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+' belt', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_beltlow'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_beltup'+s, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+' bra', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_bra'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_bra'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_bra'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_bra5', '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_bra6', '1', '1');
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
    e := GenerateCocoWitchForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    Result := e;
end;
function GenerateCocoWitchForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    s:string;
    lvl:string;
    ei: IwbMainRecord;
    ench:string;
begin
    lvl := IntToStr(levelNum);
    ench :='EnchRobesFortify'+magic_type+'0'+lvl;
    GenerateEnchantedItem(destFile, fileCocoWitch, 'Witchi_pants5', 'Witchi_pants5'+magic_type+lvl, magic_type, ench);
    GenerateEnchantedItem(destFile, fileCocoWitch, 'Witchi_pants6', 'Witchi_pants6'+magic_type+lvl, magic_type, ench);
    for i := 1 to 4 do begin
        s := IntToStr(i);
        e := newLVLI(e, destFile, 'COCO witch'+s+' pants'+magic_type+lvl, '0', '0', '1', '0');
        GenerateEnchantedItem(destFile, fileCocoWitch, 'Witchi_pants'+s, 'Witchi_pants'+s+magic_type+lvl, magic_type, ench);
        addToLVLI_(destFile, e, 'ARMO', 'Witchi_pants'+s+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Witchi_pants'+s+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Witchi_pants'+s+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Witchi_pants5'+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Witchi_pants6'+magic_type+lvl, '1', '1');
        e := newLVLI(e, destFile, 'COCO witch'+s+magic_type+lvl, '0', '1', '0', '0');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'WitchiRing1', '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_shoes'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_skirt'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_glovel'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_knee'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_sho'+s, '1', '1');
        addToLVLI(destFile, e, fileCocoWitch, 'ARMO', 'Witchi_glover'+s, '1', '1');
        addToLVLI_(destFile, e, 'LVLI',  'COCO witch'+s+' bra', '1', '1');
        addToLVLI_(destFile, e, 'LVLI',  'COCO witch'+s+' pants'+magic_type+lvl, '1', '1');
        addToLVLI_(destFile, e, 'LVLI',  'COCO witch'+s+' neck', '1', '1');
        addToLVLI_(destFile, e, 'LVLI',  'COCO witch'+s+' stock', '1', '1');
        addToLVLI_(destFile, e, 'LVLI',  'COCO witch'+s+' skirt', '1', '1');
        addToLVLI_(destFile, e, 'LVLI',  'COCO witch'+s+' belt', '1', '1');
    end;
    e := newLVLI(e, destFile, 'COCO witch'+magic_type+lvl, '0', '0', '1', '0');
    addToLVLI_(destFile, e, 'LVLI', 'COCO witch1'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO witch2'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO witch3'+magic_type+lvl, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'COCO witch4'+magic_type+lvl, '1', '1');
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
    e := GenerateDeadlyDesireForTypeAndLevel(destFile, e, level, 'MagickaRate', levelNum);
    Result := e;
end;
function GenerateDeadlyDesireForTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type:string; levelNum:integer): IwbElement;
var
    s:string;
begin
    s := IntToStr(levelNum);
    GenerateEnchantedItem_(destFile, fileChristineDeadlyDesire, '00DDPanty', '00DDPanty'+magic_type+s, '', 'EnchRobesFortify'+magic_type+'0'+s);
    e := newLVLI(e, destFile, 'CHDD Set Ench'+magic_type+s, '0', '1', '0', '0');
    addToLVLI_(destFile, e, 'LVLI', 'CHDD Upper', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'CHDD Shoulder', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'CHDD Boots', '1', '1');
    addToLVLI_(destFile, e, 'ARMO', '00DDPanty'+magic_type+s, '1', '1');
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
function generate(destFile: IwbFile): integer;
var
    s: string;
    i: integer;
    e:IwbElement;
    otft:IwbElement;
    panties: IwbFile;
    coco_lingerie: IwbFile;
    coco_lace: IwbFile;
    coco_bikini: IwbFile;
    hs2_bunny: IwbFile;
    modular_mage: IwbFile;
    ussep: IwbFile;
    wizard_hats: IwbFile;
    tewoba: IwbFile;
    tawoba: IwbFile;
    tawoba_list: IwbFile;
begin
    panties := filePantiesofskyrim;
    coco_lingerie := fileCocoLingerie;
    coco_lace := fileCocoLace;
    coco_bikini := fileCocoBikini;
    hs2_bunny := fileHS2Bunny;
    modular_mage := fileModularMage;
    ussep := fileUSSEP;
    wizard_hats := fileWizardHats;
    tewoba := fileTEWOBA;
    tawoba := fileTAWOBA;
    tawoba_list := fileTAWOBALeveledList;
    if Assigned(tawoba_list) then begin
        //TODO uncomment this
        raise Exception.Create('You should disable '''+GetFileName(tawoba_list)+''' to avoid conflicts!');
    end;
    if Assigned(panties) then begin
        AddMasterIfMissing(destFile, GetFileName(panties));
    end;
    if Assigned(fileSkimpyMaid) then begin
        AddMasterIfMissing(destFile, GetFileName(fileSkimpyMaid));
        e := newLVLI(e, destFile, 'SkimpyMaidSet', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileSkimpyMaid, 'ARMO', 'xxxSkimpyMaidShoes', '1', '1');
        addToLVLI(destFile, e, fileSkimpyMaid, 'ARMO', 'xxxSkimpyMaidCloth', '1', '1');
        addToLVLI(destFile, e, fileSkimpyMaid, 'ARMO', 'xxxSkimpyMaidHead', '1', '1');
    end;
    if Assigned(fileDXFI) then begin
        AddMasterIfMissing(destFile, GetFileName(fileDXFI));
        e := newLVLI(e, destFile, 'DXCallMeYoursTop', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursTop1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursTopGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursNonetTop1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursNonetTopGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursSocks1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursSocksGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursHeels1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursHeelsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursHeelsChrome1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursChoker1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCallMeYoursChokerGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCatMask1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXCatMaskGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXTooHotForYou', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXTooHotForYouBodystocking1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXTooHotForYoutop1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXTooHotForYoutopGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXTooHotForYouBodystockingFishnet1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXTooHotForYouHeels1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXTooHotForYouHeelsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireMeUp', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireMeUpTop1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireMeUpTopGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireMeUpHeels1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireMeUpHeelsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFireYourDesire', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireEarringsSMPGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireBalls1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireBallsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelBall1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelBallGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireBracers1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireBracersGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireHearts1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireHeartsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesirePanty1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireRings1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireRingsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelRing1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireNavelRingGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireNoseRing1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireNoseRingGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireBowRing1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireBowRingGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsBottom1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsBottomGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsTop1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireStrapsTopGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireXs1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireXsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFI, 'ARMO', 'DXFireYourDesireEarrings1', '1', '1');
    end;
    if Assigned(fileDXFII) then begin
        AddMasterIfMissing(destFile, GetFileName(fileDXFII));
        e := newLVLI(e, destFile, 'DXFIIWildDreams', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGloves1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGlovesBelts1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsPiercing1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsStocking1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsOutfit1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsMask1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsCollar1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGlovesGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsGlovesBeltsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsPiercingGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsAllbutBra_Panty1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsOutfitGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsStockingGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsBra_Panty1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsBra_PantyGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsAllbutBra_PantyGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsCollarGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsArmlets1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIWildDreamsArmletsGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIExoticNights', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsAnkleChain1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsEarrings1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeartEarrings1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsGarter1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokini1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeels1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsSnakeArmlet1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsBracer1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokiniwithoutChains1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsAnkleChainGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsEarringsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeartEarringsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsGarterGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokiniGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsMonokiniwithoutChainsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsHeelsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNights16HeelsGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNights16Heels1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsSnakeArmletGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIExoticNightsBracerGold1', '1', '1');
        e := newLVLI(e, destFile, 'DXFIIBegForIt', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItBracers1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItSocks1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItMiniFishnet1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItOutfitGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItBracersGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItSocksGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForIt16Socks1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForIt16SocksGold1', '1', '1');
        addToLVLI(destFile, e, fileDXFII, 'ARMO', 'DXFIIBegForItOutfit1', '1', '1');
    end;
    if Assigned(fileDXsT) then begin
        AddMasterIfMissing(destFile, GetFileName(fileDXsT));
        e := newLVLI(e, destFile, 'DXsT', '0', '1', '0', '0');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisDress1', '1', '1');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisBracelet1', '1', '1');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisHeels1', '1', '1');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisNecklace1', '1', '1');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisEarrings1', '1', '1');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisPearlThong1', '1', '1');
        addToLVLI(destFile, e, fileDXsT, 'ARMO', 'DXStLouisArmlet1', '1', '1');
    end;
    // if Assigned(fileShinoSchool) then begin
    //     AddMasterIfMissing(destFile, GetFileName(fileShinoSchool));
    //     e := newLVLI(e, destFile, 'SkimpyMaidSet', '0', '1', '0', '0');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_1', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_pantyhose', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_ribbon', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_1', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_3', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_4', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_5', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Shirt_a', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Shirt_b', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Shirt_c', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Shirt_d', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Shirt_e', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Shirt_f', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Short', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Short_sexy', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_stocking', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_socks', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_shoe', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1a', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2a_sexy', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_todo_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_todo_az_con_ro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_todo_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_todo_az_con_ro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_todo_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_todo_az_con_ro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_todo_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_todo_az_con_ro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_verde', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_1_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_1_VER', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_1_RO', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_2_AZ', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_3_aZ', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_2_RO', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_2_VER', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_3_RO', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_3_VER', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_4_AZ', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_4_RO', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_4_VER', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_5_AZ', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_5_RO', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_5_VER', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_ro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_short', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_short_real', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_short_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_short_real_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Short_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Short_sexy_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_ribbon_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_ribbon_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_ribbon_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_blanco2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_blanco2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_2_sexy_blanco2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_1_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_1_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_1_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_2_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_2_rojo', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_panty_2_rosa', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_seikufu_1_sexy_blanco2', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_socks_az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_stocking_Az', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_a', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1b', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_b', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_2_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_1_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_2_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_4_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_3_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_tie_5_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_sexy_short_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Tshirt_short_real_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Short_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Short_sexy_nergro', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Skirt_1_sexy_blanco', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1c', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_c', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1d', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_1_sexy_D', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2b', '1', '1');
    //     addToLVLI(destFile, e, fileShinoSchool, 'ARMO', 'Shino_Sport_Sukumizu_2b_sexy', '1', '1');
    // end;
    if Assigned(fileWizardHats) then begin
        if not Assigned(fileWitchyHats) then begin
            raise Exception.Create('You are using '+GetFileName(fileWizardHats)+' without '+GetFileName(fileWitchyHats)+'. Make sure to install both');
        end;
        AddMasterIfMissing(destFile, GetFileName(fileWizardHats));
        AddMasterIfMissing(destFile, GetFileName(fileWitchyHats));
        e := newLVLI(e, destFile, 'MM_WizardHats', '0', '0', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatRedCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatBeigeCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatBlackCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatBlueCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatBrownCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatGreenCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatGreyCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatLightBrownCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatPurpleCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatWhiteCirclet', '1', '1');
        addToLVLI(destFile, e, wizard_hats, 'ARMO', 'sirwhoArmorWizardHatYellowCirclet', '1', '1');
    end;
    if Assigned(modular_mage) then begin
        AddMasterIfMissing(destFile, GetFileName(modular_mage));
        e := GenerateModularMage(destFile, e);
        AnyMagePrefix := 'MM_';
    end;
    if Assigned(fileKSOMage) then begin
        AddMasterIfMissing(destFile, GetFileName(fileKSOMage));
        e := GenerateKSO(destFile, e);
        if Assigned(AnyMagePrefix) then begin
            AnyMagePrefix := 'multiple';
        end else begin
            AnyMagePrefix := 'KSO_';
        end;
    end;
    if AnyMagePrefix = 'multiple' then begin
        GenerateAnyMageForTypeAndLevel(destFile, e);
        AnyMagePrefix := 'AnyMage';
    end;
    if Assigned(coco_lingerie) then begin
        AddMasterIfMissing(destFile, GetFileName(coco_lingerie));
        e := newLVLI(e, destFile, 'coco_lingerie1', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie1', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes1', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stock1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie2', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie2', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes2', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stock2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie3', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie3', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes3', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stock3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie4', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie4', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes4', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stock4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb1', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerieb1', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stockb1', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb2', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerieb2', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stockb2', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb3', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerieb3', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stockb3', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb4', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerieb4', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stockb4', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb5', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stockb5', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerieb5', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerieb6', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerieb6', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_stockb6', '1', '1');
        addToLVLI(destFile, e, coco_lingerie, 'ARMO', 'lingerie_shoes2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lingerie', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerie1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerie2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerie3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerie4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerieb1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerieb2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerieb3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerieb4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerieb5', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lingerieb6', '1', '1');
    end;
    if Assigned(coco_lace) then begin
        AddMasterIfMissing(destFile, GetFileName(coco_lace));
        e := newLVLI(e, destFile, 'coco_lace_heel1', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel01_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel01_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace1_bikini_only', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini01_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini01_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini01_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini01_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini01_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini01_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace1', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace1_bikini_only', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_heel1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_heel2', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel02_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel02_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel02_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace2_bikini_only', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini02_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini02_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini02_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini02_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini02_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini02_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace2', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace2_bikini_only', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_heel2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace3_2', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel03_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03handfur_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03head_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03tail_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03brafur_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03bellfur_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace3_1', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel03_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03bellfur_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03handfur_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03head_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03tail_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03brafur_1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace3_3', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel03_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03bellfur_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03handfur_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03head_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini03tail_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'Bikini03brafur_1', '1', '1');   
        e := newLVLI(e, destFile, 'coco_lace3', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace3_1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace3_2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace3_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_heel4', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_7', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'heel04_8', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace4_bikini_only', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini04_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini04_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini04_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini04_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace4', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace4_bikini_only', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_heel4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace5_1', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini05_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini05arm_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini05nip_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', '05stock_1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_heel4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace5_2', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini05_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini05arm_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini05nip_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', '05stock_2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_heel4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace5', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace5_1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace5_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace6', '0', '0', '0', '0');
        e := newLVLI(e, destFile, 'coco_lace7_1', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07low_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07top_1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_2', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07low_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07top_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_3', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07low_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07top_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_4', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07low_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07top_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7_5', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07low_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini07top_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace7', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace7_1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace7_2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace7_3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace7_4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace7_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace8', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini08_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini08_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini08_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini08_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini08_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini08_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace9', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini09_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini09_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'bikini09_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace5', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace6', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace7', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace8', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace9', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body1', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace01_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace01_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace01_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace01_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace01_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace01_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body2', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace02_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace02_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace02_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace02_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body3', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace03_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace03_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace03_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body4', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace04_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace04_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace04_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace04_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace04_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body5', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace05_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace05_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace05_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace05_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace05_6', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace05_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body6', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace06_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace06_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace06_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace06_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace06_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body7', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace07_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace07_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace07_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lace07_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_1', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_2', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_2', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_1', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_3', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_3', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_4', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_4', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_5', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_5', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_6', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_6', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_6', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8_7', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacelow08_7', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop08_7', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body8', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_5', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_6', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8_7', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body9', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_2', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_1', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_3', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_4', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_5', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_6', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_7', '1', '1');
        addToLVLI(destFile, e, coco_lace, 'ARMO', 'lacetop09smp_8', '1', '1');
        e := newLVLI(e, destFile, 'coco_lace_body', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body5', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body6', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body7', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body8', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body9', '1', '1');
    end;
    if Assigned(coco_bikini) then begin
        AddMasterIfMissing(destFile, GetFileName(coco_bikini));
        e := newLVLI(e, destFile, 'coco_bikini3a', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini03a_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini03a_bellfur', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini03a_handfur', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'bikini03a_head', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'bikini03a_tailsmp', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini3b', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini03b_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini03b_bellfur', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini03b_handfur', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'bikini03b_head', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'bikini03b_tailsmp', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini5a', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05a_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05a_stock', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05a_arm', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05a_bra', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini5b', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05b_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05b_stock', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05b_arm', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini05b_bra', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini6a', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini06a_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini06a_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini6b', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini06b_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'BIKINI06b_lowDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini6c', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini06c_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini06c_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini7a', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini07a_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini07a_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini7b', '0', '1', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini07b_body', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini07b_low', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini8', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini08a', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini08bDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini08cDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini08dDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini08eDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini08fDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini9', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini09a', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini09bDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini09cDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini1', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini01a', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'bikini01bDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'bikini01cDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini2', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini02a', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini02bDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini4', '0', '0', '0', '0');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini04a', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini04bDUPLICATE001', '1', '1');
        addToLVLI(destFile, e, coco_bikini, 'ARMO', 'Bikini04cDUPLICATE001', '1', '1');
        e := newLVLI(e, destFile, 'coco_bikini', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini3a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini3b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini5a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini5b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini6a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini6b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini6c', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini7a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini7b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini8', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini9', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'coco_bikini4', '1', '1');
    end;
    if Assigned(hs2_bunny) then begin
        AddMasterIfMissing(destFile, GetFileName(hs2_bunny));
        e := newLVLI(e, destFile, 'bunny_leggings', '0', '0', '0', '0');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_BunnyLeggings', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_BunnyLeggings_normal', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings00', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings01', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings02', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings04', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings05', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings06', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings07', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings08', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Leggings09', '1', '1');
        e := newLVLI(e, destFile, 'bunny_upper', '0', '0', '0', '0');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_BunnysuitUpperA', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_BunnysuitUpperB', '1', '1');
        e := newLVLI(e, destFile, 'bunny_frontline', '80', '0', '0', '0');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_FrontLineA', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_FrontLineB', '1', '1');
        e := newLVLI(e, destFile, 'bunny_full', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_leggings', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_upper', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_frontline', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Bunnytail', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_Bunnyribbon', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_bunnyhandcuff', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_bunnyshoes', '1', '1');
        e := newLVLI(e, destFile, 'bunny_reverse', '0', '1', '0', '0');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_ReverseBunnyUpper', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_ReverseBunnyLeggings', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_ReverseBunnyribbon', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_bunnyhandcuff', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_bunnyshoes', '1', '1');
        e := newLVLI(e, destFile, 'bunny_reverse_white', '0', '1', '0', '0');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_ReverseBunnyribbon', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_ReverseBunnyLeggingswhite', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_ReverseBunnyUpperwhie', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_bunnyhandcuff', '1', '1');
        addToLVLI(destFile, e, hs2_bunny, 'ARMO', 'HS2_bunnyshoes', '1', '1');
        e := newLVLI(e, destFile, 'bunny_reverse_any', '0', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_reverse', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_reverse_white', '1', '1');
        e := newLVLI(e, destFile, 'bunny', '50', '0', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_full', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bunny_reverse_any', '1', '1');
    end;
    if Assigned(coco_lace) or Assigned(coco_lingerie) or Assigned(coco_bikini) or Assigned(hs2_bunny) then begin
        e := newLVLI(e, destFile, 'any_lingerie', '0', '0', '0', '0');
        if Assigned(coco_lace) then begin 
            addToLVLI_(destFile, e, 'LVLI', 'coco_lace', '1', '1');
            addToLVLI_(destFile, e, 'LVLI', 'coco_lace_body', '1', '1');
        end;
        if Assigned(coco_lingerie) then begin addToLVLI_(destFile, e, 'LVLI', 'coco_lingerie', '1', '1'); end;
        if Assigned(coco_bikini) then begin addToLVLI_(destFile, e, 'LVLI', 'coco_bikini', '1', '1'); end;
        if Assigned(hs2_bunny) then begin addToLVLI_(destFile, e, 'LVLI', 'bunny', '1', '1'); end;
        if not Assigned(MainRecordByEditorID(outfitRecordGroup, 'AnyLingerieOutfit')) then begin
            otft := Add(outfitRecordGroup, 'OTFT', true);
            SetEditorID(otft, 'AnyLingerieOutfit');
            otft := Add(otft, 'INAM', true);
            otft := Add(otft, 'Item', true);
            SetEditValue(otft, Name(MainRecordByEditorID(GroupBySignature(destFile, 'LVLI'), 'any_lingerie')));
        end;
    end;

    if Assigned(tewoba) then begin
        AddMasterIfMissing(destFile, GetFileName(tewoba));
        e := newLVLI(e, destFile, 'TEW Ancient Nord Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord45', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord46', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord32-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord32-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord32-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord37-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord37-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord33-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord33-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord33-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord42-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord57-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord57-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord57-03', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord57-04', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord57-05R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord57-05L', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord56-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord53-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord49-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord49-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord53-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord56-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord49-03', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord49-04', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord49-05', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord52-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'AncientNord52-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Ancient Nord Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Ancient Nord Accessories', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Ancient Nord Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Ancient Nord Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Ancient Nord Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Ancient Nord Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric45', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric46', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric47', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric33-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric33-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric31', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-01L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-01R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-02L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-02R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-03L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-03R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-04L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric57-04R', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric49-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric53-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric56-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric49-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric53-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric56-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Daedric52', '1', '1');
        e := newLVLI(e, destFile, 'TEW Daedric Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Daedric Accessories', '3', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Daedric Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Daedric Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Daedric Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Daedric Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale45-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale46-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale47-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale44-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale32-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale32-10', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale31-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale57-01L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale57-01R', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale49-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale53-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale56-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale49-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale53-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale56-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale49-03', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale53-03', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale56-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Dragonscale52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Dragonscale Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Dragonscale Accessories', '3', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Dragonscale Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Dragonscale Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Dragonscale Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Dragonscale Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass45', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass46', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass47', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass32-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass32-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass32-03', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass32-04', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass31', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass57-01R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass57-01L', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass49', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass53', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass56', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Glass52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Glass Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Glass Accessories', '3', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Glass Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Glass Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Glass Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Glass Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy45-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy46-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy48-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy42-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy57-01R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy57-01L', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy49-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy53-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy56-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialHeavy52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Heavy Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Heavy Accessories', '3', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Heavy Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Heavy Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Heavy Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Heavy Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight45-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight46-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight49-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight37-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight42-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight57-01L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight57-01R', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight53-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight56-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'ImperialLight52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Imperial Light Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Light Accessories', '3', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Light Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Light Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Light Thigh Tasset and Abs', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Imperial Light Thongs', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Accessories', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled45-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled46-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled46-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled32-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled37-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled37-02', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Gauntlets', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled33-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled31-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Pauldron', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled57-01L', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled57-01R', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled58-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled58-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled58-03', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Thigh Tasset and Abs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled49-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled53-01', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled53-02', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled53-03', '1', '1');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled56-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tewoba, 'ARMO', 'Scaled52-01', '1', '1');
        e := newLVLI(e, destFile, 'TEW Scaled Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Scaled Accessories', '3', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Scaled Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Scaled Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Scaled Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TEW Scaled Thongs', '1', '1');
    end;
    if Assigned(tawoba) then begin
        AddMasterIfMissing(destFile, GetFileName(tawoba));
        e := newLVLI(e, destFile, 'TWA Leather Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAbikini1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAbikini2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAbikini3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAcrown', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAthong1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAthong2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAthong3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAboot', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_boots', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAgaunt', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_gaunt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBApauld1L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBApauld2L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBApauld1R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBApauld2R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_pauldron1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_pauldron2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_pauldron2_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBApouch', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAthigh', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAabs1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAbelt1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_belt', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_Tasset', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_thigh1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_thigh2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_cooll', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAneckgorget', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00LBAneckcov', '1', '1');
        e := newLVLI(e, destFile, 'TWA Leather Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Leather Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Hide Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_top', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_neckcover', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_hotpants1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_hotpants2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_boots', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_gaunt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_pauldron1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_pauldron2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_pauldron2_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_belt', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_Tasset', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_thigh1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_thigh2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00HBA_cooll', '1', '1');
        e := newLVLI(e, destFile, 'TWA Hide Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Hide Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Bikini_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Helmet', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Headgear_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Headgear_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Headgear_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Facemask1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Facemask2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Thong_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_boots_1_long', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_boots_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_boots_2_long', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_boots_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_boots_3_long', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_gauntlets_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_gauntlets_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_1_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_2_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_3_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_3_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_4_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Shoulder_4_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Tasset_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Tasset_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_abs_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Gorget_Cape', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Gorget_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Harness', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Loincloth', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Pelt', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_B', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_Bk', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_G', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_V', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_W', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00WBA_Circlet_Y', '1', '1');
        e := newLVLI(e, destFile, 'TWA Wolf Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Wolf Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Wolf Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Wolf Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Wolf Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Wolf Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Bikini_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Bikini_sling', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Breastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Thong_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_boots_1_lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_boots_1_sh', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_boots_2_lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_boots_2_sh', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_gauntlets_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_gauntlets_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Mask_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Mask_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Mask_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Facemask', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Circlet_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Circlet_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_1_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_2_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_3_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_3_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_4_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Shoulder_4_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_thigh_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_tasset_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Gorget_1_A', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Gorget_1_B', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Gorget_1_C', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DBA_Chestguard_Bone', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dragon Bone Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dragon Bone Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dragon Bone Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dragon Bone Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dragon Bone Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dragon Bone Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Bireastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_thong_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_boots1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_gaunt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Mask', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Maskbl', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_Maskop', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_circlet', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_shoulder_1_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_shoulder_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_shoulder_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_shoulder_3_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_shoulder_3_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_shoulder_cape', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_abs_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_skirt_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_tasset_1b', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_tasset_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_gorg1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EBA_harness', '1', '1');
        e := newLVLI(e, destFile, 'TWA Ebony Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Ebony Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Ebony Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Ebony Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Ebony Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Ebony Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_bikini_7', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thong_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thong_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thong_7', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_boots_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_gaunt_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_gaunt_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_gaunt_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_gaunt_C', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_headgear_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_headgear_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_headgear_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_openhelm_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_headdress_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_closehelm_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_shoulder_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_shoulder_2_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_shoulder_2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_shoulder_3_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_shoulder_3_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_cape_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_abs_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Thigh_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Tasset_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Skirt_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Skirt_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Skirt_1_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_gorget', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_collar1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_collar2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_collar3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Harness1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00DWA_Harness2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Dwarven Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dwarven Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dwarven Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dwarven Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dwarven Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Dwarven Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Iron Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Bikini_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Bikini_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Bikini_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_breastplate_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_7', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thong_8', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_boots_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_boots_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_boots_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_boots_5', '1', '1');
        if Assigned(tewoba) then addToLVLI(destFile, e, tewoba, 'ARMO', 'Iron37-06', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gauntlets_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gauntlets_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gauntlets_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gauntlets_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gauntlets_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gauntlets_6', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_mask_1_noHorn_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_mask_1_Horna_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_mask_1_Hornb_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_mask_1_noHorn_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_mask_1_Horna_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_mask_1_Hornb_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_circlet_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_circlet_nohorn', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_circlet_1_hornA', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_circlet_1_hornB', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_circlet_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_horn_A', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_horn_B', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_1_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_4_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_4_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_5_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_5_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_6_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_6_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_7_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_shoulder_7_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_abs_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_abs_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_abs_6', '1', '1');
        if Assigned(tewoba) then addToLVLI(destFile, e, tewoba, 'ARMO', 'Iron56-07', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thigh_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_thigh_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_tasset_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_tasset_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_tasset_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_tasset_6', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_1_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_1_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_3_a', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_3_b', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_chestguard_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_gorget_3_C', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_spine_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BIB_Faceguard', '1', '1');
        e := newLVLI(e, destFile, 'TWA Iron Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Steel Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_7', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_8', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_bikini_breastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_7', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thong_8', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_boots_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_boots_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_boots_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_boots_5', '1', '1');
        if Assigned(tewoba) then addToLVLI(destFile, e, tewoba, 'ARMO', 'Steel37-06', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gauntlets_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gauntlets_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gauntlets_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gauntlets_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gauntlets_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gauntlets_6', '1', '1');
        if Assigned(tewoba) then addToLVLI(destFile, e, tewoba, 'ARMO', 'Steel33-07', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_helm_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_helm_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_helm_4_s', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_helm_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_helm_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_1_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_2_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_5_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_5_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_6_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_shoulder_6_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_abs_7', '1', '1');
        if Assigned(tewoba) then addToLVLI(destFile, e, tewoba, 'ARMO', 'Steel56-08', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Tasset_1_A', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Tasset_1_B', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Tasset_1_C', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Tasset_2_a', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Tasset_2_b', '1', '1');
        if Assigned(tewoba) then addToLVLI(destFile, e, tewoba, 'ARMO', 'Steel49-03', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thigh_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_Thigh_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_ChestGuard_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gorget_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gorget_1_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gorget_1_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gorget_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gorget_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_gorget_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_targe_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SBA_targe_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Steel Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_7', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_8', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_9', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_10', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_11', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_breastplate', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_bikini_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_6', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thong_7', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_boot_1_heel_lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_boot_1_heel_sh', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_boot_2_sab_sh', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_boot_2_sab_lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_boot_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gaunts_1_lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gaunts_1_sh', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gaunts_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_circ_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_gear_1a', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_gear_1b', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_gear_1c', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_gear_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_mask_1cl', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_mask_1op', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_head_mask_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_helm_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_4_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_4_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_5_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_shoulder_5_R', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_abs_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_1lc', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_3_lc', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_5', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_tasset_5lc', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thigh_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_thigh_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gorget_avent', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gorget_1_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gorget_1_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gorget_2_close', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_gorget_2_open', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_chestguard_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00SPB_skirt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nord Plate Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedBikini1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedBikini2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedBikini3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedThong1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedThong2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedThong3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedBoots1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedBoots2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedGloves1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedGloves2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedCirclet1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedCirclet2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedPauldrons1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedPauldrons2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedPauldrons3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedAbs1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedAbs2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedAbs3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedTassets1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedTassets2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedTassets3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedThighs', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedBack', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedGorget1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedGorget2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedHarness', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedLeggings', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedNeck', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00NordicCarvedScarf', '1', '1');
        e := newLVLI(e, destFile, 'TWA Nordic Carved Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Elven Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_gorge_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_gorge_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_chest_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_chest_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_spine', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_facecl', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_faceop', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_breastplate', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_boots_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00Evb_gaunt_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00Evb_gaunt_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_gearhvop', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_feather', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_mask', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_gearlg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_visor_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_visor_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_head_gearhvcl', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thong_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_3_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_4_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_5_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_6_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_7_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_3_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_4_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_5_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_6_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_should_7_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thigh_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_tasset_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_tasset_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_tasset_1l', '1', '1');
        e := newLVLI(e, destFile, 'TWA Elven Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Elven Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Elven Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Elven Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Elven Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Elven Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Body', '25', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_gorge_1tha', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_robe_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thong_1tha', '1', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Gauntlets', '25', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00Evb_gaunt_1tha', '1', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Boots', '25', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_boots_1tha', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Gorget_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Gorget_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Gorget_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Bikini_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Bikini_4', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Breastplate', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Kunoichi', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_boots_1s', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_boots_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_boots_2s', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_boots_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_gaunt_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_gaunt_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_helm', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_helmNH', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_circlet', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Thong_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Thong_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Thong_4', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_1_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_2_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_3_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_4_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_5_R', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_1_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_2_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_3_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_4_L', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_shoulder_5_L', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_abs_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Tasset_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Tasset_1alt', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Tasset_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Tasset_2alt', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Tasset_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00BBA_Tasset_3alt', '1', '1');
        e := newLVLI(e, destFile, 'TWA Blades Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Blades Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Blades Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Blades Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Blades Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Blades Accessories', '3', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Accessories', '70', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_gorget_1hv', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_gorget_1lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_gorget_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_Chestguard_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Armors', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_bikini_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_bikini_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_BP_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_BP_sp', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_boots_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_boots_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Gauntlets', '30', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_gauntlets_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Helmet', '50', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_helm_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_helm_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_hear_1', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Thongs', '0', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_Thong_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_Thong_2', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Pauldron', '40', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_shoulder_R_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_shoulder_R_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_shoulder_R_3', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_shoulder_L_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_shoulder_L_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_shoulder_L_3', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Thigh Tasset and Abs', '35', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_Thigh_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_Thigh_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_abs_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_abs_2', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_tasset_1_hv', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_tasset_1_lg', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_tasset_2_hv', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00OCA_tasset_2_lg', '1', '1');
        e := newLVLI(e, destFile, 'TWA Orcish Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Orcish Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Orcish Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Orcish Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Orcish Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Orcish Accessories', '3', '1');
    end;
    if Assigned(fileCocoDemon) then begin
        AddMasterIfMissing(destFile, GetFileName(fileCocoDemon)); 
        e := GenerateCocoDemon(destFile, e);
        if Assigned(AnyNecromancerPrefix) then begin
            AnyNecromancerPrefix := 'multiple';
        end else begin 
            AnyNecromancerPrefix := 'COCO demon';
        end;
    end;
    if Assigned(fileCocoWitch) then begin
        AddMasterIfMissing(destFile, GetFileName(fileCocoWitch)); 
        e := GenerateCocoWitch(destFile, e);
        if Assigned(AnyWarlockPrefix) then begin
            AnyWarlockPrefix := 'multiple';
        end else begin 
            AnyWarlockPrefix := 'COCO witch';
        end;
    end;
    if Assigned(fileCocoAssassin) then begin
        AddMasterIfMissing(destFile, GetFileName(fileCocoAssassin));
        for i := 1 to 5 do begin
            s := IntToStr(i);

            e := newLVLI(e, destFile, 'COCO assassin'+s+' corset', '0', '0', '1', '0');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsmp'+s, '1', '1');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsex'+s, '1', '1');
            if i < 5 then begin
                    e := newLVLI(e, destFile, 'COCO assassin'+s+' corsetb', '0', '0', '1', '0');
                    addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsmp'+s+'b', '1', '1');
                    addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_corsetsex'+s+'b', '1', '1');
            end;
            e := newLVLI(e, destFile, 'COCO assassin'+s+' mask', '0', '0', '1', '0');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_mask'+s, '1', '1');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_masksex'+s, '1', '1');
            if i < 5 then begin
                    e := newLVLI(e, destFile, 'COCO assassin'+s+' maskb', '0', '0', '1', '0');
                    addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_mask'+s+'b', '1', '1');
                    addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_masksex'+s+'b', '1', '1');
            end;
            e := newLVLI(e, destFile, 'COCO assassin'+s+' panti', '0', '0', '1', '0');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s, '1', '1');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_pantisex'+s, '1', '1');
            addToLVLIMaybe(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s+'c', '1', '1');
            if i < 5 then begin
                e := newLVLI(e, destFile, 'COCO assassin'+s+' pantib', '0', '0', '1', '0');
                addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s+'b', '1', '1');
                addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_pantisex'+s+'b', '1', '1');
                addToLVLIMaybe(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_panti'+s+'c', '1', '1');
            end;
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_underwear'+s, 'EnchAssassin_underwear'+s, '', 'DBEnchantShrouded');
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_horn'+s, 'EnchAssassin_horn'+s, '', 'DBEnchantGloves');
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_heels'+s, 'EnchAssassin_heels'+s, '', 'EnchArmorFortifyMarksman02');
            GenerateEnchantedItem_(destFile, fileCocoAssassin, 'Assassin_legbelt'+s, 'EnchAssassin_legbelt'+s, '', 'EnchArmorMuffle');
            e := newLVLI(e, destFile, 'COCO assassin'+s, '0', '1', '0', '0');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_necklacesmp'+s, '1', '1');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_tailfullsmp'+s, '1', '1');
            addToLVLI_(destFile, e, 'LVLI', 'COCO assassin'+s+' panti', '1', '1');
            addToLVLI_(destFile, e, 'LVLI', 'COCO assassin'+s+' mask', '1', '1');
            addToLVLI_(destFile, e, 'LVLI', 'COCO assassin'+s+' corset', '1', '1');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_glove'+s, '1', '1');
            addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_legbelt'+s, '1', '1');
            addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_underwear'+s, '1', '1');
            addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_boots'+s, '1', '1');
            addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_legbelt'+s, '1', '1');
            addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_horn'+s, '1', '1');
            if i < 5 then begin
                e := newLVLI(e, destFile, 'COCO assassin'+s+'b', '0', '1', '0', '0');
                addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_necklacesmp'+s, '1', '1');
                addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_tailfullsmp1b', '1', '1');
                addToLVLI_(destFile, e, 'LVLI', 'COCO assassin'+s+' pantib', '1', '1');
                if not Assigned(addToLVLIMaybe_(destFile, e, 'LVLI', 'COCO assassin'+s+' maskb', '1', '1')) then begin
                    addToLVLI_(destFile, e, 'LVLI', 'COCO assassin'+s+' mask', '1', '1');
                end;
                addToLVLI_(destFile, e, 'LVLI', 'COCO assassin'+s+' corsetb', '1', '1');
                if not Assigned(addToLVLIMaybe(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_glove'+s+'b', '1', '1')) then begin
                    addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_glove'+s, '1', '1');
                end;
                addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_legbelt'+s, '1', '1');
                addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_underwear'+s, '1', '1');
                if not Assigned(addToLVLIMaybe(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_boots'+s+'b', '1', '1')then begin
                    addToLVLI(destFile, e, fileCocoAssassin, 'ARMO', 'Assassin_boots'+s, '1', '1');
                end;
                addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_legbelt'+s, '1', '1');
                addToLVLI_(destFile, e, 'ARMO', 'EnchAssassin_horn'+s, '1', '1');
            end;
        end;
        e := newLVLI(e, destFile, 'COCO assassin', '0', '0', '1', '0');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin1b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin2b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin3b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin4b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'COCO assassin5', '1', '1');
    end;
    if Assigned(fileChristineUndead) then begin
        AddMasterIfMissing(destFile, GetFileName(fileChristineUndead));
        e := newLVLI(e, destFile, 'CHUD Upper', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileChristineUndead, 'ARMO', '00DSChosenUndeadUpperDM', '1', '1');
        addToLVLI(destFile, e, fileChristineUndead, 'ARMO', '00DSChosenUndeadUpper', '1', '1');
        e := newLVLI(e, destFile, 'CHUD Set', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'CHUD Upper', '1', '1');
        addToLVLI(destFile, e, fileChristineUndead, 'ARMO', '00DSChosenUndeadLower', '1', '1');
    end;
    if Assigned(fileChristineNocturnal) then begin
        AddMasterIfMissing(destFile, GetFileName(fileChristineNocturnal));
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
        e := newLVLI(e, destFile, 'CHNE Upper', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper'+s, '1', '1');
        addToLVLI(destFile, e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper1', '1', '1');
        addToLVLI(destFile, e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper1Damage', '1', '1');
        addToLVLI(destFile, e, fileChristineNocturnal, 'ARMO', '00NocturnalEmbraceUpper2Damage', '1', '1');
        e := newLVLI(e, destFile, 'CHNE Panty', '0', '0', '1', '0');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbracePanty1', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbracePanty2', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbracePanty1Damage', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbracePanty2Damage', '1', '1');
        e := newLVLI(e, destFile, 'CHNE Lower', '0', '0', '1', '0');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbraceLower1', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbraceLower2', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbraceLower1Damage', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbraceLower2Damage', '1', '1');
        e := newLVLI(e, destFile, 'CHNE Set', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'CHNE Lower', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHNE Upper', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHNE Panty', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbraceBoots', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', 'Ench00NocturnalEmbraceBelt', '1', '1');
    end;
    if Assigned(fileChristineBlackMagic) then begin
        AddMasterIfMissing(destFile, GetFileName(fileChristineBlackMagic));
    end;
    if Assigned(fileChristineDeadlyDesire) then begin
        AddMasterIfMissing(destFile, GetFileName(fileChristineDeadlyDesire));
        e := newLVLI(e, destFile, 'CHDD Upper', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDUpper', '1', '1');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDUpperSlutty', '1', '1');
        e := newLVLI(e, destFile, 'CHDD Shoulder', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDShoulderA', '1', '1');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDShoulderB', '1', '1');
        e := newLVLI(e, destFile, 'CHDD Boots', '0', '0', '1', '0');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsA', '1', '1');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsSluttyA', '1', '1');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsB', '1', '1');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDBootsSluttyB', '1', '1');
        GenerateEnchantedItem_(destFile, fileChristineDeadlyDesire, '00DDPanty', '00DDEnchPanty', '', 'EnchRobesCollegeMagickaRate04');
        e := newLVLI(e, destFile, 'CHDD Set', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'CHDD Upper', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHDD Shoulder', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHDD Boots', '1', '1');
        addToLVLI(destFile, e, fileChristineDeadlyDesire, 'ARMO', '00DDPanty', '1', '1');
        e := newLVLI(e, destFile, 'CHDD Set Ench', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'CHDD Upper', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHDD Shoulder', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHDD Boots', '1', '1');
        addToLVLI_(destFile, e, 'ARMO', '00DDEnchPanty', '1', '1');
        e := GenerateDeadlyDesire(destFile, e);
    end;
    if Assigned(fileChristinePriestess) then begin
        AddMasterIfMissing(destFile, GetFileName(fileChristinePriestess));
        for i := 1 to 7 do begin
            s := IntToStr(i);
            e := newLVLI(e, destFile, 'CHHP priestess'+s, '0', '1', '0', '0');
            addToLVLI(destFile, e, fileChristinePriestess, 'ARMO', '00HPBBelly0'+s, '1', '1');
            addToLVLI(destFile, e, fileChristinePriestess, 'ARMO', '00HPBLower0'+s, '1', '1');
            addToLVLI(destFile, e, fileChristinePriestess, 'ARMO', '00HPBUpper0'+s, '1', '1');
        end;
        e := newLVLI(e, destFile, 'CHHP priestess', '0', '0', '1', '0');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess3', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess4', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess5', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess6', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'CHHP priestess7', '1', '1');
    end;
    if Assigned(e) then RemoveByIndex(e, 0, true);
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
    clb: TCheckListBox;
begin
    hasPantiesofskyrim := false;
    hasTAWOBA := false;
    hasTEWOBA := false;
    hasModularMage := false;
    frm := frmFileSelect;
    try
        // Initialize dialog
        frm.Caption := 'Select a plugin for outfit';
        clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
        clb.Items.Add('<new file>');
        clb.Items.Add('<new file - ESL flagged>');
        for i := 0 to Pred(FileCount) do begin
            f := FileByIndex(i);
            fname := GetFileName(f);
            clb.Items.InsertObject(2, fname, f);
            if fname = 'The Amazing World of Bikini Armors REMASTERED.esp' then begin
                hasTAWOBA := true;
                fileTAWOBA := f;
            end else if fname = 'TAWOBA Remastered Leveled List.esp' then begin
                fileTAWOBALeveledList := f;
            end else if fname = 'pantiesofskyrim.esp' then begin
                hasPantiesofskyrim := true;
                filePantiesofskyrim := f;
            end else if fname = '[Imp] Modular Mage.esp' then begin
                hasModularMage := true;
                fileModularMage := f;
            end else if fname = '(Pumpkin)-TEWOBA-TheExpandedWorldofBikiniArmor.esp' then begin
                hasTEWOBA := true;
                fileTEWOBA := f;
            end else if fname = 'alagris_smash.esp' then begin
                destinationFile := f;
            end else if fname = 'Skyrim.esm' then begin
                fileSkyrim := f;
            end else if fname = 'unofficial skyrim special edition patch.esp' then begin
                fileUSSEP := f;
            end else if fname = '[COCO]Bikini Collection.esp' then begin
                fileCocoBikini := f;
            end else if fname = 'sirwho_Wizard_Hats-Full.esp' then begin 
                fileWizardHats := f;
            end else if fname = 'sirwho_Witchy_Wizard_Hats-Full.esp' then begin 
                fileWitchyHats := f;
            end else if fname = '[COCO]Lingerie.esp' then begin 
                fileCocoLingerie := f;
            end else if fname = '[COCO] Lace Lingerie Pack.esp' then begin 
                fileCocoLace := f;
            end else if fname = '[COCO] Witchiness.esp' then begin 
                fileCocoWitch := f;
            end else if fname = '[COCO] Demon Shade.esp' then begin   
                fileCocoDemon := f;
            end else if fname = '[COCO] Shadow Assassin.esp' then begin   
                fileCocoAssassin := f;
            end else if fname = '[Christine] DS Chosen Undead.esp' then begin   
                fileChristineUndead := f;
            end else if fname = '[Christine] Nocturnal''s Embrace.esp' then begin   
                fileChristineNocturnal := f;
            end else if fname = '[Christine] Black Magic Grove.esp' then begin   
                fileChristineBlackMagic := f;
            end else if fname = '[Christine] Deadly Desire.esp' then begin   
                fileChristineDeadlyDesire := f;
            end else if fname = '[Christine] High Priestess Bikini.esp' then begin   
                fileChristinePriestess := f;
            end else if fname = 'HS2_bunyCostume.esp' then begin 
                fileHS2Bunny := f;
            end else if fname = 'KSO Mage Robes.esp' then begin 
                fileKSOMage := f;
            end else if fname = 'ID_Skimpy Maid Outfits.esp' then begin 
                fileSkimpyMaid := f;
            end else if fname = 'DX Fetish Fashion Volume 1 SE.esp' then begin 
                fileDXFI := f;
            end else if fname = 'DX FetishFashion II.esp' then begin 
                fileDXFII := f;
            end else if fname = 'DX StLouis SE.esp' then begin 
                fileDXsT := f;
            end;
        end;
        if not Assigned(destinationFile) then begin
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
        end;
    finally
        frm.Free;
    end;
    // Nothing was selected
    if not Assigned(destinationFile) then begin
        Result := 1;
        Exit;
    end;
    outfitRecordGroup := GroupBySignature(destinationFile, 'OTFT');
    if not Assigned(outfitRecordGroup) then begin
        outfitRecordGroup := Add(destinationFile, 'OTFT', true);
    end;
    lvlnRecordGroup := GroupBySignature(destinationFile, 'LVLN');
    if not Assigned(lvlnRecordGroup) then begin
        lvlnRecordGroup := Add(destinationFile, 'LVLN', true);
    end;
    npcRecordGroup := GroupBySignature(destinationFile, 'NPC_');
    if not Assigned(npcRecordGroup) then begin
        npcRecordGroup := Add(destinationFile, 'NPC_', true);
    end;
    lvliRecordGroup := GroupBySignature(destinationFile, 'LVLI');
    if not Assigned(lvliRecordGroup) then begin
        lvliRecordGroup := Add(destinationFile, 'LVLI', true);
    end;
    Result := generate(destinationFile);
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
        Result := RecursiveCopyNPC(leveled_npc, false);
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
begin      
    (* CREATING NEW FEMALE-ONLY ARMOR BASED ON SOME RULES *)
    (* IT CHECKS WHAT ARMOR MODS ARE INSTALLED AND AUTOMATICALLY USES THEM *)
    recordSignature := Signature(oldOutfitRecord);
    isLVLI := recordSignature = 'LVLI';
    oldOutfitId := EditorID(oldOutfitRecord);
    isBandit := pos('Bandit', oldOutfitId) > 0;
    isBanditBoss := pos('Boss', oldOutfitId) > 0;
    pantiesFinal := nil;
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
        end else if StartsStr('hyd_', oldOutfitId) then begin
            newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'any_lingerie');
            if Assigned(newOutfitRef) then begin
                if ElementCount(oldOutfitItems) = 0 then begin
                    removeOldItem := true;
                end else begin
                    for i := ElementCount(oldOutfitItems)-1 downto 0 do begin
                        oldOutfitItem := ElementByIndex(oldOutfitItems, i);
                        removeOldItem := false; // checking if this is a slave 
                        oldItemId := GetEditValue(oldOutfitItem);
                        if StartsStr('zbf', oldItemId)  then begin
                            removeOldItem := true;
                            Break;
                        end;
                    end;
                end;
                if removeOldItem then begin
                    ElementAssign(newOutfitItems, HighInteger, newOutfitRef, false);  
                    exit;  
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
    if Assigned(pantiesItemId) then begin
        pantiesFinal := pantiesItemId;
    end;
    for i := ElementCount(oldOutfitItems)-1 downto 0 do begin
        oldOutfitItem := ElementByIndex(oldOutfitItems, i);
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
                    end;
                end;
            end else if StartsStr('Clothes', oldItemId) then begin
                if StartsStr('ClothesThalmor', oldItemId) then begin
                    oldItemPrefix := 'ClothesThalmor';
                    tawobaItemId := 'TWA Thalmor ';
                    pantiesItemId := 'Panties-ThalmorArmor';
                end else if StartsStr('ClothesRobes', oldItemId) then begin    
                end else if StartsStr('ClothesMonkRobes', oldItemId) then begin 
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHHP priestess');
                    if Assigned(fileChristinePriestess) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHHP priestess not found'); end;
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
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyNecromancerPrefix);
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(AnyNecromancerPrefix) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHHP priestess not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesNecromancerBoots' then begin
                        removeOldItem := Assigned(AnyNecromancerPrefix);
                    end;
                end else if StartsStr('ClothesCollege', oldItemId) then begin    
                end else if StartsStr('ClothesFarm', oldItemId) then begin    
                    oldItemPrefix := 'ClothesFarm';  
                    pantiesItemId := 'Panties-TheNine';
                end else if StartsStr('ClothesFine', oldItemId) then begin    
                    oldItemPrefix := 'ClothesFine';  
                    pantiesItemId := 'Panties-TheNine';
                end else if StartsStr('ClothesWench', oldItemId) then begin  
                    oldItemPrefix := 'ClothesWench';  
                    pantiesItemId := 'Panties-TheNine';
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'SkimpyMaidSet');
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                    if Assigned(fileSkimpyMaid) <> Assigned(newOutfitRef) then begin raise Exception.Create('SkimpyMaidSet not found'); end;
                    removeOldItem := Assigned(newOutfitRef);
                end else if StartsStr('ClothesMiner', oldItemId) then begin    
                    oldItemPrefix := 'ClothesMiner';  
                    pantiesItemId := 'Panties-TheNine';
                end else if StartsStr('ClothesJarl', oldItemId) then begin    
                    oldItemPrefix := 'ClothesJarl';  
                    pantiesItemId := 'Panties-Ebony';
                end else if StartsStr('ClothesBlackSmith', oldItemId) then begin    
                    oldItemPrefix := 'ClothesBlackSmith';  
                    pantiesItemId := 'Panties-TheNine';
                end else if StartsStr('ClothesBarKeeper', oldItemId) then begin    
                    oldItemPrefix := 'ClothesBarKeeper';  
                    pantiesItemId := 'Panties-General-Vendor';
                end else if StartsStr('ClothesMerchant', oldItemId) then begin    
                    oldItemPrefix := 'ClothesMerchant';  
                    pantiesItemId := 'Panties-Big Vendor';
                end else if StartsStr('ClothesBeggar', oldItemId) then begin
                    if oldItemId = 'ClothesBeggarRags' then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHUD Set');
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(fileChristineUndead) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHUD Set not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesBeggarHat' then begin
                    end else if oldItemId = 'ClothesBeggarBoots' then begin   
                    end;
                end else if StartsStr('ClothesPrisoner', oldItemId) then begin
                    if oldItemId = 'ClothesPrisonerRags' then begin
                        newOutfitRef := MainRecordByEditorID(GroupBySignature(fileChristineUndead, 'ARMO'), '00DSChosenUndeadLower');
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(fileChristineUndead) <> Assigned(newOutfitRef) then begin raise Exception.Create('00DSChosenUndeadLower not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesPrisonerTunic' then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHUD Set');
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(fileChristineUndead) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHUD Set not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                    end else if oldItemId = 'ClothesPrisonerShoes' then begin   
                    end;
                end else if StartsStr('ClothesWarlock', oldItemId) then begin    
                    if StartsStr('ClothesWarlockRobes', oldItemId) then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, AnyWarlockPrefix+'MagickaRate3');
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        if Assigned(AnyWarlockPrefix) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHUD Set not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
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
                    if (oldItemId = 'DBArmor') or (oldItemId = 'DBArmorShortSleeve') then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'COCO assassin');
                        if Assigned(fileCocoAssassin) <> Assigned(newOutfitRef) then begin raise Exception.Create('COCO assassin not found'); end;
                        removeOldItem := Assigned(newOutfitRef);
                        if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end; 
                    end else begin
                        removeOldItem := Assigned(fileCocoAssassin);
                    end;
                end else if StartsStr('DBClothes', oldItemId) then begin
                end;
            end else if StartsStr('Forsworn', oldItemId) then begin
                oldItemPrefix := 'Forsworn';
                pantiesItemId := 'Panties-Forsworn';
            end else if StartsStr('DLC1', oldItemId) then begin
                if StartsStr('DLC1Armor', oldItemId) then begin
                    if StartsStr('DLC1ArmorVampire', oldItemId) then begin
                        oldItemPrefix := 'DLC1ArmorVampire';
                        pantiesItemId := 'Panties-VampireBasicBlack';
                        if StartsStr('DLC1ArmorVampireArmor', oldItemId) then begin
                            oldItemPrefix := 'DLC1ArmorVampireArmor';
                            if (oldItemId = 'DLC1ArmorVampireArmorValerica') or (oldItemId = 'DLC1ArmorVampireArmorRoyalRed') then begin
                                newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHDD Set Ench');
                            end else begin
                                newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHDD Set');
                            end;
                            if Assigned(fileChristineDeadlyDesire) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHDD Set not found'); end;
                            removeOldItem := Assigned(newOutfitRef);
                            if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        end else begin
                            removeOldItem := Assigned(fileChristineDeadlyDesire);
                        end; 
                    end;
                end else if StartsStr('DLC1ClothesVampireLord', oldItemId) then begin
                    oldItemPrefix := 'DLC1ClothesVampireLord';
                    if StartsStr('DLC1ClothesVampireLordRoyal', oldItemId) then begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHDD Set Ench');
                    end else begin
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHDD Set');
                    end;
                    if Assigned(fileChristineDeadlyDesire) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHDD Set not found'); end;
                    removeOldItem := Assigned(newOutfitRef);
                    if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                end else if StartsStr('DLC1EnchClothesVampireRobes', oldItemId) then begin
                    if Assigned(fileChristineDeadlyDesire) then begin
                        oldItemPrefix := 'DLC1EnchClothesVampireRobes';
                        if Assigned(magicType) then begin
                            if StartsStr(oldItemPrefix+'Destruction', oldItemId) then begin    
                                magicType := 'Destruction';
                            end else if StartsStr(oldItemPrefix+'MagickaRate', oldItemId) then begin    
                                magicType := 'MagickaRate';
                            end else if StartsStr(oldItemPrefix+'Conjuration', oldItemId) then begin    
                                magicType := 'Conjuration';
                            end else begin
                                magicType := nil;
                            end;
                        end;
                        if not Assigned(magicType) then begin
                            raise Exception.Create('Couldn''t parse magic type: '+oldItemId);
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
                        newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHDD Set Ench'+magic_type+magicLevel);
                        removeOldItem := true;
                        if not Assigned(newOutfitRef) then begin raise Exception.Create('CHDD Set Ench'+magic_type+magicLevel+' not found'); end;
                        pantiesFinal := 'skip';
                    end;
                end;
            end else if StartsStr('DlC01ClothesVampire', oldItemId) then begin
                if oldItemId = 'DlC01ClothesVampire' then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHDD Set');
                    if Assigned(fileChristineDeadlyDesire) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHDD Set not found'); end;
                end else begin
                    removeOldItem := Assigned(fileChristineDeadlyDesire);
                end;
            end else if StartsStr('Armor', oldItemId) then begin
                if StartsStr('ArmorIron', oldItemId) then begin
                    if isBandit then begin
                        tawobaItemId := 'TWA Bandit Iron ';
                        pantiesItemId := 'Panties-Bandits';
                    end else begin
                        tawobaItemId := 'TWA Iron ';
                        pantiesItemId := 'Panties-Iron';
                    end;
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
                            newOutfitRef := MainRecordByEditorID(lvliRecordGroup, 'CHNE Set');
                            removeOldItem := Assigned(newOutfitRef);
                            if Assigned(fileChristineNocturnal) <> Assigned(newOutfitRef) then begin raise Exception.Create('CHNE Set'+magic_type+magicLevel+' not found'); end;
                            if Assigned(newOutfitRef) then begin pantiesFinal := 'skip'; end;
                        end;
                        
                    end;
                end else if StartsStr('ArmorLeather', oldItemId) then begin    
                    if isBandit then begin
                        tawobaItemId := 'TWA Bandit Leather ';
                        pantiesItemId := 'Panties-Bandits';
                    end else begin
                        tawobaItemId := 'TWA Leather ';
                        pantiesItemId := 'Panties-LeatherArmor';
                    end;
                    oldItemPrefix := 'ArmorLeather';
                end else if StartsStr('ArmorCompanions', oldItemId) then begin    
                    oldItemPrefix := 'ArmorCompanions';
                    tawobaItemId := 'TWA Wolf ';
                    pantiesItemId := 'Panties-Wolf';
                end else if StartsStr('ArmorBandit', oldItemId) then begin    
                    if isBanditBoss then begin
                        tawobaItemId := 'TWA Leather ';
                        pantiesItemId := 'Panties-Bandit-Boss';
                    end else begin
                        tawobaItemId := 'TWA Bandit Leather ';
                        pantiesItemId := 'Panties-Bandits';
                    end;
                    oldItemPrefix := 'ArmorBandit';
                end else if StartsStr('ArmorBlades', oldItemId) then begin    
                    tawobaItemId := 'TWA Blades ';
                    oldItemPrefix := 'ArmorBlades';
                    pantiesItemId := 'Panties-Blades';
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
            if (StartsStr('TWA ', tawobaItemId) and hasTAWOBA) or (StartsStr('TEW ', tawobaItemId) and hasTEWOBA) then begin
                removeOldItem := true;
                if StartsStr(oldItemPrefix+'Cuirass', oldItemId) or StartsStr(oldItemPrefix+'robes', oldItemId) then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Body');
                    pantiesFinal := 'skip';
                end else if StartsStr(oldItemPrefix+'Gauntlets', oldItemId) or StartsStr(oldItemPrefix+'Gloves', oldItemId) then begin    
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Gauntlets');
                end else if StartsStr(oldItemPrefix+'Boots', oldItemId) then begin    
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Boots');
                end else if StartsStr(oldItemPrefix+'Helmet', oldItemId) then begin    
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Helmet');
                end else begin
                    removeOldItem := false;
                    tawobaItemId := nil;
                end;
            end;
            if Assigned(pantiesItemId) and not Assigned(pantiesFinal) then begin
                pantiesFinal := pantiesItemId;
            end;
        end;
        if removeOldItem then begin
            newOutfitItem := ElementByIndex(newOutfitItems, i);
            if Assigned(newOutfitRef) then begin
                if isLVLI then begin
                    newOutfitItem := ElementByPath(newOutfitItem, 'LVLO\Reference');
                end;
                AddMessage('LVLI '+FullPath(newOutfitRecord)+': '+GetEditValue(newOutfitItem)+' -> '+EditorID(newOutfitRef));
                ElementAssign(newOutfitItem, LowInteger, newOutfitRef, false);
            end else begin
                AddMessage('LVLI '+FullPath(newOutfitRecord)+' -= '+GetEditValue(newOutfitItem));
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
begin
    Result := false;
    npc := ElementByPath(npc, 'Factions');
    for i:= 1 to ElementCount(npc) do begin
        f := EditorID(LinksTo(ElementByPath(ElementByIndex(npc, i), 'Faction')));
        if not Assigned(f) then begin
            raise Exception.Create('Error in isInFaction for '+FullPath(npc)+' at '+IntToStr(i));
        end;
        if f = faction then begin
            Result := true;
            exit;
        end;
    end;
end;


function RecursiveCopyNPC(selectedElement: IInterface; ignoreIfNotFemale:Boolean): IwbElement;
var
    selectedElementId: string;
    newOutfitRecord: IwbElement;
    defaultOutfitElement: IwbElement;
    oldOutfitRecord: IwbElement;
    newOutfitRecordId: string;
    femaleFlag: string;
    templateLoopsBackToMale: Boolean;
    i: integer;
begin
    selectedElementId := Signature(selectedElement);
    if selectedElementId <> 'NPC_' then exit;
    selectedElementId := EditorID(selectedElement);
    
    if not isFemale(selectedElement) then begin
        if ignoreIfNotFemale then begin
            AddMessage('NPC (ignore) '+EditorID(selectedElement)+' not female');
            exit;
        end;
        AddMessage('NPC '+EditorID(selectedElement)+' not female');
        if EndsStr('M', selectedElementId) then begin
            selectedElementId := copy(selectedElementId, 1, length(selectedElementId)-1);
        end;
        if not EndsStr('F', selectedElementId) then begin
            selectedElementId := selectedElementId+'F';
        end;
        newOutfitRecord := MainRecordByEditorID(npcRecordGroup, selectedElementId);
        if Assigned(newOutfitRecord) then begin            
            AddMessage('NPC (exists M2F) '+EditorID(selectedElement)+' -> '+EditorID(newOutfitRecord));
        end else begin
            newOutfitRecord := wbCopyElementToFileWithPrefix(selectedElement, destinationFile, true, true, '', '', '');
            SetEditorID(newOutfitRecord, selectedElementId);
            AddMessage('NPC (copied M2F) '+EditorID(selectedElement)+' -> '+EditorID(newOutfitRecord));
        end;
        selectedElement := newOutfitRecord;
    end;
    if GetFile(selectedElement) <> destinationFile then begin 
        newOutfitRecord := MainRecordByEditorID(npcRecordGroup, selectedElementId);
        if not Assigned(newOutfitRecord) then begin
            newOutfitRecord := wbCopyElementToFileWithPrefix(selectedElement, destinationFile, false, true, '', '', '');
            AddMessage('NPC copied from '+GetFileName(GetFile(selectedElement))+' to '+destinationFile);
        end;
        selectedElement := newOutfitRecord;
    end;
    if GetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory') = '1' then begin
        defaultOutfitElement := ElementByPath(selectedElement, 'TPLT');
        oldOutfitRecord := LinksTo(defaultOutfitElement);
        if not Assigned(oldOutfitRecord) then begin
            raise Exception.Create('Use Inventory = 1 despite having no template '+FullPath(selectedElement));
        end;
        templateLoopsBackToMale := EndsStr('M', EditorID(oldOutfitRecord)) and (EditorID(oldOutfitRecord) = copy(selectedElementId, 1, length(selectedElementId)-1)+'M');
        if templateLoopsBackToMale then begin
            defaultOutfitElement := ElementByPath(oldOutfitRecord, 'TPLT');
            oldOutfitRecord := LinksTo(defaultOutfitElement);
        end;
        if Assigned(defaultOutfitElement) then begin
            AddMessage(EditorID(selectedElement)+' calls RecursiveCopyLVLN('+Name(oldOutfitRecord)+')');
            newOutfitRecord := RecursiveCopyLVLN(oldOutfitRecord);
            AddMessage(FullPath(defaultOutfitElement)+'='+Name(LinksTo(defaultOutfitElement))+' -> '+Name(newOutfitRecord));
            if Assigned(newOutfitRecord) then begin
                SetEditValue(defaultOutfitElement, Name(newOutfitRecord));
            end;
        end;
    end else begin
    // if GetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory') = '1' then begin
    //   SetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory', '0');
    // end;
    
    // if templateLoopsBackToMale then begin
    //     defaultOutfitElement := ElementByPath(oldOutfitRecord, 'DOFT');
    //     if not Assigned(defaultOutfitElement) then begin
    //         defaultOutfitElement := ElementByPath(selectedElement, 'DOFT');
    //     end;
    // end else begin
    //     defaultOutfitElement := ElementByPath(selectedElement, 'DOFT');
    // end;
        defaultOutfitElement := ElementByPath(selectedElement, 'DOFT');
        if Assigned(defaultOutfitElement) then begin
            oldOutfitRecord := LinksTo(defaultOutfitElement);
            newOutfitRecord := CopyOutfit(oldOutfitRecord);
            AddMessage(EditorID(selectedElement)+':'+EditorID(oldOutfitRecord)+'->'+EditorID(newOutfitRecord)+'/'+Name(newOutfitRecord)); 
            SetEditValue(defaultOutfitElement, Name(newOutfitRecord));
        end else if isInFaction(selectedElement, 'zbfFactionSlave') then begin
            defaultOutfitElement := Add(selectedElement, 'DOFT', true);
            newOutfitRecord := MainRecordByEditorID(outfitRecordGroup, 'AnyLingerieOutfit');
            AddMessage(FullPath(defaultOutfitElement)+': naked -> '+EditorID(newOutfitRecord)); 
            SetEditValue(defaultOutfitElement, Name(newOutfitRecord));
        end;
    end;
    Result := selectedElement;
end;

function Process(selectedElement: IInterface): integer;
var
    recordSignature: string;
begin
   
    recordSignature := Signature(selectedElement);
    if recordSignature = 'NPC_' then RecursiveCopyNPC(selectedElement, true)
    else if recordSignature = 'LVLN' then RecursiveCopyLVLN(selectedElement)
    else if recordSignature = 'OTFT' then CopyOutfit(selectedElement)
    else if recordSignature = 'LVLI' then RecursiveCopyLVLI(selectedElement);
end;

end.
