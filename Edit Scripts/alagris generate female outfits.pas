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
    hasTAWOBA: Boolean;
    fileTAWOBA: IwbFile;
    fileTAWOBALeveledList: IwbFile;
    hasTEWOBA: Boolean;
    fileTEWOBA: IwbFile;
    hasModularMage: Boolean;
    fileModularMage: IwbFile;
    fileSkyrim: IwbFile;


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
    if Assigned(MainRecordByEditorID(GroupBySignature(destFile,'LVLI'), eID)) then begin
        exit;
    end;
    if Assigned(e) then RemoveByIndex(e, 0, true);
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


function GenerateModularMagePanty(destFile: IwbFile; e:IwbElement; templateSuffix, level, magic_type, ench:string): IwbMainRecord;
var
    template: IwbMainRecord;
    enchR: IwbMainRecord;
begin
    Result := MainRecordByEditorID(GroupBySignature(destFile, 'ARMO'), '_ModularMage'+level+templateSuffix+magic_type);
    if not Assigned(Result) then begin
        template := MainRecordByEditorID(GroupBySignature(fileModularMage, 'ARMO'), '_ModularMage'+level+templateSuffix);
        if Assigned(template) then begin
            enchR := MainRecordByEditorID(GroupBySignature(fileSkyrim, 'ENCH'), ench);
            if not Assigned(enchR) then begin // \ [00] Skyrim.esm \ [16] GRUP Top "ENCH" \ [95] EnchRobesCollegeConjuration01 "Fortify Conjuration" [ENCH:0010E300] \ [0] Record Header
                raise Exception.Create('Undefined enchantment '+ench);
            end;
            Result := wbCopyElementToFileWithPrefix(template, destFile, true, true, '', '', '');
            SetEditorID(Result, '_ModularMage'+level+templateSuffix+magic_type);
            SetElementEditValues(Result, 'TNAM', Name(template));
            SetElementEditValues(Result, 'EITM', Name(enchR));
            if magic_type = 'MagickaRate' then begin
                magic_type := '';
            end else begin
                magic_type := ' of '+magic_type;
            end;
            SetElementEditValues(Result, 'FULL', level+' '+templateSuffix+magic_type);
        end;
    end;
end;

function GenerateModularMagePantiesForMagicTypeAndLevel(destFile: IwbFile; e:IwbElement; level, magic_type, ench:string): IwbElement;
var
    i:integer;
    newEnchanted: IwbMainRecord;
begin
    e := newLVLI(e, destFile, 'MM_'+level+'MagePanties'+magic_type, '0', '0', '1', '1');
    newEnchanted := GenerateModularMagePanty(destFile, e, 'StringThong', level, magic_type, ench);
    if not Assigned(newEnchanted) then begin
        raise Exception.Create('Couldn''t find _ModularMage'+level+'StringThong in '+GetFileName(fileModularMage));
    end;
    assignToLVLI(e, newEnchanted, '1', '1');
    for i:= 1 to 8 do begin
        newEnchanted := GenerateModularMagePanty(destFile, e, 'Panties'+IntToStr(i), level, magic_type, ench);
        if Assigned(newEnchanted) then begin
            assignToLVLI(e, newEnchanted, '1', '1');
        end;
    end;
    e := newLVLI(e, destFile, 'MM_'+level+'MageSkirtCurtain'+magic_type, '0', '0', '1', '1');
    for  i:= 1 to 3 do begin
        newEnchanted := GenerateModularMagePanty(destFile, e, 'Skirt'+IntToStr(i), level, magic_type, ench);
        if Assigned(newEnchanted) then begin
            assignToLVLI(e, newEnchanted, '1', '1');
        end;
    end;
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
    e := newLVLI(e, destFile, 'MM_'+level+'MageSets'+magic_type, '0', '0', '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet1'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet2'+magic_type, '1', '1');
    addToLVLI_(destFile, e, 'LVLI', 'MM_'+level+'MageSet3'+magic_type, '1', '1');
    Result := e;
end;


function generate(destFile: IwbFile): integer;
var
    e:IwbElement;
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
    coco_lingerie := FileByName('[COCO]Lingerie.esp');
    coco_lace := FileByName('[COCO] Lace Lingerie Pack.esp');
    coco_bikini := fileCocoBikini;
    hs2_bunny := FileByName('HS2_bunyCostume.esp');
    modular_mage := fileModularMage;
    ussep := fileUSSEP;
    wizard_hats := fileWizardHats;
    tewoba := fileTEWOBA;
    tawoba := fileTAWOBA;
    tawoba_list := fileTAWOBALeveledList;
    if Assigned(tawoba_list) then begin
        //TODO uncomment this
        //raise Exception.Create('You should disable "'+GetFileName(tawoba_list)+'" to avoid conflicts!');
    end;
    if Assigned(wizard_hats) then begin
        AddMasterIfMissing(destFile, GetFileName(wizard_hats));
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
        addToLVLI_(destFile, e, 'LVLI', 'bikini3a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini3b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini5a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini5b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini6a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini6b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini6c', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini7a', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini7b', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini8', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini9', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini1', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini2', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'bikini4', '1', '1');
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
    end;
    if Assigned(modular_mage) then begin
        AddMasterIfMissing(destFile, GetFileName(modular_mage));
        e := GenerateModularMage(destFile, e);
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Draugr', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Daedric', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Dragonscale', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Glass', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Imperial', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Imperial', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Scaled', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-LeatherArmor', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Leather Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Leather Accessories', '3', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Bandits', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Hide', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Hide Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Hide Accessories', '3', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Bandits', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Wolf', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-DragonBone', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Ebony', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Dwarven', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Iron', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Iron Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Iron Accessories', '3', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Bandits', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Steel', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Steel Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Steel Accessories', '3', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Bandits', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'ARMO', 'Panty-ThongOpenFur-Nordic_Carved', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Nord Plate Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nord Plate Accessories', '3', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Bandits', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'ARMO', 'Panty-ThongOpenFur-Nordic_Carved', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Nordic Carved Body', '0', '1', '0', '0');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Armors', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Thongs', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Pauldron', '2', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Thigh Tasset and Abs', '4', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Nordic Carved Accessories', '3', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Bandits', '1', '1');
        e := newLVLI(e, destFile, 'TWA Bandit Sets Body', '0', '0', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Bandit Leather Body', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Bandit Iron Body', '1', '1');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Bandit Steel Body', '1', '5');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Bandit Nord Plate Body', '1', '14');
        addToLVLI_(destFile, e, 'LVLI', 'TWA Bandit Nordic Carved Body', '1', '25');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Elven', '1', '1');
        e := newLVLI(e, destFile, 'TWA Thalmor Body', '25', '0', '1', '0');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_gorge_1tha', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_robe_1', '1', '1');
        addToLVLI(destFile, e, tawoba, 'ARMO', '00EVB_thong_1tha', '1', '1');
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-ThalmorArmor', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Blades', '1', '1');
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
        if Assigned(panties) then addToLVLI(destFile, e, panties, 'LVLI', 'Panties-Orcish', '1', '1');
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
            end else if fname = 'slave girls SPID.esp' then begin
                destinationFile := f;
            end else if fname = 'Skyrim.esm' then begin
                fileSkyrim := f;
            end else if fname = 'unofficial skyrim special edition patch.esp' then begin
                fileUSSEP := f;
            end else if fname = '[COCO]Bikini Collection.esp' then begin
                fileCocoBikini := f;
            end else if fname = 'sirwho_Wizard_Hats-Simple.esp' then begin
                fileWizardHats := f;
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
        Result := RecursiveCopyNPC(leveled_npc);
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
    if isLVLI then begin 
        newItem := Add(newItems, 'Leveled List Entry', true);
        AddMessage('LVLI (transfer) '+FullPath(newItem)+'='+GetElementEditValues(newItem, 'LVLO\Reference')+' -> '+EditorID(newItemReference)+' ['+FullPath(oldItem)+']');
        SetElementNativeValues(newItem, 'LVLO\Count', GetElementNativeValues(oldItem, 'LVLO\Count'));
        SetElementNativeValues(newItem, 'LVLO\Level', GetElementNativeValues(oldItem, 'LVLO\Level'));
        ElementAssign(ElementByPath(newItem, 'LVLO\Reference'), LowInteger, newItemReference, false);
    end else begin
        AddMessage('OTFT (transfer) '+GetEditValue(newItem)+' -> '+EditorID(newItemReference));
        newOutfitItem := ElementAssign(newItems, HighInteger, newItemReference, false);    
    end;
end;

function AddPanties(newItems: IwbElement; panties:string): IwbElement;
var
    newItem: IwbElement;
begin
    if Assigned(filePantiesofskyrim) then begin
        newItem := MainRecordByEditorID(GroupBySignature(filePantiesofskyrim, 'LVLI'), 'Panties-'+panties);
        if not Assigned(newItem) then raise Exception.Create("Panties not found: "+panties);
        AddMessage('OTFT (panties) '+FullPath(newItems)+' -> '+EditorID(newItem));
        Result := ElementAssign(newItems, HighInteger, newItem, false);    
    end;
end;

function ModifyFemaleOutfit(oldOutfitRecord, newOutfitRecord: IwbElement): IwbElement;
var
    isLVLI: Boolean;
    oldItemId: string;
    oldItemPrefix: string;
    tawobaItemId: string;
    pantiesItemId: string;
    pantiesItemId: string;
    i: integer;
    oldOutfitRef: IwbElement;
    oldOutfitItems: IwbElement;
    oldOutfitItem: IwbElement;
    newOutfitItems: IwbElement;
    newOutfitItem: IwbElement;
    newOutfitRef: IwbElement;
    newOutfitId: string;
    femaleLVLI: IwbElement;
    recordSignature: string;
    recGrp: IwbGroupRecord;
    removeOldItem: Boolean;
    isBandit: Boolean;
    isBanditBoss: Boolean;
begin      
    (* CREATING NEW FEMALE-ONLY ARMOR BASED ON SOME RULES *)
    (* IT CHECKS WHAT ARMOR MODS ARE INSTALLED AND AUTOMATICALLY USES THEM *)
    recordSignature := Signature(oldOutfitRecord);
    isLVLI := recordSignature = 'LVLI';
    newOutfitId := EditorID(newOutfitRecord);
    isBandit := pos('Bandit', newOutfitId) > 0;
    isBanditBoss := pos('Boss', newOutfitId) > 0;
    if isLVLI then begin
        oldOutfitItems := ElementByPath(oldOutfitRecord, 'Leveled List Entries');
        newOutfitItems := ElementByPath(newOutfitRecord, 'Leveled List Entries');
    end else begin
        oldOutfitItems := ElementByPath(oldOutfitRecord, 'INAM');
        newOutfitItems := ElementByPath(newOutfitRecord, 'INAM');

        if StartsStr('Armor', newOutfitId) then begin
            if StartsStr('ArmorStormcloak', newOutfitId) then begin
                if StartsStr('ArmorStormcloakMarkarth', newOutfitId) then begin
                    AddPanties(newOutfitItems, 'TheReach');    
                end else if StartsStr('ArmorStormcloakRiften', newOutfitId) then begin
                    AddPanties(newOutfitItems, 'TheRift');    
                end else begin
                    AddPanties(newOutfitItems, 'Stormcloak');    
                end;
            end else if StartsStr('ArmorHaafingar', newOutfitId) then begin
                AddPanties(newOutfitItems, 'Haafingar');    
            end else if StartsStr('ArmorSummerset', newOutfitId) then begin
                AddPanties(newOutfitItems, 'Summerset');    
            end;
        end else if StartsStr('Clothes', newOutfitId) then begin
            AddMessage("UNIMPLEMENTED");
        end;
    end;
    
    for i := ElementCount(oldOutfitItems)-1 downto 0 do begin
        oldOutfitItem := ElementByIndex(oldOutfitItems, i);
        if isLVLI then begin
            oldOutfitRef := ElementByPath(oldOutfitItem, 'LVLO\Reference');
        end else begin
            oldOutfitRef := oldOutfitItem
        end;
        oldOutfitRef := LinksTo(oldOutfitRef);
        newOutfitRef := nil;
        removeOldItem := false;
        if Signature(oldOutfitRef) = 'LVLI' then begin
            newOutfitRef := RecursiveCopyLVLI(oldOutfitRef);
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
            end else if StartsStr('DLC2', oldItemId) then begin
                if StartsStr('DLC2ArmorNordicHeavy', oldItemId) then begin
                    tawobaItemId := 'TWA Nordic Carved ';
                    oldItemPrefix := 'DLC2ArmorNordicHeavy';
                    pantiesItemId := 'Panties-Bandit-Boss';    
                end;
            end else if StartsStr('Draugr', oldItemId) then begin
                tawobaItemId := 'TEW Ancient Nord ';
                oldItemPrefix := 'Draugr';
                pantiesItemId := 'Panties-Draugr';
            end else if StartsStr('EnchClothes', oldItemId) then begin
                if StartsStr('EnchClothesRobesMage', oldItemId) then begin
                    
                end else if StartsStr('EnchClothesNecroRobes', oldItemId) then begin    
                    if StartsStr('EnchClothesNecroRobesHooded', oldItemId) then begin 
                        AddMessage("UNIMPLEMENTED");   
                    end else begin
                        AddMessage("UNIMPLEMENTED");
                    end;
                end else if StartsStr('EnchClothesWarlockRobes', oldItemId) then begin    
                    AddMessage("UNIMPLEMENTED");
                end;
            end else if StartsStr('Clothes', oldItemId) then begin
                if StartsStr('ClothesThalmor', oldItemId) then begin
                    oldItemPrefix := 'ClothesThalmor';
                    tawobaItemId := 'TWA Thalmor ';
                    pantiesItemId := 'Panties-ThalmorArmor';
                end else if StartsStr('ClothesRobes', oldItemId) then begin    
                    AddMessage("UNIMPLEMENTED");
                end else if StartsStr('ClothesCollege', oldItemId) then begin    
                    AddMessage("UNIMPLEMENTED");
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
            if (StartsStr('TAW ', tawobaItemId) and hasTAWOBA) or (StartsStr('TEW ', tawobaItemId) and hasTEWOBA) then begin
                removeOldItem := true;
                if StartsStr(oldItemPrefix+'Cuirass', oldItemId) then begin
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Body');
                end else if StartsStr(oldItemPrefix+'Gauntlets', oldItemId) then begin    
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Gauntlets');
                end else if StartsStr(oldItemPrefix+'Boots', oldItemId) then begin    
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Boots');
                end else if StartsStr(oldItemPrefix+'Helmet', oldItemId) then begin    
                    newOutfitRef := MainRecordByEditorID(lvliRecordGroup, tawobaItemId+'Helmet');
                end else begin
                    removeOldItem := false;
                    tawobaItemId := nil;
                end;
            end else if Assigned(pantiesItemId) and hasPantiesofskyrim then begin
                // add panties only if TAWOBA/TEWOBA hasn't added them already
                recGrp := GroupBySignature(filePantiesofskyrim, 'LVLI');
                newOutfitRef := MainRecordByEditorID(recGrp, pantiesItemId);
            end;
        end;
        if removeOldItem then begin
            newOutfitItem := ElementByIndex(newOutfitItems, i);
            if Assigned(newOutfitRef) then begin
                if isLVLI then begin
                    newOutfitItem := ElementByPath(newOutfitItem, 'LVLO\Reference');
                end;
                AddMessage('LVLI '+GetPath(newOutfitRecord)+': '+GetEditValue(newOutfitItem)+' -> '+EditorID(newOutfitRef));
                ElementAssign(newOutfitItem, LowInteger, femaleLVLI, false);
            end else begin
                RemoveElement(newOutfitItems, newOutfitItem);
            end;
        end else begin
            if Assigned(newOutfitRef) then begin
                AddMessage('LVLI '+GetPath(newOutfitRecord)+' += '+EditorID(newOutfitRef)+' (like '+EditorID(oldOutfitItem)+')');
                TransferListElement(oldOutfitItem, newOutfitItems, newOutfitRef, isLVLI);
            end;
        end;
        
    end; 

end;


function RecursiveCopyNPC(selectedElement: IInterface, ignoreIfNotFemale:Boolean=false): IwbElement;
var
    recordSignature: string;
    newOutfitRecord: IwbElement;
    defaultOutfitElement: IwbElement;
    oldOutfitRecord: IwbElement;
    newOutfitRecordId: string;
    femaleFlag: string;
begin
    recordSignature := Signature(selectedElement);
    if recordSignature <> 'NPC_' then exit;
    recordSignature := EditorID(selectedElement);
    femaleFlag := GetElementEditValues(selectedElement, 'ACBS - Configuration\Flags\Female');
    AddMessage('NPC '+EditorID(selectedElement)+':female='+femaleFlag);
    if femaleFlag <> '1' then begin
        if ignoreIfNotFemale then exit;
        if EndsStr('M', recordSignature) then begin
            recordSignature := copy(recordSignature, 1, length(recordSignature)-1);
        end;
        if not EndsStr('F', recordSignature) then begin
            recordSignature := recordSignature+'F';
        end;
        newOutfitRecord := MainRecordByEditorID(npcRecordGroup, recordSignature);
        if Assigned(newOutfitRecord) then begin            
            AddMessage('NPC (exists M2F) '+EditorID(selectedElement)+' -> '+EditorID(newOutfitRecord));
        end else begin
            newOutfitRecord := wbCopyElementToFileWithPrefix(selectedElement, destinationFile, true, true, '', '', '');
            SetEditorID(newOutfitRecord, recordSignature);
            AddMessage('NPC (copied M2F) '+EditorID(selectedElement)+' -> '+EditorID(newOutfitRecord));
        end;
        selectedElement := newOutfitRecord;
    end;
    if GetFile(selectedElement) <> destinationFile then begin 
        newOutfitRecord := MainRecordByEditorID(npcRecordGroup, recordSignature);
        if not Assigned(newOutfitRecord) then begin
            newOutfitRecord := wbCopyElementToFileWithPrefix(selectedElement, destinationFile, false, true, '', '', '');
            AddMessage('NPC copied from '+GetFileName(GetFile(selectedElement))+' to '+destinationFile);
        end;
        selectedElement := newOutfitRecord;
    end;
    defaultOutfitElement := ElementByPath(selectedElement, 'TPLT');
    if Assigned(defaultOutfitElement) then begin
        oldOutfitRecord := LinksTo(defaultOutfitElement);
        AddMessage(EditorID(selectedElement)+' calls RecursiveCopyLVLN('+Name(oldOutfitRecord)+')');
        newOutfitRecord := RecursiveCopyLVLN(oldOutfitRecord);
        AddMessage(FullPath(defaultOutfitElement)+'='+Name(LinksTo(defaultOutfitElement))+' -> '+Name(newOutfitRecord));
        if Assigned(newOutfitRecord) then begin
            SetEditValue(defaultOutfitElement, Name(newOutfitRecord));
        end;
    end;
    
    (*if GetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory') = '1' then begin
      SetElementEditValues(selectedElement, 'ACBS\Template Flags\Use Inventory', '0');
    end;*)
    defaultOutfitElement := ElementByPath(selectedElement, 'DOFT');
    if Assigned(defaultOutfitElement) then begin
        oldOutfitRecord := LinksTo(defaultOutfitElement);
        newOutfitRecord := CopyOutfit(oldOutfitRecord);
        AddMessage(EditorID(selectedElement)+':'+EditorID(oldOutfitRecord)+'->'+EditorID(newOutfitRecord)+'/'+Name(newOutfitRecord)); 
        SetEditValue(defaultOutfitElement, Name(newOutfitRecord));
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
