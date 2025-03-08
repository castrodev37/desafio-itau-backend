unit Challenge.Itau.Model.Transaction;

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs;

type
  TChallengeItauModelTransaction = class
  private
    class var FInstance: TChallengeItauModelTransaction;
    class var FCriticalSection: TCriticalSection; // Para thread safety
    FValue: Currency;
    FDate: TDateTime;

    constructor Create;

    procedure SetValue(const Value: Currency);
    function GetValue: Currency;
  public
    class function GetTransactionModel: TChallengeItauModelTransaction;
    class procedure DestroyTransactionModel;

    function GetDate: TDateTime;
    procedure SetDate(const AValue: string);
    property Value: Currency read GetValue write SetValue;
  end;

implementation

{ TChallengeItauModelTransaction }

constructor TChallengeItauModelTransaction.Create;
begin

end;

class procedure TChallengeItauModelTransaction.DestroyTransactionModel;
begin
  FCriticalSection.Enter;
  try
    if Assigned(FInstance) then
    begin
      FInstance.Free;
      FInstance := nil;
    end;
  finally
    FCriticalSection.Leave;
  end;

  if Assigned(FCriticalSection) then
  begin
    FCriticalSection.Free;
    FCriticalSection := nil;
  end;
end;

function TChallengeItauModelTransaction.GetDate: TDateTime;
begin
  Result := FDate;
end;

class function TChallengeItauModelTransaction.GetTransactionModel: TChallengeItauModelTransaction;
begin
  if FCriticalSection = nil then
    FCriticalSection := TCriticalSection.Create;

  FCriticalSection.Enter; // Bloqueia para garantir acesso exclusivo
  try
    if not Assigned(FInstance) then
      FInstance := TChallengeItauModelTransaction.Create;
    Result := FInstance;
  finally
    FCriticalSection.Leave; // Libera o bloqueio
  end;
end;

function TChallengeItauModelTransaction.GetValue: Currency;
begin
  Result := FValue;
end;

procedure TChallengeItauModelTransaction.SetDate(const AValue: string);
var
  LFormatSettings: TFormatSettings;
begin
  if AValue.IsNullOrEmpty(AValue) then
    raise Exception.Create('Data inv�lida para uma transa��o');

  LFormatSettings := TFormatSettings.Create;
  LFormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  LFormatSettings.LongTimeFormat := 'hh:mm:ss';
  LFormatSettings.DateSeparator := '-';
  LFormatSettings.TimeSeparator := ':';

  try
    FDate := StrToDateTime(AValue, LFormatSettings);
  except
    on E: Exception do
      raise Exception.Create('Erro ao converter: ' + E.Message);
  end;
end;

procedure TChallengeItauModelTransaction.SetValue(const Value: Currency);
begin
  if Value = 0 then
    raise Exception.Create('Valor inv�lido para uma transa��o');
  FValue := Value;
end;

initialization

finalization
  TChallengeItauModelTransaction.DestroyTransactionModel;

end.
