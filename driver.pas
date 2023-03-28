program Driver;

uses hashtable;

var
    Key, Value : String;
    Table : HT;

begin
    Table := InitTable();
    Key := GetKey;
    while (Key <> '') do
        begin
            Value := GetValue;
            Table := AddRecord (Table, Key, Value);
            Key := GetKey
        end;
    PrintTable (Table);
    Key := GetKey;
    while (Key <> '') do
        begin
            Value := LookUp (Table, Key);
            writeln (Value);
            Key := GetKey
        end
end.
