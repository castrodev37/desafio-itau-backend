unit Challenge.Itau.Service.Transaction;

interface

uses
  System.SysUtils,
  System.JSON,
  Challenge.Itau.Model.Transaction;

type
  TChallengeItauServiceTransaction = class
  private
    function ParseJSONToDouble(AKey: string; AValue: TJSONObject): Double;
    function ParseJSONToString(AKey: string; AValue: TJSONObject): string;

    procedure InsertTransaction(ATransaction: TJSONObject; AStatusJSONObject: TJSONObject);
    procedure JSONSchemaValidate(AValue: TJSONObject);
  public
    function Insert(ATransaction: TJSONObject): TJSONObject;
  end;

const
  cVALOR = 'valor';
  cDATA_HORA = 'dataHora';
  cBODY_KEYS: array[1..2] of string = (cVALOR, cDATA_HORA);

implementation

{ TChallengeItauServiceTransaction }

function TChallengeItauServiceTransaction.Insert(ATransaction: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.Create;

  if not Assigned(ATransaction) then
  begin
    Result.AddPair('status', 'Invalid JSON');
    Exit;
  end;

  JSONSchemaValidate(ATransaction);
  try
    InsertTransaction(ATransaction, Result);
  except
    raise;
  end;
end;

procedure TChallengeItauServiceTransaction.InsertTransaction(ATransaction: TJSONObject; AStatusJSONObject: TJSONObject);
var
  LTransactionModel: TChallengeItauModelTransaction;
begin
  LTransactionModel := TChallengeItauModelTransaction.GetTransactionModel;
  try
    LTransactionModel.Value := ParseJSONToDouble(cVALOR, ATransaction);
    LTransactionModel.SetDate(ParseJSONToString(cDATA_HORA, ATransaction));
    AStatusJSONObject.AddPair('status', 'created');
  except
    on E: Exception do
      raise;
  end;
end;

procedure TChallengeItauServiceTransaction.JSONSchemaValidate(AValue: TJSONObject);
var
  LEnumerator: TJSONPairEnumerator;
  I: Integer;
begin
  LEnumerator := AValue.GetEnumerator;
  try
    while LEnumerator.MoveNext do
    for I := Low(cBODY_KEYS) to High(cBODY_KEYS) do
      if (AValue.GetValue(cBODY_KEYS[I]) = nil) then
        raise Exception.Create('Body formatting error');
  except
    on E: Exception do
      raise;
  end;
end;

function TChallengeItauServiceTransaction.ParseJSONToString(AKey: string; AValue: TJSONObject): string;
var
  LJSONValue: TJSONValue;
begin
  Result := EmptyStr;
  if AValue.TryGetValue(AKey, LJSONValue) then
    Result := LJSONValue.ToString;
end;

function TChallengeItauServiceTransaction.ParseJSONToDouble(AKey: string; AValue: TJSONObject): Double;
var
  LJSONValue: TJSONValue;
begin
  Result := 0;
  if AValue.TryGetValue(AKey, LJSONValue) then
    if LJSONValue is TJSONNumber then
      Result := TJSONNumber(LJSONValue).AsDouble;
end;

end.
