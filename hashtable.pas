(* implement a hash table using open addressing *)
unit hashtable;

interface

type
    Slot = record
        Key : String[80];
        Value : String[80]
    end;

type
    HT = record
        Size, Items : Integer;
        Load : Real;
        Slots : Array of Slot
    end;

function GetKey() : String;
function GetValue() : String;
function Hash (Str : String) : LongWord;
function InitTable () : HT;
function AddRecord (T : HT; Key, Value : String) : HT;
function LookUp (T: HT; Key : String) : String;
procedure PrintTable (T : HT);

implementation

function GetKey () : String;
    begin
        write ('Key: ');
        readln (GetKey)
    end;

function GetValue () : String;
    begin
        write ('Value: ');
        readln (GetValue)
    end;

function Hash (Str : String) : LongWord;
    var
        Count : Integer;
    begin
        Hash := 0;
        for Count := 1 to length(Str) do
            Hash := Hash + 31 * ord(Str[Count])
    end;

function InitTable () : HT;
    var
        T : HT;
    begin
        T.Size := 4;
        T.Items := 0;
        T.Load := 0.0;
        SetLength (T.Slots, T.Size);
        InitTable := T
    end;

function RebuildTable (T : HT) : HT;
    var
        Idx : Integer;
        TNew : HT;
    begin
        writeln ('rebuilding hash table');
        TNew.Size := 2 * T.Size;
        TNew.Items := 0;
        TNew.Load := 0.0;
        SetLength (TNew.Slots, TNew.Size);
        (* PrintTable (TNew); *)
        for Idx := 0 to T.Size - 1 do
            if T.Slots[Idx].Key <> '' then
                TNew := AddRecord (TNew, T.Slots[Idx].Key, T.Slots[Idx].Value);
        writeln ('done rebuilding hash table');
        RebuildTable := TNew
    end;

function FindSlot (T : HT; Key : String) : LongWord;
    var
        Idx : LongWord;
    begin
        Idx := Hash (Key) mod T.Size;
        (* search until we either find the key, or find an empty slot. *)
        while (T.Slots[Idx].Key <> '') and (T.Slots[Idx].Key <> Key) do
            Idx := (Idx + 1) mod T.Size;
        FindSlot := Idx
    end;

function AddRecord (T : HT; Key, Value : String) : HT;
    var
        Idx : LongWord;
    begin
        Idx := FindSlot (T, Key);
        if T.Slots[Idx].Key <> '' then (* we found our key *)
            begin
                T.Slots[Idx].Value := Value;
                AddRecord := T;
                exit
            end;
        if T.Load >= 0.75 then
            begin
                T := RebuildTable (T);
                Idx := FindSlot (T, Key)
            end;
        T.Slots[Idx].Key := Key;
        T.Slots[Idx].Value := Value;
        T.Items := T.Items + 1;
        T.Load := T.Items / T.Size;
        PrintTable (T);
        AddRecord := T
    end;

function LookUp (T : HT; Key : String) : String;
    var
        Idx : LongWord;
    begin
        Idx := FindSlot (T, Key);
        if (T.Slots[Idx].Key <> '') then
            LookUp := T.Slots[Idx].Value
        else
            LookUp := 'Not found.'
    end;

procedure PrintTable (T : HT);
    var
        Idx : Integer;
    begin
        writeln ('Size = ', T.Size, ', Items = ', T.Items, ', Load = ', T.Load);
        for Idx := 0 to T.Size - 1 do
            writeln ('Table[', Idx, '] = ', T.Slots[Idx].Key, ': ', T.Slots[Idx].Value)
    end;

end.
