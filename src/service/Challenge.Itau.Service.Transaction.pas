unit Challenge.Itau.Service.Transaction;

interface

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  System.Generics.Collections,
  Challenge.Itau.Model.Transaction,
  Challenge.Itau.Model.TransactionList,
  Challenge.Itau.Model.Exceptions;

type
  TChallengeItauServiceTransaction = class
  private
    function ParseJSONToDouble(AKey: string; AValue: TJSONObject): Double;
    function ParseJSONToString(AKey: string; AValue: TJSONObject): string;

    procedure InsertTransaction(ATransaction: TJSONObject);
    procedure JSONSchemaValidate(AValue: TJSONObject);
  public
    procedure Insert(ATransaction: TJSONObject);
    procedure Delete;

    function Statistics: TJSONObject;
  end;

const
  cVALOR = 'valor';
  cDATA_HORA = 'dataHora';
  cBODY_KEYS: array[1..2] of string = (cVALOR, cDATA_HORA);

implementation

{ TChallengeItauServiceTransaction }

procedure TChallengeItauServiceTransaction.Delete;
begin
  TChallengeItauModelTransactionList.List.Clear;
end;

procedure TChallengeItauServiceTransaction.Insert(ATransaction: TJSONObject);
begin
  if not Assigned(ATransaction) then
    raise EJSONValidationError.Create('JSON inválido');

  JSONSchemaValidate(ATransaction);
  InsertTransaction(ATransaction);
end;

procedure TChallengeItauServiceTransaction.InsertTransaction(ATransaction: TJSONObject);
var
  LTransaction: TChallengeItauModelTransaction;
begin
  LTransaction := TChallengeItauModelTransaction.Create;
  LTransaction.Value := ParseJSONToDouble(cVALOR, ATransaction);
  LTransaction.SetDate(ParseJSONToString(cDATA_HORA, ATransaction));
  TChallengeItauModelTransactionList.List.Add(LTransaction);
end;

procedure TChallengeItauServiceTransaction.JSONSchemaValidate(AValue: TJSONObject);
var
  LEnumerator: TJSONPairEnumerator;
  I: Integer;
begin
  LEnumerator := AValue.GetEnumerator;
  while LEnumerator.MoveNext do
    for I := Low(cBODY_KEYS) to High(cBODY_KEYS) do
      if (AValue.GetValue(cBODY_KEYS[I]) = nil) then
        raise EValidationError.Create('Body formatting error: ' + cBODY_KEYS[I] + ' é obrigatório');
end;

function TChallengeItauServiceTransaction.ParseJSONToString(AKey: string; AValue: TJSONObject): string;
var
  LJSONValue: TJSONValue;
begin
  Result := EmptyStr;
  if AValue.TryGetValue(AKey, LJSONValue) then
    Result := LJSONValue.ToString;
end;

function TChallengeItauServiceTransaction.Statistics: TJSONObject;
var
  LTransaction: TChallengeItauModelTransaction;
  LCount, LMinute: Integer;
  LCurrentDate: TDateTime;
  LSum, LMin, LMax: Currency;
  LAvg: Double;
begin
  Result := TJSONObject.Create;
  LCurrentDate := Now;

  LCount := 0;
  LSum := 0;
  LMin := MaxCurrency;
  LMax := -MaxCurrency;

  for LTransaction in TChallengeItauModelTransactionList.List do
  begin
    LMinute := SecondsBetween(LCurrentDate, LTransaction.GetDate);
    if not ((LMinute >= 0) and (LMinute <= 60)) then
      Continue;
    Inc(LCount);
    LSum := LSum + LTransaction.Value;
    if LTransaction.Value < LMin then
      LMin := LTransaction.Value;
    if LTransaction.Value > LMax then
      LMax := LTransaction.Value;
  end;

  if LCount > 0 then
    LAvg := LSum / LCount
  else
  begin
    LAvg := 0;
    LMin := 0;
    LMax := 0;
  end;

  Result
    .AddPair('count', TJSONNumber.Create(LCount))
    .AddPair('sum', TJSONNumber.Create(LSum))
    .AddPair('avg', TJSONNumber.Create(LAvg))
    .AddPair('min', TJSONNumber.Create(LMin))
    .AddPair('max', TJSONNumber.Create(LMax));
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
